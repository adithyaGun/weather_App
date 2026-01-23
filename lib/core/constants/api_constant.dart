
class ApiConstants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '6be34b99763185265033ded775e7dfb0';
  
 
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  
  static const String units = 'metric';
  
  static String getCurrentWeatherByCity(String cityName) {
    return '$baseUrl$currentWeather?q=$cityName&appid=$apiKey&units=$units';
  }
  
  static String getCurrentWeatherByCoords(double lat, double lon) {
    return '$baseUrl$currentWeather?lat=$lat&lon=$lon&appid=$apiKey&units=$units';
  }
  
  static String getForecastByCity(String cityName) {
    return '$baseUrl$forecast?q=$cityName&appid=$apiKey&units=$units';
  }
  
  static String getForecastByCoords(double lat, double lon) {
    return '$baseUrl$forecast?lat=$lat&lon=$lon&appid=$apiKey&units=$units';
  }
  
  static String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  static const String geoBaseUrl = 'https://api.openweathermap.org/geo/1.0';
  
  static String searchCities(String query, {int limit = 5}) {
    return '$geoBaseUrl/direct?q=$query&limit=$limit&appid=$apiKey';
  }
}
