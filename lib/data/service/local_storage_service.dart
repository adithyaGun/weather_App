import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/city_model.dart';
import '../../core/constants/app_constants.dart';


class LocalStorageService {
  // SharedPreferences instance
  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Ensure preferences are initialized
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  
  Future<List<CityModel>> getFavoriteCities() async {
    final preferences = await prefs;
    final String? citiesJson = preferences.getString(AppConstants.favoriteCitiesKey);
    
    if (citiesJson == null || citiesJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(citiesJson);
      return decoded.map((item) => CityModel.fromJson(item)).toList();
    } catch (e) {
      
      return [];
    }
  }

  /// Add a city to favorites
  Future<bool> addFavoriteCity(CityModel city) async {
    final preferences = await prefs;
    final cities = await getFavoriteCities();
    
    // Check if city already exists
    if (cities.any((c) => c.name.toLowerCase() == city.name.toLowerCase())) {
      return false; // Already in favorites
    }

    // Check max favorites limit
    if (cities.length >= AppConstants.maxFavorites) {
      return false; // Max limit reached
    }

    // Add city with current timestamp
    final newCity = CityModel(
      name: city.name,
      country: city.country,
      latitude: city.latitude,
      longitude: city.longitude,
      addedAt: DateTime.now(),
    );
    
    cities.add(newCity);
    
    // Save to storage
    final encoded = jsonEncode(cities.map((c) => c.toJson()).toList());
    return await preferences.setString(AppConstants.favoriteCitiesKey, encoded);
  }

  /// Remove a city from favorites
  Future<bool> removeFavoriteCity(String cityName) async {
    final preferences = await prefs;
    final cities = await getFavoriteCities();
    
    // Remove the city
    cities.removeWhere((c) => c.name.toLowerCase() == cityName.toLowerCase());
    
    // Save to storage
    final encoded = jsonEncode(cities.map((c) => c.toJson()).toList());
    return await preferences.setString(AppConstants.favoriteCitiesKey, encoded);
  }

  /// Check if a city is in favorites
  Future<bool> isFavoriteCity(String cityName) async {
    final cities = await getFavoriteCities();
    return cities.any((c) => c.name.toLowerCase() == cityName.toLowerCase());
  }

  /// Clear all favorite cities
  Future<bool> clearFavoriteCities() async {
    final preferences = await prefs;
    return await preferences.remove(AppConstants.favoriteCitiesKey);
  }

  
  Future<bool> getTemperatureUnit() async {
    final preferences = await prefs;
    return preferences.getBool(AppConstants.temperatureUnitKey) ?? true;
  }

  /// Set temperature unit
  Future<bool> setTemperatureUnit(bool isCelsius) async {
    final preferences = await prefs;
    return await preferences.setBool(AppConstants.temperatureUnitKey, isCelsius);
  }

  /// Get last searched city
  Future<String?> getLastCity() async {
    final preferences = await prefs;
    return preferences.getString(AppConstants.lastCityKey);
  }

  /// Save last searched city
  Future<bool> setLastCity(String cityName) async {
    final preferences = await prefs;
    return await preferences.setString(AppConstants.lastCityKey, cityName);
  }

  /// Get theme preference (true = dark, false = light)
  Future<bool> getTheme() async {
    final preferences = await prefs;
    return preferences.getBool(AppConstants.themeKey) ?? false;
  }

  /// Set theme preference
  Future<bool> setTheme(bool isDark) async {
    final preferences = await prefs;
    return await preferences.setBool(AppConstants.themeKey, isDark);
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    final preferences = await prefs;
    return await preferences.clear();
  }
}
