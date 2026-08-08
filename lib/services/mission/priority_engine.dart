import 'dart:math';

import '../../models/traffic/traffic_signal_model.dart';

class PriorityEngine {
  static const double defaultSignalActivationDistance = 500;

  List<TrafficSignalModel> findRelevantSignals({
    required List<TrafficSignalModel> signals,
    required List<double> routeLatitudes,
    required List<double> routeLongitudes,
    double maxDistanceFromRoute = 50,
  }) {
    if (signals.isEmpty ||
        routeLatitudes.isEmpty ||
        routeLongitudes.isEmpty ||
        routeLatitudes.length != routeLongitudes.length) {
      return [];
    }

    final relevantSignals = <TrafficSignalModel>[];

    for (final signal in signals) {
      double closestDistance = double.infinity;

      for (int i = 0; i < routeLatitudes.length; i++) {
        final distance = _distanceInMeters(
          signal.latitude,
          signal.longitude,
          routeLatitudes[i],
          routeLongitudes[i],
        );

        if (distance < closestDistance) {
          closestDistance = distance;
        }
      }

      if (closestDistance <= maxDistanceFromRoute) {
        relevantSignals.add(
          signal.copyWith(
            distanceFromRoute: closestDistance,
          ),
        );
      }
    }

    relevantSignals.sort(
      (a, b) => (a.distanceFromRoute ?? double.infinity)
          .compareTo(b.distanceFromRoute ?? double.infinity),
    );

    return relevantSignals;
  }

  bool shouldActivateSignal({
    required TrafficSignalModel signal,
    required double vehicleLatitude,
    required double vehicleLongitude,
    double activationDistanceMeters = defaultSignalActivationDistance,
  }) {
    final distance = _distanceInMeters(
      signal.latitude,
      signal.longitude,
      vehicleLatitude,
      vehicleLongitude,
    );

    return distance <= activationDistanceMeters;
  }

  double distanceToSignal({
    required TrafficSignalModel signal,
    required double vehicleLatitude,
    required double vehicleLongitude,
  }) {
    return _distanceInMeters(
      signal.latitude,
      signal.longitude,
      vehicleLatitude,
      vehicleLongitude,
    );
  }

  double _distanceInMeters(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    const earthRadius = 6371000.0;

    final lat1 = _toRadians(latitude1);
    final lat2 = _toRadians(latitude2);

    final deltaLat = _toRadians(latitude2 - latitude1);
    final deltaLon = _toRadians(longitude2 - longitude1);

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) *
            cos(lat2) *
            sin(deltaLon / 2) *
            sin(deltaLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}