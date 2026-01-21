import 'package:flutter/material.dart';
import '../../core/constants/api_constant.dart';
import '../../data/model/forecast_model.dart';
import '../../core/utils/date_time_helper.dart';
import '../../core/utils/weather_helper.dart';



class ForecastCard extends StatelessWidget {
  final ForecastModel forecast;
  final bool isExpanded;
  final bool isToday;
  final VoidCallback? onTap;

  const ForecastCard({
    super.key,
    required this.forecast,
    this.isExpanded = false,
    this.isToday = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday 
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isToday 
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.3),
                width: isToday ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                // Main row with day, icon, and temperature
                Row(
                  children: [
                    // Day and date column
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          // Day indicator
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isToday 
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getDayNumber(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  _getMonthAbbr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Day name and description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isToday
                                          ? 'Today'
                                          : DateTimeHelper.formatShortDayName(forecast.dateTime),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isToday) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'NOW',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  WeatherHelper.capitalizeDescription(forecast.description),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Weather icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Image.network(
                          ApiConstants.getIconUrl(forecast.icon),
                          width: 44,
                          height: 44,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              WeatherHelper.getWeatherIcon(forecast.conditionId),
                              size: 32,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Temperature column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${forecast.temperature.round()}°',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward_rounded,
                              size: 12,
                              color: Colors.orange[200],
                            ),
                            Text(
                              '${forecast.tempMax.round()}°',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange[200],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_downward_rounded,
                              size: 12,
                              color: Colors.lightBlue[200],
                            ),
                            Text(
                              '${forecast.tempMin.round()}°',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.lightBlue[200],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Expand indicator
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                
                // Expanded details with animation
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedDetails(),
                  crossFadeState: isExpanded 
                      ? CrossFadeState.showSecond 
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDayNumber() {
    final date = DateTime.fromMillisecondsSinceEpoch(forecast.dateTime * 1000);
    return date.day.toString();
  }

  String _getMonthAbbr() {
    final date = DateTime.fromMillisecondsSinceEpoch(forecast.dateTime * 1000);
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
                    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[date.month - 1];
  }

  // Build expanded details section with glassmorphism
  Widget _buildExpandedDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0),
                  Colors.white.withValues(alpha: 0.4),
                  Colors.white.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Details grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem(
                icon: Icons.water_drop_rounded,
                label: 'Humidity',
                value: '${forecast.humidity}%',
              ),
              _buildDetailItem(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '${forecast.windSpeed.toStringAsFixed(1)} m/s',
              ),
              _buildDetailItem(
                icon: Icons.umbrella_rounded,
                label: 'Rain',
                value: '${forecast.precipitationPercentage}%',
              ),
              _buildDetailItem(
                icon: Icons.compress_rounded,
                label: 'Pressure',
                value: '${forecast.pressure} hPa',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build a single detail item with modern style
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
