/// DTO representing the result of a postal code lookup.
class PostalLookupResult {
  final String? city;
  final double latitude;
  final double longitude;

  const PostalLookupResult({
    this.city,
    required this.latitude,
    required this.longitude,
  });

  factory PostalLookupResult.fromJson(Map<String, dynamic> json) {
    return PostalLookupResult(
      city: json['city'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
