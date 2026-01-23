class ApiConstants {
  // OpenWeatherMap now works with HTTP for free tier
  static const String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

  // API key
  static const String apiKey = 'bba1af196401df6649e0336b7a881960';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  // Units
  static const String units = 'metric';

  // Current weather by city
  static String getCurrentWeatherByCity(String cityName) {
    return '$baseUrl$currentWeather?q=$cityName&APPID=$apiKey&units=$units';
  }

  // Current weather by coordinates
  static String getCurrentWeatherByCoords(double lat, double lon) {
    return '$baseUrl$currentWeather?lat=$lat&lon=$lon&APPID=$apiKey&units=$units';
  }

  // Forecast by city
  static String getForecastByCity(String cityName) {
    return '$baseUrl$forecast?q=$cityName&APPID=$apiKey&units=$units';
  }

  // Forecast by coordinates
  static String getForecastByCoords(double lat, double lon) {
    return '$baseUrl$forecast?lat=$lat&lon=$lon&APPID=$apiKey&units=$units';
  }

  // Weather icon
  static String getIconUrl(String iconCode) {
    return 'http://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Geo API (also HTTP)
  static const String geoBaseUrl = 'http://api.openweathermap.org/geo/1.0';

  // City search
  static String searchCities(String query, {int limit = 5}) {
    return '$geoBaseUrl/direct?q=$query&limit=$limit&APPID=$apiKey';
  }
}
