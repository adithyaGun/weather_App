import 'package:intl/intl.dart';


class DateTimeHelper {
  
  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEEE, MMM d').format(date);
  }
  
  
  static String formatShortDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MMM d').format(date);
  }
  
  
  static String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h:mm a').format(date);
  }
  
  
  static String formatDayName(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEEE').format(date);
  }
  
  
  static String formatShortDayName(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEE').format(date);
  }
  
 
  static bool isToday(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  
  static int getHour(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date.hour;
  }
  
  
  static bool isDaytime(int timestamp) {
    final hour = getHour(timestamp);
    return hour >= 6 && hour < 18;
  }
}
