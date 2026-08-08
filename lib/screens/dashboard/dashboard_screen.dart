import 'package:flutter/material.dart';

import '../../models/vehicle/app_vehicle.dart';
import '../mission/emergency_screen.dart';
import '../map/live_map_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AppVehicle vehicle;

  const DashboardScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Vehicle Dashboard'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.local_hospital,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Emergency Vehicle Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'GreenWave AI Emergency Traffic Priority System',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _infoRow(
                    'Vehicle ID',
                    vehicle.vehicleId,
                  ),
                  _infoRow(
                    'Vehicle Type',
                    vehicle.vehicleType,
                  ),
                  _infoRow(
                    'Driver',
                    vehicle.driverName,
                  ),
                  _infoRow(
                    'Registration',
                    vehicle.registrationNumber,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _statusRow(
                    icon: Icons.gps_fixed,
                    title: 'GPS',
                    status: 'Ready',
                    statusColor: Colors.green,
                  ),
                  _statusRow(
                    icon: Icons.alt_route,
                    title: 'Route Engine',
                    status: 'Ready',
                    statusColor: Colors.green,
                  ),
                  _statusRow(
                    icon: Icons.traffic,
                    title: 'Traffic Signals',
                    status: 'Ready',
                    statusColor: Colors.green,
                  ),
                  _statusRow(
                    icon: Icons.cloud_done,
                    title: 'Firebase',
                    status: 'Connected',
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 58,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmergencyScreen(
                      vehicle: vehicle,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.emergency),
              label: const Text(
                'ACTIVATE EMERGENCY MODE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 58,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveMapScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text(
                'VIEW LIVE MAP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}