import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';


class SettingsState {
  final bool isDarkTheme;
  final bool isCelsius;
  final bool isLoading;

  const SettingsState({
    this.isDarkTheme = false,
    this.isCelsius = true,
    this.isLoading = false,
  });

  String get temperatureUnitLabel => isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)';
  String get themeLabel => isDarkTheme ? 'Dark Theme' : 'Light Theme';

  SettingsState copyWith({
    bool? isDarkTheme,
    bool? isCelsius,
    bool? isLoading,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isCelsius: isCelsius ?? this.isCelsius,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Convert temperature based on current setting
  double convertTemperature(double celsius) {
    if (isCelsius) {
      return celsius;
    } else {
      return (celsius * 9 / 5) + 32;
    }
  }

  /// Get temperature with unit symbol
  String formatTemperature(double celsius) {
    final temp = convertTemperature(celsius);
    final symbol = isCelsius ? '°C' : '°F';
    return '${temp.round()}$symbol';
  }
}

/// Settings Notifier
/// 
/// Manages settings state using Riverpod StateNotifier.

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(const SettingsState());

  /// Load all settings from storage
  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(settingsRepositoryProvider);
      final settings = await repo.loadSettings();

      state = SettingsState(
        isDarkTheme: settings.isDarkTheme,
        isCelsius: settings.isCelsius,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Toggle dark theme
  Future<void> toggleTheme() async {
    final newValue = !state.isDarkTheme;
    state = state.copyWith(isDarkTheme: newValue);

    final repo = ref.read(settingsRepositoryProvider);
    await repo.setIsDarkTheme(newValue);
  }

  /// Set theme directly
  Future<void> setTheme(bool isDark) async {
    state = state.copyWith(isDarkTheme: isDark);

    final repo = ref.read(settingsRepositoryProvider);
    await repo.setIsDarkTheme(isDark);
  }

  /// Toggle temperature unit
  Future<void> toggleTemperatureUnit() async {
    final newValue = !state.isCelsius;
    state = state.copyWith(isCelsius: newValue);

    final repo = ref.read(settingsRepositoryProvider);
    await repo.setIsCelsius(newValue);
  }

  /// Set temperature unit directly
  Future<void> setTemperatureUnit(bool isCelsius) async {
    state = state.copyWith(isCelsius: isCelsius);

    final repo = ref.read(settingsRepositoryProvider);
    await repo.setIsCelsius(isCelsius);
  }

  /// Reset all settings to default
  Future<void> resetSettings() async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.resetSettings();

    state = const SettingsState();
  }
}

/// Settings State Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
