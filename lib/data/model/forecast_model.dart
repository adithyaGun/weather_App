

class ForecastModel {
  final int dateTime;              
  final double temperature;        
  final double feelsLike;          
  final double tempMin;            
  final double tempMax;            
  final int humidity;              
  final int pressure;              
  final String description;        
  final String icon;               
  final int conditionId;           
  final double windSpeed;         
  final double windDegree;         
  final int clouds;                
  final double? rain;              
  final double? snow;              
  final int visibility;            
  final double pop;               

  // Constructor
  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.conditionId,
    required this.windSpeed,
    required this.windDegree,
    required this.clouds,
    this.rain,
    this.snow,
    required this.visibility,
    required this.pop,
  });

  // Factory constructor to create ForecastModel from JSON
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: json['dt'] ?? 0,
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      conditionId: json['weather'][0]['id'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDegree: (json['wind']['deg'] ?? 0).toDouble(),
      clouds: json['clouds']['all'] ?? 0,
      rain: json['rain'] != null ? (json['rain']['3h'] ?? 0).toDouble() : null,
      snow: json['snow'] != null ? (json['snow']['3h'] ?? 0).toDouble() : null,
      visibility: json['visibility'] ?? 0,
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }

  // Get precipitation percentage (0-100)
  int get precipitationPercentage => (pop * 100).round();

  @override
  String toString() {
    return 'ForecastModel(dateTime: $dateTime, temperature: $temperature°C, description: $description)';
  }
}




class ForecastResponseModel {
  final String cityName;           
  final String country;            
  final double latitude;           
  final double longitude;          
  final List<ForecastModel> forecasts; 
  // Constructor
  ForecastResponseModel({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.forecasts,
  });

 
  factory ForecastResponseModel.fromJson(Map<String, dynamic> json) {
    List<ForecastModel> forecastList = [];
    
    // Parse the list of forecasts
    if (json['list'] != null) {
      forecastList = (json['list'] as List)
          .map((item) => ForecastModel.fromJson(item))
          .toList();
    }

    return ForecastResponseModel(
      cityName: json['city']['name'] ?? 'Unknown',
      country: json['city']['country'] ?? '',
      latitude: (json['city']['coord']['lat'] ?? 0).toDouble(),
      longitude: (json['city']['coord']['lon'] ?? 0).toDouble(),
      forecasts: forecastList,
    );
  }

  // Get forecasts grouped by day
  Map<String, List<ForecastModel>> get forecastsByDay {
    Map<String, List<ForecastModel>> grouped = {};
    
    for (var forecast in forecasts) {
      // Get date string (YYYY-MM-DD)
      final date = DateTime.fromMillisecondsSinceEpoch(forecast.dateTime * 1000);
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(forecast);
      } else {
        grouped[dateKey] = [forecast];
      }
    }
    
    return grouped;
  }

  
  List<ForecastModel> get dailySummary {
    final byDay = forecastsByDay;
    List<ForecastModel> daily = [];
    
    byDay.forEach((date, forecasts) {
     
      var noonForecast = forecasts.firstWhere(
        (f) {
          final hour = DateTime.fromMillisecondsSinceEpoch(f.dateTime * 1000).hour;
          return hour >= 11 && hour <= 14;
        },
        orElse: () => forecasts.first,
      );
      daily.add(noonForecast);
    });
    
    return daily;
  }

  @override
  String toString() {
    return 'ForecastResponseModel(cityName: $cityName, forecastCount: ${forecasts.length})';
  }
}
