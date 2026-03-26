import 'package:verleihapp/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:verleihapp/l10n/app_localizations.dart';

class LendableModel {
  final String id;
  final String title;
  final String description;
  final String city;
  final String category;
  final String type;
  final String visibility;
  final String groupVisibility;
  final List<String> groupIds;
  final String imageUrl;
  final String imageFileName;
  final String userId;
  final DateTime created;
  final String? borrowedBy;
  final String? countryCode;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  LendableModel({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.category,
    required this.type,
    required this.visibility,
    this.groupVisibility = AppConstants.filterAll,
    this.groupIds = const [],
    required this.imageUrl,
    required this.imageFileName,
    required this.userId,
    required this.created,
    this.borrowedBy,
    this.countryCode,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  bool get isBorrowed => borrowedBy != null && borrowedBy!.trim().isNotEmpty;

  /// Gibt den lokalisierten Typ-Text für Formulare zurück
  String getDisplayedTypeForm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lendableType = LendableType.fromString(type);
    switch (lendableType) {
      case LendableType.offer:
        return l10n.offerTypeOffer;
      case LendableType.free:
        return l10n.offerTypeFree;
      case LendableType.search:
        return l10n.offerTypeSearch;
      case LendableType.sell:
        return l10n.offerTypeSell;
    }
  }

  /// Gibt den lokalisierten Typ-Text für Karten zurück
  String getDisplayedTypeCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lendableType = LendableType.fromString(type);
    switch (lendableType) {
      case LendableType.offer:
        return l10n.offerTypeOfferCard;
      case LendableType.free:
        return l10n.offerTypeFreeCard;
      case LendableType.search:
        return l10n.offerTypeSearchCard;
      case LendableType.sell:
        return l10n.offerTypeSellCard;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'description': description,
      'city': city,
      'category': category,
      'type': type,
      'visibility': visibility,
      'group_visibility': groupVisibility,
      'image_url': imageUrl,
      'image_file_name': imageFileName,
      'user_id': userId,
      'created': created.toUtc().toIso8601String(),
      'borrowed_by': borrowedBy,
      'country_code': countryCode,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
    };

    return data;
  }

  factory LendableModel.fromJson(Map<String, dynamic> json) {
    return LendableModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? VisibilityMode.indirectContacts.value,
      groupVisibility: json['group_visibility']?.toString() ?? AppConstants.filterAll,
      groupIds: (json['group_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
      imageUrl: json['image_url']?.toString() ?? '',
      imageFileName: json['image_file_name']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      created: json['created'] != null 
          ? DateTime.parse(json['created'].toString()).toLocal()
          : DateTime.now(),
      borrowedBy: json['borrowed_by']?.toString(),
      countryCode: json['country_code']?.toString(),
      postalCode: json['postal_code']?.toString(),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }

  factory LendableModel.fromDatabaseFunction(Map<String, dynamic> json) {
    return LendableModel(
      id: (json['lendable_id'] ?? json['id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      visibility: json['visibility']?.toString() ?? VisibilityMode.indirectContacts.value,
      groupVisibility: json['group_visibility']?.toString() ?? AppConstants.filterAll,
      groupIds: (json['group_ids'] as List?)?.map((e) => e.toString()).toList() ?? [],
      imageUrl: json['image_url']?.toString() ?? '',
      imageFileName: json['image_file_name']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      created: json['created'] != null 
          ? DateTime.parse(json['created'].toString()).toLocal()
          : DateTime.now(),
      borrowedBy: json['borrowed_by']?.toString(),
      countryCode: json['country_code']?.toString(),
      postalCode: json['postal_code']?.toString(),
      latitude: _parseDouble(json['lendable_latitude']),
      longitude: _parseDouble(json['lendable_longitude']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static LendableModel getTestLendable() {
    return LendableModel(
      id: 'test-id',
      title: 'Test Artikel',
      description: 'Dies ist ein Test-Artikel',
      city: 'Teststadt',
      category: 'Testkategorie',
      type: LendableType.offer.value,
      visibility: VisibilityMode.indirectContacts.value,
      groupVisibility: AppConstants.filterAll,
      groupIds: [],
      imageUrl: '',
      imageFileName: '',
      userId: 'test-user-id',
      created: DateTime.now(),
      borrowedBy: null,
    );
  }

  /// Gibt die lokalisierten Offer Types für Dropdowns zurück
  static List<Map<String, String>> getLendableTypes(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {'displayForm': l10n.offerTypeOffer, 'displayCard': l10n.offerTypeOfferCard, 'value': LendableType.offer.value},
      {'displayForm': l10n.offerTypeFree, 'displayCard': l10n.offerTypeFreeCard, 'value': LendableType.free.value},
      {'displayForm': l10n.offerTypeSell, 'displayCard': l10n.offerTypeSellCard, 'value': LendableType.sell.value},
      {'displayForm': l10n.offerTypeSearch, 'displayCard': l10n.offerTypeSearchCard, 'value': LendableType.search.value},
    ];
  }
}
