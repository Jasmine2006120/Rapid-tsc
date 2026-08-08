import 'package:flutter/material.dart';

import '../../models/mission/emergency_request.dart';
import '../../models/vehicle/app_vehicle.dart';

class SignalStatusScreen extends StatelessWidget {
  final AppVehicle vehicle;
  final String emergencyCategory;
  final String destination;
  final bool priorityGranted;
  final EmergencyRequest? emergencyRequest;

  const SignalStatusScreen({
    super.key,
    required this.vehicle,
    required this.emergencyCategory,
    required this.destination,
    required this.priorityGranted,
    required this.emergencyRequest,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = priorityGranted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signal Status'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: active
                ? Colors.green.shade50
                : Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    active
                        ? Icons.traffic
                        : Icons.hourglass_top,
                    size: 46,
                    color: active
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    active
                        ? 'Priority Corridor Active'
                        : 'Priority Processing',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    active
                        ? 'Traffic signals on the relevant route can now be processed for emergency priority.'
                        : 'The emergency request is currently being processed.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

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
                    'Emergency',
                    emergencyCategory,
                  ),
                  _infoRow(
                    'Destination',
                    destination,
                  ),
                  _infoRow(
                    'Priority Score',
                    emergencyRequest == null
                        ? 'Not available'
                        : '${emergencyRequest!.priorityScore}',
                  ),
                  _infoRow(
                    'Activation Distance',
                    emergencyRequest == null
                        ? '500 m'
                        : '${emergencyRequest!.activationDistanceMeters} m',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Route Signal Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _signalCard(
            signalNumber: 1,
            status: active
                ? 'Priority Ready'
                : 'Waiting',
            icon: active
                ? Icons.check_circle
                : Icons.hourglass_empty,
          ),

          _signalCard(
            signalNumber: 2,
            status: active
                ? 'Priority Ready'
                : 'Waiting',
            icon: active
                ? Icons.check_circle
                : Icons.hourglass_empty,
          ),

          _signalCard(
            signalNumber: 3,
            status: active
                ? 'Priority Ready'
                : 'Waiting',
            icon: active
                ? Icons.check_circle
                : Icons.hourglass_empty,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('BACK TO EMERGENCY'),
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
      padding: const EdgeInsets.only(bottom: 12),
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

  Widget _signalCard({
    required int signalNumber,
    required String status,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.traffic),
        title: Text(
          'Traffic Signal $signalNumber',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(status),
        trailing: Icon(icon),
      ),
    );
  }
}