import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/destination/destination_service.dart';
import '../../services/osm/osm_service.dart';

class LiveMapScreen extends StatefulWidget {
  final String? destinationName;

  const LiveMapScreen({
    super.key,
    this.destinationName,
  });

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _mapController;

  final LatLng _currentLocation = const LatLng(
    30.3752,
    76.7821,
  );

  LatLng? _destination;

  final OsmService _osmService = OsmService();

  bool _routeLoading = true;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  double? _routeDistanceMeters;
  double? _routeDurationSeconds;

  @override
  void initState() {
    super.initState();

    _setDestination();
    _loadRealRoute();
  }

  void _setDestination() {
    final name = widget.destinationName;

    if (name == null) {
      _destination = const LatLng(
        30.3810,
        76.7950,
      );
      return;
    }

    final destination =
        DestinationService.findByName(name);

    if (destination == null) {
      _destination = const LatLng(
        30.3810,
        76.7950,
      );
      return;
    }

    _destination = LatLng(
      destination.latitude,
      destination.longitude,
    );

    _addMarkers();
  }

  void _addMarkers() {
    final destination = _destination;

    if (destination == null) {
      return;
    }

    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('emergency_vehicle'),
        position: _currentLocation,
        infoWindow: const InfoWindow(
          title: 'Emergency Vehicle',
          snippet: 'Current vehicle location',
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        infoWindow: InfoWindow(
          title: widget.destinationName ?? 'Destination',
        ),
      ),
    );
  }

  Future<void> _loadRealRoute() async {
    final destination = _destination;

    if (destination == null) {
      if (mounted) {
        setState(() {
          _routeLoading = false;
        });
      }

      return;
    }

    if (mounted) {
      setState(() {
        _routeLoading = true;
      });
    }

    final result = await _osmService.getRealRoute(
      startLatitude: _currentLocation.latitude,
      startLongitude: _currentLocation.longitude,
      destinationLatitude: destination.latitude,
      destinationLongitude: destination.longitude,
    );

    if (!mounted) {
      return;
    }

    if (result == null || result.points.isEmpty) {
      setState(() {
        _routeLoading = false;
      });

      return;
    }

    final routePoints = result.points.map<LatLng>((point) {
      return LatLng(
        point.latitude,
        point.longitude,
      );
    }).toList();

    setState(() {
      _routeDistanceMeters = result.distanceMeters;
      _routeDurationSeconds = result.durationSeconds;

      _polylines.clear();

      _polylines.add(
        Polyline(
          polylineId: const PolylineId(
            'real_emergency_route',
          ),
          points: routePoints,
          width: 6,
          jointType: JointType.round,
        ),
      );

      _routeLoading = false;
    });

    _fitMapToRoute(routePoints);
  }

  void _fitMapToRoute(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) {
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }

      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }

      if (point.longitude < minLng) {
        minLng = point.longitude;
      }

      if (point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            minLat,
            minLng,
          ),
          northeast: LatLng(
            maxLat,
            maxLng,
          ),
        ),
        70,
      ),
    );
  }

  String _formatDistance() {
    final distance = _routeDistanceMeters;

    if (distance == null) {
      return '--';
    }

    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }

    return '${distance.toStringAsFixed(0)} m';
  }

  String _formatDuration() {
    final duration = _routeDurationSeconds;

    if (duration == null) {
      return '--';
    }

    final minutes = (duration / 60).ceil();

    if (minutes < 60) {
      return '$minutes min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Emergency Route',
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 13,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.emergency,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.destinationName == null
                                ? 'Emergency Route'
                                : 'Emergency Route → ${widget.destinationName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _routeInfo(
                            'Distance',
                            _formatDistance(),
                            Icons.route,
                          ),
                        ),
                        Expanded(
                          child: _routeInfo(
                            'ETA',
                            _formatDuration(),
                            Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_routeLoading)
            const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 14),
                      Text(
                        'Calculating emergency route...',
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

  Widget _routeInfo(
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}