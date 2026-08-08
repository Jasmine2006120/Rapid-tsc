class EmergencyRequest {
  final String requestId;
  final String vehicleId;
  final String vehicleType;
  final String emergencyCategory;
  final String destination;
  final int priorityScore;
  final double activationDistanceMeters;
  final String status;
  final DateTime createdAt;

  const EmergencyRequest({
    required this.requestId,
    required this.vehicleId,
    required this.vehicleType,
    required this.emergencyCategory,
    required this.destination,
    required this.priorityScore,
    required this.activationDistanceMeters,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'vehicleId': vehicleId,
      'vehicleType': vehicleType,
      'emergencyCategory': emergencyCategory,
      'destination': destination,
      'priorityScore': priorityScore,
      'activationDistanceMeters': activationDistanceMeters,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmergencyRequest.fromMap(Map<String, dynamic> map) {
    return EmergencyRequest(
      requestId: map['requestId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      emergencyCategory: map['emergencyCategory'] ?? '',
      destination: map['destination'] ?? '',
      priorityScore: map['priorityScore'] ?? 0,
      activationDistanceMeters:
          (map['activationDistanceMeters'] ?? 500).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.tryParse(
            map['createdAt'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  EmergencyRequest copyWith({
    String? requestId,
    String? vehicleId,
    String? vehicleType,
    String? emergencyCategory,
    String? destination,
    int? priorityScore,
    double? activationDistanceMeters,
    String? status,
    DateTime? createdAt,
  }) {
    return EmergencyRequest(
      requestId: requestId ?? this.requestId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleType: vehicleType ?? this.vehicleType,
      emergencyCategory: emergencyCategory ?? this.emergencyCategory,
      destination: destination ?? this.destination,
      priorityScore: priorityScore ?? this.priorityScore,
      activationDistanceMeters:
          activationDistanceMeters ?? this.activationDistanceMeters,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}