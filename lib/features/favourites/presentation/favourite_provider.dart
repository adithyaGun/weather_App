import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/weather_model.dart';
import '../../../app/providers.dart';

/// Favorites State
/// 
/// Represents the state of favorites in the app.

class FavoritesState {
  final List<CityModel> favorites;
  final Map<String, WeatherModel?> favoritesWeather;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.favorites = const [],
    this.favoritesWeather = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  int get favoritesCount => favorites.length;
  bool get hasFavorites => favorites.isNotEmpty;

  FavoritesState copyWith({
    List<CityModel>? favorites,
    Map<String, WeatherModel?>? favoritesWeather,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoritesWeather: favoritesWeather ?? this.favoritesWeather,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super(const FavoritesState());

  /// Load all favorite cities
  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(favoritesRepositoryProvider);
      final favorites = await repo.getFavorites();

      state = state.copyWith(
        favorites: favorites,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load favorites',
      );
    }
  }
  Future<bool> addFavoriteFromWeather(WeatherModel weather) async {
    try {
      final repo = ref.read(favoritesRepositoryProvider);
      final success = await repo.addFavoriteFromWeather(weather);

      if (success) {
        await loadFavorites();
        return true;
      } else {
        state = state.copyWith(
          errorMessage: 'City already in favorites or max limit reached',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to add city to favorites',
      );
      return false;
    }
  }
  Future<bool> removeFavorite(String cityName) async {
    try {
      final repo = ref.read(favoritesRepositoryProvider);
      final success = await repo.removeFavorite(cityName);

      if (success) {
        final updatedFavorites = state.favorites
            .where((city) => city.name.toLowerCase() != cityName.toLowerCase())
            .toList();
        final updatedWeather = Map<String, WeatherModel?>.from(state.favoritesWeather)
          ..remove(cityName);

        state = state.copyWith(
          favorites: updatedFavorites,
          favoritesWeather: updatedWeather,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to remove city from favorites',
      );
      return false;
    }
  }

  bool isFavoriteSync(String cityName) {
    return state.favorites.any(
      (city) => city.name.toLowerCase() == cityName.toLowerCase(),
    );
  }

  Future<bool> toggleFavorite(WeatherModel weather) async {
    if (isFavoriteSync(weather.cityName)) {
      return await removeFavorite(weather.cityName);
    } else {
      return await addFavoriteFromWeather(weather);
    }
  }

  Future<void> fetchFavoritesWeather() async {
    if (state.favorites.isEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(favoritesRepositoryProvider);
      final weatherMap = await repo.getFavoritesWeather();

      state = state.copyWith(
        favoritesWeather: weatherMap,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch weather for favorites',
      );
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      final repo = ref.read(favoritesRepositoryProvider);
      await repo.clearFavorites();

      state = const FavoritesState();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to clear favorites',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Favorites State Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(ref);
});
