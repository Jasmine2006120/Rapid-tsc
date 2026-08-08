class TrafficSignalModel {
  final String id;
  final double latitude;
  final double longitude;
  final String? name;
  final bool isActive;
  final double? distanceFromRoute;
  final double? distanceFromVehicle;

  const TrafficSignalModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.name,
    this.isActive = true,
    this.distanceFromRoute,
    this.distanceFromVehicle,
  });

  TrafficSignalModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? name,
    bool? isActive,
    double? distanceFromRoute,
    double? distanceFromVehicle,
  }) {
    return TrafficSignalModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      distanceFromRoute: distanceFromRoute ?? this.distanceFromRoute,
      distanceFromVehicle: distanceFromVehicle ?? this.distanceFromVehicle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'isActive': isActive,
      'distanceFromRoute': distanceFromRoute,
      'distanceFromVehicle': distanceFromVehicle,
    };
  }

  factory TrafficSignalModel.fromMap(Map<String, dynamic> map) {
    return TrafficSignalModel(
      id: map['id']?.toString() ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      name: map['name']?.toString(),
      isActive: map['isActive'] ?? true,
      distanceFromRoute:
          map['distanceFromRoute'] == null
              ? null
              : (map['distanceFromRoute']).toDouble(),
      distanceFromVehicle:
          map['distanceFromVehicle'] == null
              ? null
              : (map['distanceFromVehicle']).toDouble(),
    );
  }
}