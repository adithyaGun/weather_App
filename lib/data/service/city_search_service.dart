import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constant.dart';


class CitySearchService {
  final http.Client _client;

  CitySearchService({http.Client? client}) : _client = client ?? http.Client();

  
  Future<List<CityResult>> searchCities(String query) async {
    if (query.trim().length < 2) {
      return [];
    }

    try {
      final url = ApiConstants.searchCities(query, limit: 8);
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        // Parse results and remove duplicates
        final results = <CityResult>[];
        final seen = <String>{};
        
        for (final item in data) {
          final city = CityResult.fromJson(item);
          final key = '${city.name}-${city.country}';
          
          if (!seen.contains(key)) {
            seen.add(key);
            results.add(city);
          }
        }
        
        return results;
      }
      
      return [];
    } catch (e) {
      
      return [];
    }
  }

  
  String getCityName(CityResult city) {
    return city.name;
  }

  void dispose() {
    _client.close();
  }
}


class CityResult {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;

  CityResult({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
  });

  factory CityResult.fromJson(Map<String, dynamic> json) {
    return CityResult(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'],
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
    );
  }

  /// Get the full display name
  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  /// Get short display name (city, country)
  String get shortName => '$name, $country';
}
