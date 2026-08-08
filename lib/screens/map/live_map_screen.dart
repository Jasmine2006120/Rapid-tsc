import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../../services/location/location_service.dart';
import '../../services/mission/priority_engine.dart';
import '../../services/osm/osm_service.dart';
import '../../services/osm/traffic_signal_service.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({
    super.key,
  });

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
GoogleMapController? _mapController;

  static const LatLng _initialLocation = LatLng(
    30.3752,
    76.7821,
  );

  static const LatLng _destination = LatLng(
  30.3810,
  76.7950,
);

  final Set<Marker> _markers = {};
final Set<Polyline> _polylines = {};


  final LocationService _locationService = LocationService();
final OsmService _osmService = OsmService();
final TrafficSignalService _trafficSignalService =
    TrafficSignalService();
final PriorityEngine _priorityEngine = PriorityEngine();
  Future<void> _loadCurrentLocation() async {
  final position = await _locationService.getCurrentLocation();

  if (!mounted || position == null) {
    return;
  }

  final location = LatLng(
    position.latitude,
    position.longitude,
  );

  setState(() {
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'emergency_vehicle',
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('emergency_vehicle'),
        position: location,
        infoWindow: const InfoWindow(
          title: 'Emergency Vehicle',
          snippet: 'Current location',
        ),
      ),
    );
  });

  if (_mapController != null) {
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        location,
        16,
      ),
    );
  }
}

Future<void> _loadTrafficSignals() async {
  final position = await _locationService.getCurrentLocation();

  if (!mounted || position == null) {
    return;
  }

  final signals = await _trafficSignalService.getTrafficSignals(
    latitude: position.latitude,
    longitude: position.longitude,
    radiusMeters: 1000,
  );

  if (!mounted) {
    return;
  }

  final routeLatitudes = <double>[];
  final routeLongitudes = <double>[];

  for (final polyline in _polylines) {
    for (final point in polyline.points) {
      routeLatitudes.add(point.latitude);
      routeLongitudes.add(point.longitude);
    }
  }

  final relevantSignals = _priorityEngine.findRelevantSignals(
    signals: signals,
    routeLatitudes: routeLatitudes,
    routeLongitudes: routeLongitudes,
    maxDistanceFromRoute: 50,
  );

  setState(() {
    

    _markers.removeWhere(
      (marker) => marker.markerId.value.startsWith('traffic_signal_'),
    );

    for (int i = 0; i < relevantSignals.length; i++) {
      final signal = relevantSignals[i];

      _markers.add(
        Marker(
          markerId: MarkerId('traffic_signal_$i'),
          position: LatLng(
            signal.latitude,
            signal.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Traffic Signal ${i + 1}',
            snippet: signal.distanceFromRoute == null
                ? 'Route signal'
                : '${signal.distanceFromRoute!.round()} m from route',
          ),
        ),
      );
    }
  });
}

Future<void> _loadRealRoute() async {
  final position = await _locationService.getCurrentLocation();

  if (!mounted || position == null) {
    return;
  }

  final route = await _osmService.getRealRoute(
    startLatitude: position.latitude,
    startLongitude: position.longitude,
    destinationLatitude: _destination.latitude,
    destinationLongitude: _destination.longitude,
  );

  if (!mounted || route == null || route.points.isEmpty) {
    return;
  }

  final routePoints = route.points.map<LatLng>((point) {
    return LatLng(
      point.latitude,
      point.longitude,
    );
  }).toList();

  setState(() {
    _polylines.clear();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('real_osm_route'),
        points: routePoints,
        width: 6,
        geodesic: false,
      ),
    );

    _markers.removeWhere(
      (marker) => marker.markerId.value == 'destination',
    );

    _markers.add(
      const Marker(
        markerId: MarkerId('destination'),
        position: _destination,
        infoWindow: InfoWindow(
          title: 'Destination',
        ),
      ),
    );
  });
}

@override
void initState() {
  super.initState();

  _loadCurrentLocation();
  _loadRealRoute().then((_) {
    _loadTrafficSignals();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Emergency Route'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialLocation,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emergency,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Emergency route monitoring active',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}