import '../models/emergency_request.dart';

final EmergencyRequest sampleEmergencyRequest =
    EmergencyRequest(
  requestId: 'REQ-AMB-001',
  vehicleId: 'GW-AMB-001',
  vehicleType: 'Emergency Ambulance',
  emergencyCategory: 'Cardiac Emergency',
  destination: 'Deakin University Hospital',

  severity: 'Critical',
  location: 'Burwood Highway',
  resourceType: 'Ambulance',
  status: 'Active',
  etaMinutes: 4,

  priorityScore: 95,
  activationDistanceMeters: 500,
  createdAt: DateTime.now(),

  dispatchCompleted: true,
  contactCompleted: true,
  escalationCompleted: true,
  routingCompleted: false,
  resolutionCompleted: false,
);