import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../data/service/weather_api_service.dart';
import '../../../data/service/location_service.dart';
import '../../../data/service/local_storage_service.dart';
import '../domain/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;
  final LocationService _locationService;
  final LocalStorageService _storageService;

  WeatherRepositoryImpl(
    this._apiService,
    this._locationService,
    this._storageService,
  );

  @override
  Future<WeatherModel> getWeatherByCity(String city) async {
    return await _apiService.getCurrentWeatherByCity(city);
  }

  @override
  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    return await _apiService.getCurrentWeatherByCoords(lat, lon);
  }

  @override
  Future<WeatherModel> getWeatherByLocation() async {
    final position = await _locationService.getCurrentPosition();
    return await _apiService.getCurrentWeatherByCoords(
      position.latitude,
      position.longitude,
    );
  }

  @override
  Future<ForecastResponseModel> getForecastByCity(String city) async {
    return await _apiService.getForecastByCity(city);
  }

  @override
  Future<ForecastResponseModel> getForecastByCoords(double lat, double lon) async {
    return await _apiService.getForecastByCoords(lat, lon);
  }

  @override
  Future<(WeatherModel, ForecastResponseModel)> getWeatherAndForecast(String city) async {
    final results = await Future.wait([
      _apiService.getCurrentWeatherByCity(city),
      _apiService.getForecastByCity(city),
    ]);

    return (
      results[0] as WeatherModel,
      results[1] as ForecastResponseModel,
    );
  }

  @override
  Future<String?> getLastCity() async {
    return await _storageService.getLastCity();
  }

  @override
  Future<void> saveLastCity(String city) async {
    await _storageService.setLastCity(city);
  }
}
