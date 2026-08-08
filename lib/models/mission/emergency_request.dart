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
    required this.priorityScore,
    required this.activationDistanceMeters,
    required this.status,
    required this.createdAt,
    this.dispatchCompleted = false,
    this.contactCompleted = false,
    this.escalationCompleted = false,
    this.routingCompleted = false,
    this.resolutionCompleted = false,
  });

  int get completedChecklistItems {
    int count = 0;

    if (dispatchCompleted) {
      count++;
    }

    if (contactCompleted) {
      count++;
    }

    if (escalationCompleted) {
      count++;
    }

    if (routingCompleted) {
      count++;
    }

    if (resolutionCompleted) {
      count++;
    }

    return count;
  }

  bool get checklistCompleted {
    return completedChecklistItems == 5;
  }

  double get checklistProgress {
    return completedChecklistItems / 5;
  }

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
      priorityScore:
          (map['priorityScore'] as num?)?.toInt() ?? 0,
      activationDistanceMeters:
          (map['activationDistanceMeters'] as num?)
                  ?.toDouble() ??
              500,
      status: map['status'] ?? 'pending',
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
      priorityScore:
          priorityScore ?? this.priorityScore,
      activationDistanceMeters:
          activationDistanceMeters ??
              this.activationDistanceMeters,
      status: status ?? this.status,
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
}