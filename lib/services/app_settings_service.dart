import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/config/constants.dart';

/// Service for fetching global app settings from the `app_settings` table.
/// The table uses a key/value structure and is publicly readable (no auth required).
class AppSettingsService {
  final SupabaseClient _db = Supabase.instance.client;

  /// Returns true if maintenance mode is active (`maintenance_mode` value is `'true'`).
  Future<bool> fetchIsMaintenanceModeActive() async {
    try {
      final response = await _db
          .from(AppConstants.tableAppSettings)
          .select('value')
          .eq('key', AppConstants.keyMaintenanceMode)
          .maybeSingle();
      return response?['value'] == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Fetches the news banner text for the given [languageCode] (e.g. 'de', 'en').
  /// Returns null if no banner is configured or the value is empty.
  Future<String?> fetchNewsBannerText(String languageCode) async {
    final String key = languageCode == 'de'
        ? AppConstants.keyNewsBannerDe
        : AppConstants.keyNewsBannerEn;
    try {
      final response = await _db
          .from(AppConstants.tableAppSettings)
          .select('value')
          .eq('key', key)
          .maybeSingle();
      final String? value = response?['value'] as String?;
      return (value != null && value.isNotEmpty) ? value : null;
    } catch (e) {
      return null;
    }
  }
}
