import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../weather/presentation/weather_provder.dart';
import '../../../shared/widgets/forecast_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/animater_weather_background.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  int? _expandedIndex;

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
    final hasWeather = weatherState.hasForecast;

    return AnimatedWeatherBackground(
      weatherCondition: weatherCondition,
      isNight: isNight,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, weatherState, hasWeather),
            Expanded(
              child: _buildContent(context, weatherState),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(
      BuildContext context, WeatherState weatherState, bool hasWeather) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: hasWeather
              ? Colors.white.withValues(alpha: 0.18)
              : Theme.of(context).primaryColor.withValues(alpha: 0.12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 30,
              color: hasWeather ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Forecast',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: hasWeather ? Colors.white : null,
                    ),
                  ),
                  if (weatherState.hasForecast) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${weatherState.forecast!.cityName}, ${weatherState.forecast!.country}',
                      style: TextStyle(
                        fontSize: 14,
                        color: hasWeather
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (weatherState.hasForecast)
              Column(
                children: [
                  Text(
                    '${weatherState.forecast!.dailySummary.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: hasWeather ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Days',
                    style: TextStyle(
                      fontSize: 12,
                      color: hasWeather
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ================= CONTENT =================

  Widget _buildContent(BuildContext context, WeatherState weatherState) {
    if (weatherState.isLoading) {
      return const LoadingWidget(message: 'Loading forecast...');
    }

    if (weatherState.errorMessage != null) {
      return ErrorDisplayWidget(
        message: weatherState.errorMessage!,
        onRetry: () {
          if (weatherState.currentCity.isNotEmpty) {
            ref
                .read(weatherProvider.notifier)
                .fetchWeatherAndForecast(weatherState.currentCity);
          }
        },
      );
    }

    if (weatherState.hasForecast) {
      final forecast = weatherState.forecast!;
      final dailyForecasts = forecast.dailySummary;

      return RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(weatherProvider.notifier)
              .fetchWeatherAndForecast(forecast.cityName);
        },
        color: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          itemCount: dailyForecasts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final dayForecast = dailyForecasts[index];
            final isExpanded = _expandedIndex == index;
            final isToday = index == 0;

            return ForecastCard(
              forecast: dayForecast,
              isExpanded: isExpanded,
              isToday: isToday,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == index ? null : index;
                });
              },
            );
          },
        ),
      );
    }

    return _buildEmptyState(context);
  }

  // ================= EMPTY STATE =================

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Forecast Unavailable',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Search for a city from the Home screen\nto view upcoming weather trends',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
