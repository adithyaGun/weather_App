

abstract class SettingsRepository {
  /// Get theme preference (true = dark, false = light)
  Future<bool> getIsDarkTheme();

  /// Set theme preference
  Future<void> setIsDarkTheme(bool isDark);

  /// Get temperature unit (true = Celsius, false = Fahrenheit)
  Future<bool> getIsCelsius();

  /// Set temperature unit
  Future<void> setIsCelsius(bool isCelsius);

  /// Load all settings
  Future<({bool isDarkTheme, bool isCelsius})> loadSettings();

  /// Reset all settings to default
  Future<void> resetSettings();
}
