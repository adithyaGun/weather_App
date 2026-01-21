
class WeatherModel {
  final int id;                    
  final String cityName;          
  final String country;            
  final double temperature;        
  final double feelsLike;          
  final double tempMin;            
  final double tempMax;            
  final int humidity;              
  final int pressure;             
  final double windSpeed;          
  final double windDegree;         
  final String description;        
  final String icon;               
  final int visibility;            
  final int clouds;               
  final int sunrise;               
  final int sunset;                
  final int dateTime;              
  final double latitude;           
  final double longitude;          

 
  WeatherModel({
    required this.id,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.description,
    required this.icon,
    required this.visibility,
    required this.clouds,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create WeatherModel from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json['weather'][0]['id'] ?? 0,
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDegree: (json['wind']['deg'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      visibility: json['visibility'] ?? 0,
      clouds: json['clouds']['all'] ?? 0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      dateTime: json['dt'] ?? 0,
      latitude: (json['coord']['lat'] ?? 0).toDouble(),
      longitude: (json['coord']['lon'] ?? 0).toDouble(),
    );
  }

  // Convert WeatherModel to JSON (useful for caching)
  Map<String, dynamic> toJson() {
    return {
      'weather': [
        {
          'id': id,
          'description': description,
          'icon': icon,
        }
      ],
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise,
        'sunset': sunset,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDegree,
      },
      'visibility': visibility,
      'clouds': {
        'all': clouds,
      },
      'dt': dateTime,
      'coord': {
        'lat': latitude,
        'lon': longitude,
      },
    };
  }

  // Create a copy with modified values
  WeatherModel copyWith({
    int? id,
    String? cityName,
    String? country,
    double? temperature,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? humidity,
    int? pressure,
    double? windSpeed,
    double? windDegree,
    String? description,
    String? icon,
    int? visibility,
    int? clouds,
    int? sunrise,
    int? sunset,
    int? dateTime,
    double? latitude,
    double? longitude,
  }) {
    return WeatherModel(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      windDegree: windDegree ?? this.windDegree,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      visibility: visibility ?? this.visibility,
      clouds: clouds ?? this.clouds,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'WeatherModel(cityName: $cityName, temperature: $temperature°C, description: $description)';
  }
}
