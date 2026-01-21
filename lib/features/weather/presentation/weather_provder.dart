import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../../app/providers.dart';



class WeatherState {
  final WeatherModel? currentWeather;
  final ForecastResponseModel? forecast;
  final bool isLoading;
  final String? errorMessage;
  final String currentCity;

  const WeatherState({
    this.currentWeather,
    this.forecast,
    this.isLoading = false,
    this.errorMessage,
    this.currentCity = '',
  });

  bool get hasWeather => currentWeather != null;
  bool get hasForecast => forecast != null;

  WeatherState copyWith({
    WeatherModel? currentWeather,
    ForecastResponseModel? forecast,
    bool? isLoading,
    String? errorMessage,
    String? currentCity,
    bool clearError = false,
    bool clearWeather = false,
  }) {
    return WeatherState(
      currentWeather: clearWeather ? null : (currentWeather ?? this.currentWeather),
      forecast: clearWeather ? null : (forecast ?? this.forecast),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage,
      currentCity: currentCity ?? this.currentCity,
    );
  }
}



class WeatherNotifier extends StateNotifier<WeatherState> {
  final Ref ref;

  WeatherNotifier(this.ref) : super(const WeatherState());

  /// Fetch weather and forecast by city name
  Future<void> fetchWeatherAndForecast(String cityName) async {
    if (cityName.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter a city name',
        clearError: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(weatherRepositoryProvider);
      final (weather, forecast) = await repo.getWeatherAndForecast(cityName);

      await repo.saveLastCity(cityName);

      state = state.copyWith(
        currentWeather: weather,
        forecast: forecast,
        currentCity: cityName,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Fetch weather by GPS location
  Future<void> fetchWeatherByLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(weatherRepositoryProvider);
      final weather = await repo.getWeatherByLocation();
      final forecast = await repo.getForecastByCity(weather.cityName);

      await repo.saveLastCity(weather.cityName);

      state = state.copyWith(
        currentWeather: weather,
        forecast: forecast,
        currentCity: weather.cityName,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Load last searched city
  Future<void> loadLastCity() async {
    final repo = ref.read(weatherRepositoryProvider);
    final lastCity = await repo.getLastCity();
    
    if (lastCity != null && lastCity.isNotEmpty) {
      await fetchWeatherAndForecast(lastCity);
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset weather data
  void reset() {
    state = const WeatherState();
  }
}

/// Weather State Provider
final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier(ref);
});
