import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  Set<Marker> createMarkers({
    required LatLng vehicleLocation,
    required LatLng destination,
  }) {
    return {
      Marker(
        markerId: const MarkerId('emergency_vehicle'),
        position: vehicleLocation,
        infoWindow: const InfoWindow(
          title: 'Emergency Vehicle',
        ),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        infoWindow: const InfoWindow(
          title: 'Destination',
        ),
      ),
    };
  }

  Set<Polyline> createRoutePolyline({
    required List<LatLng> routePoints,
  }) {
    if (routePoints.isEmpty) {
      return {};
    }

    return {
      Polyline(
        polylineId: const PolylineId('real_road_route'),
        points: routePoints,
        width: 6,
        geodesic: false,
      ),
    };
  }

  Set<Marker> createTrafficSignalMarkers({
    required List<LatLng> signalLocations,
  }) {
    return {
      for (int i = 0; i < signalLocations.length; i++)
        Marker(
          markerId: MarkerId('traffic_signal_$i'),
          position: signalLocations[i],
          infoWindow: InfoWindow(
            title: 'Traffic Signal ${i + 1}',
          ),
        ),
    };
  }
}