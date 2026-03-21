import 'package:dio/dio.dart';

class GooglePlacesService {
  final String apiKey = 'AIzaSyCyO9SWzEn8SWchaaqa6T_yCmCD8cLHPfg';
  final Dio _dio = Dio();

  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': apiKey,
          // 'components': 'country:in', // Optional: restrict to India if appropriate
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions.map((p) => p['description'] as String).toList();
        }
      }
    } catch (e) {
      print('Error fetching place suggestions: $e');
    }
    return [];
  }
}
