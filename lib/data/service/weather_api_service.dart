import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constant.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';


class WeatherApiService {

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConstants.getCurrentWeatherByCity(cityName);
      debugPrint('API: Fetching weather for city: $url');
      
      final response = await _client.get(Uri.parse(url));
      debugPrint('API: Response status: ${response.statusCode}');
    
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else if (response.statusCode == 404) {
        // City not found
        throw Exception('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('Invalid API key. Please check your API key.');
      } else {
        // Other errors
        throw Exception('Failed to fetch weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API: Error - $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  
  Future<WeatherModel> getCurrentWeatherByCoords(double lat, double lon) async {
    try {
      // Build the API URL
      final url = ApiConstants.getCurrentWeatherByCoords(lat, lon);
      debugPrint('API: Fetching weather for coords: $url');
      
      // Make the HTTP GET request
      final response = await _client.get(Uri.parse(url));
      debugPrint('API: Response status: ${response.statusCode}');
      
      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON and return WeatherModel
        final json = jsonDecode(response.body);
        debugPrint('API: Successfully parsed weather data');
        return WeatherModel.fromJson(json);
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('Invalid API key. Please check your API key.');
      } else {
        // Other errors
        throw Exception('Failed to fetch weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API: Error - $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  
  Future<ForecastResponseModel> getForecastByCity(String cityName) async {
    try {
      // Build the API URL
      final url = ApiConstants.getForecastByCity(cityName);
      
      // Make the HTTP GET request
      final response = await _client.get(Uri.parse(url));
      
      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON and return ForecastResponseModel
        final json = jsonDecode(response.body);
        return ForecastResponseModel.fromJson(json);
      } else if (response.statusCode == 404) {
        // City not found
        throw Exception('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('Invalid API key. Please check your API key.');
      } else {
        // Other errors
        throw Exception('Failed to fetch forecast data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

 
  Future<ForecastResponseModel> getForecastByCoords(double lat, double lon) async {
    try {
      // Build the API URL
      final url = ApiConstants.getForecastByCoords(lat, lon);
      
      // Make the HTTP GET request
      final response = await _client.get(Uri.parse(url));
      
      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON and return ForecastResponseModel
        final json = jsonDecode(response.body);
        return ForecastResponseModel.fromJson(json);
      } else if (response.statusCode == 401) {
        // Invalid API key
        throw Exception('Invalid API key. Please check your API key.');
      } else {
        // Other errors
        throw Exception('Failed to fetch forecast data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error. Please check your internet connection.');
    }
  }

  // Dispose the HTTP client when done
  void dispose() {
    _client.close();
  }
}
