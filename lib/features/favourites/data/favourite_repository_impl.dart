import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/service/local_storage_service.dart';
import '../../../data/service/weather_api_service.dart';
import '../domain/favourite_repository.dart';

/// Favorites Repository Implementation
/// 
/// Clean Architecture: Data layer implements the domain interface.
/// This class handles all favorites-related data operations.

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageService _storageService;
  final WeatherApiService _apiService;

  FavoritesRepositoryImpl(
    this._storageService,
    this._apiService,
  );

  @override
  Future<List<CityModel>> getFavorites() async {
    return await _storageService.getFavoriteCities();
  }

  @override
  Future<bool> addFavorite(CityModel city) async {
    return await _storageService.addFavoriteCity(city);
  }

  @override
  Future<bool> addFavoriteFromWeather(WeatherModel weather) async {
    final city = CityModel.fromWeather(weather);
    return await addFavorite(city);
  }

  @override
  Future<bool> removeFavorite(String cityName) async {
    return await _storageService.removeFavoriteCity(cityName);
  }

  @override
  Future<bool> isFavorite(String cityName) async {
    return await _storageService.isFavoriteCity(cityName);
  }

  @override
  Future<Map<String, WeatherModel?>> getFavoritesWeather() async {
    final favorites = await getFavorites();
    final Map<String, WeatherModel?> weatherMap = {};

    for (var city in favorites) {
      try {
        final weather = await _apiService.getCurrentWeatherByCity(city.name);
        weatherMap[city.name] = weather;
      } catch (e) {
        weatherMap[city.name] = null;
      }
    }

    return weatherMap;
  }

  @override
  Future<void> clearFavorites() async {
    await _storageService.clearFavoriteCities();
  }
}
