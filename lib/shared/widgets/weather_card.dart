import 'package:flutter/material.dart';
import '../../data/model/weather_model.dart';
import '../../core/utils/weather_helper.dart';



class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;
  final bool compact;

  const WeatherCard({
    super.key,
    required this.weather,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  
  bool _isDaytime() {
    return WeatherHelper.isDaytimeFromIcon(weather.icon);
  }

  Widget _buildFullCard(BuildContext context) {
    final isDaytime = _isDaytime();
    final gradientColors = WeatherHelper.getWeatherGradient(weather.id, isDaytime);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),  // Increased
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),  // Increased
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Location and Favorite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    weather.cityName,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              weather.country,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Favorite button with animation
                      if (onFavoritePressed != null)
                        GestureDetector(
                          onTap: onFavoritePressed,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isFavorite 
                                  ? Colors.red.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Main weather display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Weather icon
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),  // Increased more
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          WeatherHelper.getWeatherIcon(weather.id),
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Temperature
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weather.temperature.round()}',
                                  style: const TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    '°C',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Feels like ${weather.feelsLike.round()}°C',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Weather description
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),  // Increased more
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      WeatherHelper.capitalizeDescription(weather.description),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Weather stats row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),  // Increased more
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),  // Increased
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.water_drop_rounded,
                          value: '${weather.humidity}%',
                          label: 'Humidity',
                        ),
                        _buildDivider(),
                        _buildStatItem(
                          icon: Icons.air_rounded,
                          value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                          label: 'Wind',
                        ),
                        _buildDivider(),
                        _buildStatItem(
                          icon: Icons.visibility_rounded,
                          value: '${(weather.visibility / 1000).round()} km',
                          label: 'Visibility',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 22,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final isDaytime = _isDaytime();
    final gradientColors = WeatherHelper.getWeatherGradient(weather.id, isDaytime);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Weather icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.35),  // Increased more
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                WeatherHelper.getWeatherIcon(weather.id),
                size: 32,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // City and weather info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    WeatherHelper.capitalizeDescription(weather.description),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Temperature
            Text(
              '${weather.temperature.round()}°',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
