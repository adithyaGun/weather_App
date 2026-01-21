import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';

/// Favorites Repository Interface
/// 
/// Clean Architecture: Domain layer defines the contract.
/// Data layer implements this interface.

abstract class FavoritesRepository {
  /// Get list of favorite cities
  Future<List<CityModel>> getFavorites();

  /// Add a city to favorites
  Future<bool> addFavorite(CityModel city);

  /// Add a city from weather data
  Future<bool> addFavoriteFromWeather(WeatherModel weather);

  /// Remove a city from favorites
  Future<bool> removeFavorite(String cityName);

  /// Check if a city is in favorites
  Future<bool> isFavorite(String cityName);

  /// Get weather for all favorite cities
  Future<Map<String, WeatherModel?>> getFavoritesWeather();

  /// Clear all favorites
  Future<void> clearFavorites();
}
