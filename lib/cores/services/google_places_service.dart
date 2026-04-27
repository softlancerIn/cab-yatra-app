import 'package:dio/dio.dart';

class GooglePlacesService {
  final String apiKey = 'AIzaSyAj3PI49OjhovFnlGZZ6veCZrKwyp7jZP0';
  final Dio _dio = Dio();

  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': apiKey,
          'components':
              'country:in', // Restrict to India for better localized results
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions.map((p) => p['description'] as String).toList();
        } else {
          print('Google Places Status: ${data['status']}');
          if (data['error_message'] != null) {
            print('Google Places Error: ${data['error_message']}');
          }
        }
      }
    } catch (e) {
      print('Error fetching place suggestions: $e');
    }
    return [];
  }
}
