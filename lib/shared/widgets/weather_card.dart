import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/data/service/weather_api_service.dart';
import 'package:weather_app/data/service/local_storage_service.dart';
import 'package:weather_app/data/service/location_service.dart';
import 'package:weather_app/data/service/city_search_service.dart';
import 'package:weather_app/features/weather/data/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/weather_repository.dart';
import 'package:weather_app/features/favourites/data/favourite_repository_impl.dart';
import 'package:weather_app/features/favourites/domain/favourite_repository.dart';
import 'package:weather_app/features/settings/data/setting_repository_impl.dart';
import 'package:weather_app/features/settings/domain/settings_repository.dart';

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  return WeatherApiService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final citySearchServiceProvider = Provider<CitySearchService>((ref) {
  return CitySearchService();
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    ref.read(weatherApiServiceProvider),
    ref.read(locationServiceProvider),
    ref.read(localStorageServiceProvider),
  );
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(
    ref.read(localStorageServiceProvider),
    ref.read(weatherApiServiceProvider),
  );
});

/// Settings Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    ref.read(localStorageServiceProvider),
  );
});
