import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verleihapp/l10n/app_localizations.dart';

import 'package:verleihapp/models/location_dto.dart';

class LocationUtils {
  /// Map of supported country codes to their translation keys
  static const Map<String, String> supportedCountries = {
    'DE': 'country_DE',
    'AT': 'country_AT',
    'CH': 'country_CH',
    'GB': 'country_GB',
    'IE': 'country_IE',
    'US': 'country_US',
    'CA': 'country_CA',
    'AU': 'country_AU',
    'NZ': 'country_NZ',
    'NO': 'country_NO',
    'SE': 'country_SE',
    'PL': 'country_PL',
    'CZ': 'country_CZ',
    'NL': 'country_NL',
    'BE': 'country_BE',
    'LU': 'country_LU',
    'FR': 'country_FR',
    'IT': 'country_IT',
    'ES': 'country_ES',
  };

  /// Gets the localized country name for a given country code
  static String getCountryName(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context)!;
    final key = supportedCountries[code];
    if (key == null) return code;

    switch (code) {
      case 'DE': return l10n.country_DE;
      case 'AT': return l10n.country_AT;
      case 'CH': return l10n.country_CH;
      case 'GB': return l10n.country_GB;
      case 'IE': return l10n.country_IE;
      case 'US': return l10n.country_US;
      case 'CA': return l10n.country_CA;
      case 'AU': return l10n.country_AU;
      case 'NZ': return l10n.country_NZ;
      case 'NO': return l10n.country_NO;
      case 'SE': return l10n.country_SE;
      case 'PL': return l10n.country_PL;
      case 'CZ': return l10n.country_CZ;
      case 'NL': return l10n.country_NL;
      case 'BE': return l10n.country_BE;
      case 'LU': return l10n.country_LU;
      case 'FR': return l10n.country_FR;
      case 'IT': return l10n.country_IT;
      case 'ES': return l10n.country_ES;
      default: return code;
    }
  }

  /// Regular expressions describing a "complete" postal code per country.
  /// Used only to decide whether an automatic lookup should be triggered
  /// while the user is still typing (debounced), not for final validation.
  static final Map<String, RegExp> _postalCodePatterns = {
    'DE': RegExp(r'^\d{5}$'),
    'AT': RegExp(r'^\d{4}$'),
    'CH': RegExp(r'^\d{4}$'),
    'US': RegExp(r'^\d{5}(-\d{4})?$'),
    'CA': RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$'),
    'AU': RegExp(r'^\d{4}$'),
    'NZ': RegExp(r'^\d{4}$'),
    'NO': RegExp(r'^\d{4}$'),
    'SE': RegExp(r'^\d{3}\s?\d{2}$'),
    'PL': RegExp(r'^\d{2}-?\d{3}$'),
    'CZ': RegExp(r'^\d{3}\s?\d{2}$'),
    'NL': RegExp(r'^\d{4}\s?[A-Za-z]{2}$'),
    'BE': RegExp(r'^\d{4}$'),
    'LU': RegExp(r'^\d{4}$'),
    'FR': RegExp(r'^\d{5}$'),
    'IT': RegExp(r'^\d{5}$'),
    'ES': RegExp(r'^\d{5}$'),
    // GB and IE have highly variable formats and are intentionally omitted;
    // callers fall back to the default heuristic below for those.
  };

  /// In-flight/completed lookups keyed by country code + postal code.
  /// Prevents duplicate Nominatim calls for the same input (e.g. triggered
  /// by both losing focus and pressing the search button), and avoids
  /// re-fetching a result that is already known, including "not found".
  static final Map<String, Future<PostalLookupResult?>> _lookupCache = {};

  static String _cacheKey(String countryCode, String postalCode) {
    return '${countryCode.trim().toUpperCase()}|${postalCode.trim().toUpperCase()}';
  }

  /// Returns whether [postalCode] looks complete for [countryCode], i.e.
  /// whether it is worth triggering an automatic lookup already.
  /// Falls back to a minimum length heuristic for countries without a
  /// known fixed format.
  static bool isPostalCodeComplete(String countryCode, String postalCode) {
    final trimmed = postalCode.trim();
    final pattern = _postalCodePatterns[countryCode.trim().toUpperCase()];
    if (pattern == null) return trimmed.length >= 3;
    return pattern.hasMatch(trimmed);
  }

  /// Fetches location data (city, latitude, longitude) from Nominatim.
  /// Returns a [PostalLookupResult] or null if not found.
  ///
  /// Results (including "not found") are cached per country/postal code
  /// combination for the lifetime of the app session, so repeated lookups
  /// of the same value never trigger another network request. Network
  /// errors are not cached, so a retry is possible.
  static Future<PostalLookupResult?> fetchLocationData(String countryCode, String postalCode) {
    final key = _cacheKey(countryCode, postalCode);
    final cached = _lookupCache[key];
    if (cached != null) return cached;

    final future = _fetchLocationDataFromApi(countryCode, postalCode);
    _lookupCache[key] = future;
    future.catchError((Object _) {
      // Don't cache failures (e.g. network errors/timeouts) so the user can retry.
      _lookupCache.remove(key);
      return null;
    });
    return future;
  }

  static Future<PostalLookupResult?> _fetchLocationDataFromApi(String countryCode, String postalCode) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'postalcode': postalCode,
      'countrycodes': countryCode.toLowerCase(),
      'format': 'json',
      'limit': '1',
      'addressdetails': '1',
    });

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Boro (https://www.boro-app.de/)',
      },
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        final place = data.first;
        final latValue = place['lat'];
        final lonValue = place['lon'];
        final lat = latValue != null ? double.tryParse(latValue.toString()) : null;
        final lon = lonValue != null ? double.tryParse(lonValue.toString()) : null;
        final address = place['address'] as Map<String, dynamic>?;
        final city = address?['city'] ??
            address?['town'] ??
            address?['village'] ??
            address?['hamlet'] ??
            place['display_name']
                ?.toString()
                .split(',')
                .first
                .trim();

        if (lat != null && lon != null) {
          return PostalLookupResult(
            city: city,
            latitude: lat,
            longitude: lon,
          );
        }
      }
    }
    return null;
  }

  /// Calculates the distance between two points in kilometers using the Haversine formula.
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
