import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLoad());
  }

  void _initLoad() {
    final weather = ref.read(weatherProvider.notifier);
    final favs = ref.read(favoritesProvider.notifier);

    weather.loadLastCity().then((_) {
      if (!ref.read(weatherProvider).hasWeather) {
        weather.fetchWeatherAndForecast('London');
      }
    });

    favs.loadFavorites();
  }

  bool _isNight(String? icon) {
    if (icon != null && icon.isNotEmpty) return icon.endsWith('n');
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

    final state = ref.watch(weatherProvider);

    return AnimatedWeatherBackground(
      weatherCondition: state.currentWeather?.description,
      isNight: _isNight(state.currentWeather?.icon),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: _locationFab(state),
          body: _buildBody(state),
        ),
      ),
    );
  }

  // ================= BODY =================

  Widget _buildBody(WeatherState state) {
    if (state.isLoading) {
      return const LoadingWidget(
        message: 'Collecting atmospheric data...',
      );
    }

    if (state.errorMessage != null) {
      return ErrorDisplayWidget(
        message: state.errorMessage!,
        onRetry: () {
          ref
              .read(weatherProvider.notifier)
              .fetchWeatherAndForecast('London');
        },
      );
    }

    if (!state.hasWeather) {
      return _emptyState();
    }

    return _weatherFlow(state);
  }

  // ================= MAIN FLOW =================

  Widget _weatherFlow(WeatherState state) {
    final weather = state.currentWeather!;
    final favState = ref.watch(favoritesProvider);

    final isFav = favState.favorites.any(
      (c) => c.name.toLowerCase() == weather.cityName.toLowerCase(),
    );

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: _temperatureStage(weather, isFav),
        ),
        Expanded(
          flex: 3,
          child: _infoRail(weather),
        ),
      ],
    );
  }

  // ================= TEMPERATURE STAGE =================

  Widget _temperatureStage(weather, bool isFav) {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),

          const Spacer(),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature.round()}',
                style: const TextStyle(
                  fontSize: 110,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _tempChip('MIN', '${weather.tempMin.round()}°'),
              const SizedBox(width: 18),
              _tempChip('MAX', '${weather.tempMax.round()}°'),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(weather);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          SearchBarWidget(
            hintText: 'Change location',
            onSearch: (city) {
              ref
                  .read(weatherProvider.notifier)
                  .fetchWeatherAndForecast(city);
            },
          ),
        ],
      ),
    );
  }

  Widget _tempChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.6,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ================= INFO RAIL =================

  Widget _infoRail(weather) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          _railItem('Pressure', '${weather.pressure} hPa'),
          _railItem('Sunrise', _formatTime(weather.sunrise)),
          _railItem('Sunset', _formatTime(weather.sunset)),

          const SizedBox(height: 22),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          _infoGrid(weather),
        ],
      ),
    );
  }

  Widget _railItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EXTRA STATS =================

  Widget _infoGrid(weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _miniStat(
          icon: Icons.water_drop_outlined,
          label: 'Humidity',
          value: '${weather.humidity}%',
        ),
        _miniStat(
          icon: Icons.air,
          label: 'Wind',
          value: '${weather.windSpeed} m/s',
        ),
        _miniStat(
          icon: Icons.visibility_outlined,
          label: 'Visibility',
          value:
              '${(weather.visibility / 1000).toStringAsFixed(1)} km',
        ),
      ],
    );
  }

  Widget _miniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ================= EMPTY =================

  Widget _emptyState() {
    return Center(
      child: Text(
        'Search a city to begin',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  // ================= FLOATING BUTTON =================

  Widget _locationFab(WeatherState state) {
    return FloatingActionButton.extended(
      onPressed: state.isLoading
          ? null
          : () => ref
              .read(weatherProvider.notifier)
              .fetchWeatherByLocation(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      icon: const Icon(Icons.my_location),
      label: const Text('Use GPS'),
    );
  }

  String _formatTime(int timestamp) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
