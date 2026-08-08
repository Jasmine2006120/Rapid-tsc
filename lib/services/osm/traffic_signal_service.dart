import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/traffic/traffic_signal_model.dart';

class TrafficSignalService {
  static const String _overpassUrl =
      'https://overpass-api.de/api/interpreter';

  Future<List<TrafficSignalModel>> getTrafficSignals({
    required double latitude,
    required double longitude,
    double radiusMeters = 1000,
  }) async {
    final query = '''
[out:json];
(
  node["highway"="traffic_signals"]
    (around:$radiusMeters,$latitude,$longitude);
);
out body;
''';

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        body: {
          'data': query,
        },
      );

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body);

      final elements = data['elements'];

      if (elements == null || elements is! List) {
        return [];
      }

      return elements.map<TrafficSignalModel>((element) {
        final tags = element['tags'] as Map<String, dynamic>?;

        return TrafficSignalModel(
          id: element['id'].toString(),
          latitude: (element['lat'] as num).toDouble(),
          longitude: (element['lon'] as num).toDouble(),
          name: tags?['name']?.toString(),
          isActive: true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}