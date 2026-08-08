class EmergencyRequest {
  final String requestId;
  final String vehicleId;
  final String vehicleType;
  final String emergencyCategory;
  final String destination;

  final String severity;
  final String location;
  final String resourceType;
  final String status;
  final int etaMinutes;

  final int priorityScore;
  final double activationDistanceMeters;
  final DateTime createdAt;

  final bool dispatchCompleted;
  final bool contactCompleted;
  final bool escalationCompleted;
  final bool routingCompleted;
  final bool resolutionCompleted;

  const EmergencyRequest({
    required this.requestId,
    required this.vehicleId,
    required this.vehicleType,
    required this.emergencyCategory,
    required this.destination,
    required this.severity,
    required this.location,
    required this.resourceType,
    required this.status,
    required this.etaMinutes,
    required this.priorityScore,
    required this.activationDistanceMeters,
    required this.createdAt,
    this.dispatchCompleted = false,
    this.contactCompleted = false,
    this.escalationCompleted = false,
    this.routingCompleted = false,
    this.resolutionCompleted = false,
  });

  int get completedChecklistItems {
    int count = 0;

    if (dispatchCompleted) count++;
    if (contactCompleted) count++;
    if (escalationCompleted) count++;
    if (routingCompleted) count++;
    if (resolutionCompleted) count++;

    return count;
  }

  double get checklistProgress {
    return completedChecklistItems / 5;
  }

  bool get checklistCompleted {
    return completedChecklistItems == 5;
  }

  EmergencyRequest copyWith({
    String? requestId,
    String? vehicleId,
    String? vehicleType,
    String? emergencyCategory,
    String? destination,
    String? severity,
    String? location,
    String? resourceType,
    String? status,
    int? etaMinutes,
    int? priorityScore,
    double? activationDistanceMeters,
    DateTime? createdAt,
    bool? dispatchCompleted,
    bool? contactCompleted,
    bool? escalationCompleted,
    bool? routingCompleted,
    bool? resolutionCompleted,
  }) {
    return EmergencyRequest(
      requestId: requestId ?? this.requestId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleType: vehicleType ?? this.vehicleType,
      emergencyCategory:
          emergencyCategory ?? this.emergencyCategory,
      destination: destination ?? this.destination,
      severity: severity ?? this.severity,
      location: location ?? this.location,
      resourceType: resourceType ?? this.resourceType,
      status: status ?? this.status,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      priorityScore:
          priorityScore ?? this.priorityScore,
      activationDistanceMeters:
          activationDistanceMeters ??
              this.activationDistanceMeters,
      createdAt: createdAt ?? this.createdAt,
      dispatchCompleted:
          dispatchCompleted ?? this.dispatchCompleted,
      contactCompleted:
          contactCompleted ?? this.contactCompleted,
      escalationCompleted:
          escalationCompleted ?? this.escalationCompleted,
      routingCompleted:
          routingCompleted ?? this.routingCompleted,
      resolutionCompleted:
          resolutionCompleted ?? this.resolutionCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'vehicleId': vehicleId,
      'vehicleType': vehicleType,
      'emergencyCategory': emergencyCategory,
      'destination': destination,
      'severity': severity,
      'location': location,
      'resourceType': resourceType,
      'status': status,
      'etaMinutes': etaMinutes,
      'priorityScore': priorityScore,
      'activationDistanceMeters':
          activationDistanceMeters,
      'createdAt': createdAt.toIso8601String(),
      'dispatchCompleted': dispatchCompleted,
      'contactCompleted': contactCompleted,
      'escalationCompleted': escalationCompleted,
      'routingCompleted': routingCompleted,
      'resolutionCompleted': resolutionCompleted,
    };
  }

  factory EmergencyRequest.fromMap(
    Map<String, dynamic> map,
  ) {
    return EmergencyRequest(
      requestId: map['requestId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      emergencyCategory:
          map['emergencyCategory'] ?? '',
      destination: map['destination'] ?? '',
      severity: map['severity'] ?? 'Medium',
      location: map['location'] ?? '',
      resourceType:
          map['resourceType'] ?? 'Ambulance',
      status: map['status'] ?? 'pending',
      etaMinutes:
          (map['etaMinutes'] as num?)?.toInt() ?? 0,
      priorityScore:
          (map['priorityScore'] as num?)?.toInt() ?? 0,
      activationDistanceMeters:
          (map['activationDistanceMeters'] as num?)
                  ?.toDouble() ??
              500,
      createdAt: DateTime.tryParse(
            map['createdAt'] ?? '',
          ) ??
          DateTime.now(),
      dispatchCompleted:
          map['dispatchCompleted'] ?? false,
      contactCompleted:
          map['contactCompleted'] ?? false,
      escalationCompleted:
          map['escalationCompleted'] ?? false,
      routingCompleted:
          map['routingCompleted'] ?? false,
      resolutionCompleted:
          map['resolutionCompleted'] ?? false,
    );
  }
}