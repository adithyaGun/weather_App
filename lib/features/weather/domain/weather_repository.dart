import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';


abstract class WeatherRepository {
  /// Fetch current weather by city name
  Future<WeatherModel> getWeatherByCity(String city);

  /// Fetch current weather by GPS coordinates
  Future<WeatherModel> getWeatherByCoords(double lat, double lon);

  /// Fetch current weather using device's GPS location
  Future<WeatherModel> getWeatherByLocation();

  /// Fetch 5-day forecast by city name
  Future<ForecastResponseModel> getForecastByCity(String city);

  /// Fetch 5-day forecast by GPS coordinates
  Future<ForecastResponseModel> getForecastByCoords(double lat, double lon);

  /// Fetch both weather and forecast by city name
  Future<(WeatherModel, ForecastResponseModel)> getWeatherAndForecast(String city);

  /// Get the last searched city from local storage
  Future<String?> getLastCity();

  /// Save the last searched city
  Future<void> saveLastCity(String city);
}
