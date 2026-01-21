import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';



class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }

  
  Future<Position> getCurrentPosition() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    // Check permission
    LocationPermission permission = await checkAndRequestPermission();
    
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Please enable it in app settings.');
    }

    // On web, getLastKnownPosition is not supported, so skip it
    Position? lastPosition;
    if (!kIsWeb) {
      try {
        lastPosition = await Geolocator.getLastKnownPosition();
        
        if (lastPosition != null) {
          // Check if last position is recent (within 5 minutes)
          final now = DateTime.now();
          final positionTime = lastPosition.timestamp;
          final diff = now.difference(positionTime).inMinutes;
          
          if (diff < 5) {
            return lastPosition;
          }
        }
      } catch (e) {
        // Ignore errors for getLastKnownPosition
      }
    }

    
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return position;
    } catch (e) {
      // If timeout occurs and we have a last known position, use it
      if (lastPosition != null) {
        return lastPosition;
      }
      throw Exception('Could not get location. Please try again.');
    }
  }

  
  Future<Position?> getLastKnownPosition() async {
    if (kIsWeb) {
      return null;
    }
    return await Geolocator.getLastKnownPosition();
  }

  /// Open app settings (for users to enable location permission)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings (for users to enable GPS)
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
