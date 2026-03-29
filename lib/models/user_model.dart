class UserModel {
  final String? id;
  final String firstName;
  final String? lastName;
  final String? city;
  final DateTime created;
  final String? description;
  final String? imageUrl;
  final String? telephone;
  final String? friendCode;
  final String? countryCode;
  final String? postalCode;
  final double? latitude;
  final double? longitude;


  UserModel({
    this.id,
    required this.firstName,
    this.lastName,
    this.city,
    required this.created,
    this.description,
    this.imageUrl,
    this.telephone,
    this.friendCode,
    this.countryCode,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  // JSON serialization (for backend communication)
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      firstName: json['first_name'] as String,
      city: json['city'] != null ? json['city'] as String : null,
      created: DateTime.parse(json['created'] as String).toLocal(),
      description: json['description'] != null ? json['description'] as String : null,
      imageUrl: json['image_url'] != null ? json['image_url'] as String : null,
      telephone: json['telephone'] != null ? json['telephone'] as String : null,
      lastName: json['last_name'] != null ? json['last_name'] as String : null,
      friendCode: json['friend_code'] != null ? json['friend_code'] as String : null,
      countryCode: json['country_code'] != null ? json['country_code'] as String : null,
      postalCode: json['postal_code'] != null ? json['postal_code'] as String : null,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }

  factory UserModel.fromDatabaseFunction(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id']?.toString() ?? '',
      firstName: json['creator_name']?.toString() ?? '',
      city: json['creator_city']?.toString(),
      created: DateTime.now(),
      description: '',
      imageUrl: '',
      telephone: '',
      countryCode: json['creator_country_code']?.toString(),
      postalCode: json['creator_postal_code']?.toString(),
      latitude: _parseDouble(json['creator_latitude']),
      longitude: _parseDouble(json['creator_longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'first_name': firstName,
      'city': city,
      'created': created.toUtc().toIso8601String(),
      'description': description,
      'image_url': imageUrl,
      'telephone': telephone,
      'friend_code': friendCode,
      'country_code': countryCode,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
    };

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

}
