import 'package:uuid/uuid.dart';

import '../../models/mission/emergency_request.dart';
import '../../models/vehicle/app_vehicle.dart';

class EmergencyService {
  final Uuid _uuid = const Uuid();

  EmergencyRequest createEmergencyRequest({
    required AppVehicle vehicle,
    required String emergencyCategory,
    required String destination,
  }) {
    final priorityScore = _calculatePriority(emergencyCategory);

    return EmergencyRequest(
      requestId: _uuid.v4(),
      vehicleId: vehicle.vehicleId,
      vehicleType: vehicle.vehicleType,
      emergencyCategory: emergencyCategory,
      destination: destination,
      priorityScore: priorityScore,
      activationDistanceMeters: 500,
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  Future<EmergencyRequest> verifyRequest(
    EmergencyRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    return request.copyWith(
      status: 'priority_granted',
    );
  }

  int _calculatePriority(String category) {
    switch (category) {
      case 'Critical Patient Transport':
        return 100;

      case 'Fire Response':
        return 95;

      case 'Police Emergency':
        return 90;

      case 'Disaster Response':
        return 85;

      case 'Organ/Blood Transport':
        return 80;

      default:
        return 50;
    }
  }
}