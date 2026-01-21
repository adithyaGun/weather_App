

class AppConstants {
  // App Info
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';
  
  // Local Storage Keys
  static const String favoriteCitiesKey = 'favorite_cities';
  static const String temperatureUnitKey = 'temperature_unit';
  static const String lastCityKey = 'last_city';
  static const String themeKey = 'app_theme';
  
  // Default Values
  static const String defaultCity = 'London';
  static const int maxFavorites = 10;
  
  // Error Messages
  static const String errorNoInternet = 'No internet connection. Please check your network.';
  static const String errorCityNotFound = 'City not found. Please try another city name.';
  static const String errorApiKey = 'Invalid API key. Please check your API key.';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorLocationPermission = 'Location permission denied. Please enable it in settings.';
  static const String errorLocationService = 'Location service is disabled. Please enable GPS.';
  
  // Success Messages
  static const String successAddedToFavorites = 'City added to favorites!';
  static const String successRemovedFromFavorites = 'City removed from favorites.';
}
