import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/weather_card.dart';
import '../../../shared/widgets/search_bar_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/animater_weather_background.dart';
import '../../weather/presentation/weather_provder.dart';
import '../../favourites/presentation/favourite_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final weatherNotifier = ref.read(weatherProvider.notifier);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    weatherNotifier.loadLastCity().then((_) {
      if (!ref.read(weatherProvider).hasWeather) {
        weatherNotifier.fetchWeatherAndForecast('London');
      }
    });

    favoritesNotifier.loadFavorites();
  }

  bool _isNightTime(String? iconCode) {
    if (iconCode != null && iconCode.isNotEmpty) {
      return iconCode.endsWith('n');
    }
    final hour = DateTime.now().hour;
    return hour >= 19 || hour < 6;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final weatherState = ref.watch(weatherProvider);
    final weatherCondition = weatherState.currentWeather?.description;
    final iconCode = weatherState.currentWeather?.icon;
    final isNight = _isNightTime(iconCode);

    return Stack(
      children: [
        AnimatedWeatherBackground(
          weatherCondition: weatherCondition,
          isNight: isNight,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMinimalHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSearchBar(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _buildWeatherContent(context, weatherState),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 120,
          child: FloatingActionButton(
            onPressed: weatherState.isLoading
                ? null
                : () => ref
                    .read(weatherProvider.notifier)
                    .fetchWeatherByLocation(),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue[700],
            elevation: 6,
            child: weatherState.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_rounded),
          ),
        ),
      ],
    );
  }

  // ================= MINIMAL HEADER =================

  Widget _buildMinimalHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Weather',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  Widget _buildSearchBar() {
    return SearchBarWidget(
      hintText: 'Type city name',
      onSearch: (city) {
        ref.read(weatherProvider.notifier).fetchWeatherAndForecast(city);
      },
    );
  }

  // ================= WEATHER CONTENT =================

  Widget _buildWeatherContent(
      BuildContext context, WeatherState weatherState) {
    if (weatherState.isLoading) {
      return const LoadingWidget(message: 'Fetching weather data...');
    }

    if (weatherState.errorMessage != null) {
      return ErrorDisplayWidget(
        message: weatherState.errorMessage!,
        onRetry: () {
          ref
              .read(weatherProvider.notifier)
              .fetchWeatherAndForecast('London');
        },
      );
    }

    if (weatherState.hasWeather) {
      final weather = weatherState.currentWeather!;
      final favoritesState = ref.watch(favoritesProvider);
      final isFavorite = favoritesState.favorites.any(
        (city) =>
            city.name.toLowerCase() ==
            weather.cityName.toLowerCase(),
      );

      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(weatherProvider.notifier)
              .fetchWeatherAndForecast(weather.cityName);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: WeatherCard(
                  weather: weather,
                  isFavorite: isFavorite,
                  onFavoritePressed: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(weather);
                  },
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              _detailRow(
                Icons.thermostat,
                'Min / Max',
                '${weather.tempMin.round()}° / ${weather.tempMax.round()}°',
              ),
              _detailRow(
                Icons.speed,
                'Pressure',
                '${weather.pressure} hPa',
              ),
              _detailRow(
                Icons.wb_sunny_outlined,
                'Sunrise',
                _formatTime(weather.sunrise),
              ),
              _detailRow(
                Icons.nightlight_round,
                'Sunset',
                _formatTime(weather.sunset),
              ),
            ],
          ),
        ),
      );
    }

    return _buildEmptyState(context);
  }

  // ================= DETAIL ROW =================

  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded,
                size: 70, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Search a City',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Find live weather updates\nfor any location worldwide',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
