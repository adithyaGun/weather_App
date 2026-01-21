import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1E88E5);  // Blue
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  
  // Accent Colors
  static const Color accentColor = Color(0xFFFF9800);  // Orange
  static const Color accentLight = Color(0xFFFFB74D);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;
  
  // Weather Condition Colors
  static const Color sunnyColor = Color(0xFF87CEEB);
  static const Color cloudyColor = Color(0xFF90A4AE);
  static const Color rainyColor = Color(0xFF42A5F5);
  static const Color snowyColor = Color(0xFFE3F2FD);
  static const Color stormColor = Color(0xFF5C6BC0);
  
  // ============== DAY TIME GRADIENTS ==============
  
  // Clear sky day - Beautiful blue sky
  static const List<Color> clearDayGradient = [
    Color(0xFF4FC3F7),  // Light blue
    Color(0xFF29B6F6),  // Sky blue
    Color(0xFF03A9F4),  // Deeper blue
  ];
  
  // Few clouds day - Blue with slight haze
  static const List<Color> fewCloudsDayGradient = [
    Color(0xFF81D4FA),
    Color(0xFF4FC3F7),
    Color(0xFF29B6F6),
  ];
  
  // Scattered/Broken clouds day
  static const List<Color> cloudyDayGradient = [
    Color(0xFF90CAF9),
    Color(0xFF64B5F6),
    Color(0xFF42A5F5),
  ];
  
  // Overcast clouds day - Grayish blue
  static const List<Color> overcastDayGradient = [
    Color(0xFF78909C),
    Color(0xFF607D8B),
    Color(0xFF546E7A),
  ];
  
  // Rain day
  static const List<Color> rainDayGradient = [
    Color(0xFF546E7A),
    Color(0xFF455A64),
    Color(0xFF37474F),
  ];
  
  // Thunderstorm day
  static const List<Color> stormDayGradient = [
    Color(0xFF455A64),
    Color(0xFF37474F),
    Color(0xFF263238),
  ];
  
  // Snow day
  static const List<Color> snowDayGradient = [
    Color(0xFFECEFF1),
    Color(0xFFCFD8DC),
    Color(0xFFB0BEC5),
  ];
  
  // Mist/Fog day
  static const List<Color> mistDayGradient = [
    Color(0xFFB0BEC5),
    Color(0xFF90A4AE),
    Color(0xFF78909C),
  ];
  
  // Drizzle day
  static const List<Color> drizzleDayGradient = [
    Color(0xFF78909C),
    Color(0xFF607D8B),
    Color(0xFF546E7A),
  ];
  
  // ============== NIGHT TIME GRADIENTS ==============
  
  // Clear night - Dark blue with stars vibe
  static const List<Color> clearNightGradient = [
    Color(0xFF0D1B2A),
    Color(0xFF1B263B),
    Color(0xFF415A77),
  ];
  
  // Few clouds night
  static const List<Color> fewCloudsNightGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF1F4068),
  ];
  
  // Cloudy night
  static const List<Color> cloudyNightGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF2D3748),
    Color(0xFF4A5568),
  ];
  
  // Overcast night - Dark gray clouds
  static const List<Color> overcastNightGradient = [
    Color(0xFF1A202C),
    Color(0xFF2D3748),
    Color(0xFF4A5568),
  ];
  
  // Rain night
  static const List<Color> rainNightGradient = [
    Color(0xFF1A202C),
    Color(0xFF2D3748),
    Color(0xFF3D4852),
  ];
  
  // Thunderstorm night
  static const List<Color> stormNightGradient = [
    Color(0xFF0D1117),
    Color(0xFF161B22),
    Color(0xFF21262D),
  ];
  
  // Snow night
  static const List<Color> snowNightGradient = [
    Color(0xFF2D3748),
    Color(0xFF4A5568),
    Color(0xFF718096),
  ];
  
  // Mist/Fog night
  static const List<Color> mistNightGradient = [
    Color(0xFF2D3748),
    Color(0xFF4A5568),
    Color(0xFF5A6A7A),
  ];
  
  // Drizzle night
  static const List<Color> drizzleNightGradient = [
    Color(0xFF1A202C),
    Color(0xFF2D3748),
    Color(0xFF4A5568),
  ];
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textLight,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      prefixIconColor: textSecondary,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondary,
      ),
    ),
  );
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: const Color(0xFF16213E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF16213E),
      foregroundColor: textLight,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF16213E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF16213E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      prefixIconColor: textLight,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFFB0BEC5),
      ),
    ),
  );
}
