import 'dart:convert';

import 'package:http/http.dart' as http;

class OsmRoutePoint {
  final double latitude;
  final double longitude;

  const OsmRoutePoint({
    required this.latitude,
    required this.longitude,
  });
}

class OsmRouteResult {
  final List<OsmRoutePoint> points;
  final double distanceMeters;
  final double durationSeconds;

  const OsmRouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class OsmService {
  static const String _baseUrl =
      'https://router.project-osrm.org/route/v1/driving';

  Future<OsmRouteResult?> getRealRoute({
    required double startLatitude,
    required double startLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/'
      '$startLongitude,$startLatitude;'
      '$destinationLongitude,$destinationLatitude'
      '?overview=full&geometries=geojson&steps=true',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data['code'] != 'Ok') {
        return null;
      }

      final routes = data['routes'];

      if (routes == null || routes.isEmpty) {
        return null;
      }

      final route = routes[0];

      final geometry = route['geometry'];
      final coordinates = geometry['coordinates'] as List;

      final points = coordinates.map<OsmRoutePoint>((coordinate) {
        return OsmRoutePoint(
          longitude: (coordinate[0] as num).toDouble(),
          latitude: (coordinate[1] as num).toDouble(),
        );
      }).toList();

      return OsmRouteResult(
        points: points,
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}