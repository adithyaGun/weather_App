
class CityModel {
  final String name;       
  final String country;    
  final double latitude;   
  final double longitude;  
  final DateTime? addedAt; 
  // Constructor
  CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.addedAt,
  });

  // Factory constructor to create CityModel from JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      addedAt: json['addedAt'] != null 
          ? DateTime.parse(json['addedAt']) 
          : null,
    );
  }

  // Convert CityModel to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'addedAt': addedAt?.toIso8601String(),
    };
  }

  // Create CityModel from WeatherModel
  factory CityModel.fromWeather(dynamic weather) {
    return CityModel(
      name: weather.cityName,
      country: weather.country,
      latitude: weather.latitude,
      longitude: weather.longitude,
      addedAt: DateTime.now(),
    );
  }

  // Get full display name (e.g., "London, UK")
  String get displayName => '$name, $country';

  // Check equality based on name and country
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CityModel && 
           other.name.toLowerCase() == name.toLowerCase() && 
           other.country.toLowerCase() == country.toLowerCase();
  }

  @override
  int get hashCode => name.toLowerCase().hashCode ^ country.toLowerCase().hashCode;

  @override
  String toString() {
    return 'CityModel(name: $name, country: $country)';
  }
}
