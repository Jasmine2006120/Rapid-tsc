class AppVehicle {
  final String vehicleId;
  final String vehicleType;
  final String driverName;
  final String registrationNumber;

  const AppVehicle({
    required this.vehicleId,
    required this.vehicleType,
    required this.driverName,
    required this.registrationNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'vehicleType': vehicleType,
      'driverName': driverName,
      'registrationNumber': registrationNumber,
    };
  }

  factory AppVehicle.fromMap(Map<String, dynamic> map) {
    return AppVehicle(
      vehicleId: map['vehicleId'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      driverName: map['driverName'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
    );
  }
}