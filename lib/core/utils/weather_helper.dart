import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherHelper {
  // Get weather icon based on condition code
  static IconData getWeatherIcon(int conditionCode) {
    if (conditionCode < 300) {
      // Thunderstorm
      return Icons.flash_on;
    } else if (conditionCode < 400) {
      // Drizzle
      return Icons.grain;
    } else if (conditionCode < 600) {
      // Rain
      return Icons.water_drop;
    } else if (conditionCode < 700) {
      // Snow
      return Icons.ac_unit;
    } else if (conditionCode < 800) {
      // Atmosphere (fog, mist, etc.)
      return Icons.blur_on;
    } else if (conditionCode == 800) {
      // Clear
      return Icons.wb_sunny;
    } else if (conditionCode == 801) {
      // Few clouds
      return Icons.wb_cloudy;
    } else {
      // More clouds (802, 803, 804)
      return Icons.cloud;
    }
  }
  

  static List<Color> getWeatherGradient(int conditionCode, bool isDaytime) {
    if (isDaytime) {
      return _getDayGradient(conditionCode);
    } else {
      return _getNightGradient(conditionCode);
    }
  }
  
  /// Get gradient for daytime weather conditions
  static List<Color> _getDayGradient(int conditionCode) {
    // Thunderstorm (2xx)
    if (conditionCode >= 200 && conditionCode < 300) {
      return AppTheme.stormDayGradient;
    }
    
    // Drizzle (3xx)
    if (conditionCode >= 300 && conditionCode < 400) {
      return AppTheme.drizzleDayGradient;
    }
    
    // Rain (5xx)
    if (conditionCode >= 500 && conditionCode < 600) {
      return AppTheme.rainDayGradient;
    }
    
    // Snow (6xx)
    if (conditionCode >= 600 && conditionCode < 700) {
      return AppTheme.snowDayGradient;
    }
    
    // Atmosphere - mist, fog, haze, etc. (7xx)
    if (conditionCode >= 700 && conditionCode < 800) {
      return AppTheme.mistDayGradient;
    }
    
    // Clear sky (800)
    if (conditionCode == 800) {
      return AppTheme.clearDayGradient;
    }
    
    // Few clouds (801)
    if (conditionCode == 801) {
      return AppTheme.fewCloudsDayGradient;
    }
    
    // Scattered clouds (802) or Broken clouds (803)
    if (conditionCode == 802 || conditionCode == 803) {
      return AppTheme.cloudyDayGradient;
    }
    
    // Overcast clouds (804)
    if (conditionCode == 804) {
      return AppTheme.overcastDayGradient;
    }
    
    // Default to cloudy
    return AppTheme.cloudyDayGradient;
  }
  
  /// Get gradient for nighttime weather conditions
  static List<Color> _getNightGradient(int conditionCode) {
    // Thunderstorm (2xx)
    if (conditionCode >= 200 && conditionCode < 300) {
      return AppTheme.stormNightGradient;
    }
    
    // Drizzle (3xx)
    if (conditionCode >= 300 && conditionCode < 400) {
      return AppTheme.drizzleNightGradient;
    }
    
    // Rain (5xx)
    if (conditionCode >= 500 && conditionCode < 600) {
      return AppTheme.rainNightGradient;
    }
    
    // Snow (6xx)
    if (conditionCode >= 600 && conditionCode < 700) {
      return AppTheme.snowNightGradient;
    }
    
    // Atmosphere - mist, fog, haze, etc. (7xx)
    if (conditionCode >= 700 && conditionCode < 800) {
      return AppTheme.mistNightGradient;
    }
    
    // Clear sky (800)
    if (conditionCode == 800) {
      return AppTheme.clearNightGradient;
    }
    
    // Few clouds (801)
    if (conditionCode == 801) {
      return AppTheme.fewCloudsNightGradient;
    }
    
    // Scattered clouds (802) or Broken clouds (803)
    if (conditionCode == 802 || conditionCode == 803) {
      return AppTheme.cloudyNightGradient;
    }
    
    // Overcast clouds (804)
    if (conditionCode == 804) {
      return AppTheme.overcastNightGradient;
    }
    
    // Default to cloudy night
    return AppTheme.cloudyNightGradient;
  }
  
 
  static bool isDaytimeFromIcon(String iconCode) {
    return iconCode.endsWith('d');
  }
  
 
  static bool isDaytimeFromSunriseSunset(int sunrise, int sunset, int currentTime) {
    return currentTime >= sunrise && currentTime < sunset;
  }
  
  // Get background color based on weather condition
  static Color getWeatherColor(int conditionCode) {
    if (conditionCode == 800) {
      return AppTheme.sunnyColor;
    } else if (conditionCode > 800) {
      return AppTheme.cloudyColor;
    } else if (conditionCode >= 500 && conditionCode < 600) {
      return AppTheme.rainyColor;
    } else if (conditionCode >= 600 && conditionCode < 700) {
      return AppTheme.snowyColor;
    } else if (conditionCode < 300) {
      return AppTheme.stormColor;
    }
    return AppTheme.cloudyColor;
  }
  
  // Convert wind direction degrees to compass direction
  static String getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) {
      return 'N';
    } else if (degrees >= 22.5 && degrees < 67.5) {
      return 'NE';
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return 'E';
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return 'SE';
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return 'S';
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return 'SW';
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return 'W';
    } else {
      return 'NW';
    }
  }
  
  // Get weather description with first letter capitalized
  static String capitalizeDescription(String description) {
    if (description.isEmpty) return '';
    return description[0].toUpperCase() + description.substring(1);
  }
  
  // Get UV index level description
  static String getUVLevel(double uvIndex) {
    if (uvIndex <= 2) {
      return 'Low';
    } else if (uvIndex <= 5) {
      return 'Moderate';
    } else if (uvIndex <= 7) {
      return 'High';
    } else if (uvIndex <= 10) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }
  
  // Get air quality description
  static String getAirQualityLevel(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }
}
