import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favourite_provider.dart';
import '../../weather/presentation/weather_provder.dart';
import '../../../core/constants/api_constant.dart';
import '../../../core/utils/weather_helper.dart';
import '../../../shared/widgets/loading_widget.dart';


class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoritesNotifier = ref.read(favoritesProvider.notifier);
      favoritesNotifier.loadFavorites().then((_) {
        favoritesNotifier.fetchFavoritesWeather();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Minimal Header
            _buildHeader(context, favoritesState, isDark),
            
            // Favorites content
            Expanded(
              child: _buildContent(context, favoritesState, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FavoritesState favoritesState, bool isDark) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.favorite_rounded,
              size: 28,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favourites',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Your saved cities',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (favoritesState.hasFavorites)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_city_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${favoritesState.favoritesCount}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoritesState favoritesState, bool isDark) {
    if (favoritesState.isLoading) {
      return const LoadingWidget(message: 'Loading favorites...');
    }
    
    if (!favoritesState.hasFavorites) {
      return _buildEmptyState(context, isDark);
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(favoritesProvider.notifier).loadFavorites();
        await ref.read(favoritesProvider.notifier).fetchFavoritesWeather();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        itemCount: favoritesState.favorites.length,
        itemBuilder: (context, index) {
          final city = favoritesState.favorites[index];
          final weather = favoritesState.favoritesWeather[city.name];
          
          return _FavoriteCityCard(
            cityName: city.name,
            country: city.country,
            weather: weather,
            isDark: isDark,
            onTap: () {
              ref.read(weatherProvider.notifier).fetchWeatherAndForecast(city.name);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('Loading weather for ${city.name}...'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            onRemove: () => _showRemoveDialog(context, city.name),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the heart icon on any city\nto add it to your favorites',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, String cityName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.heart_broken_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Remove City'),
          ],
        ),
        content: Text('Remove $cityName from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(favoritesProvider.notifier).removeFavorite(cityName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('$cityName removed'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCityCard extends StatelessWidget {
  final String cityName;
  final String country;
  final dynamic weather;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCityCard({
    required this.cityName,
    required this.country,
    required this.weather,
    required this.isDark,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark 
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.grey.withValues(alpha: 0.08);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.15);
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                // Weather icon container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: weather != null
                        ? Image.network(
                            ApiConstants.getIconUrl(weather.icon),
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              WeatherHelper.getWeatherIcon(weather.conditionId ?? 800),
                              size: 28,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : Icon(
                            Icons.cloud_queue_rounded,
                            size: 28,
                            color: subtitleColor,
                          ),
                  ),
                ),
                
                const SizedBox(width: 14),
                
                // City info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: subtitleColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            country,
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                            ),
                          ),
                          if (weather != null) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                WeatherHelper.capitalizeDescription(weather.description ?? ''),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Temperature
                if (weather != null) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${weather.temperature.round()}°',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.water_drop_rounded,
                            size: 12,
                            color: Colors.blue[400],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${weather.humidity}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],
                
                // Remove button
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.red[300],
                    size: 20,
                  ),
                  tooltip: 'Remove from favorites',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
