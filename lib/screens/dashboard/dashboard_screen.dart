import 'package:flutter/material.dart';

import '../../data/sample_emergency_request.dart';
import '../../models/vehicle/app_vehicle.dart';
import '../mission/emergency_screen.dart';
import '../mission/priority_request_filter_screen.dart';
import '../mission/priority_response_checklist_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AppVehicle vehicle;

  const DashboardScreen({
    super.key,
    required this.vehicle,
  });

  void _openEmergencyMode(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EmergencyScreen(
            vehicle: vehicle,
          );
        },
      ),
    );
  }

  void _openResponseChecklist(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PriorityResponseChecklistScreen(
            emergencyRequest:
                sampleEmergencyRequest,
          );
        },
      ),
    );
  }

  void _openPriorityRequests(
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PriorityRequestFilterScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GreenWave AI',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeaderCard(),

            const SizedBox(height: 20),

            _buildVehicleCard(),

            const SizedBox(height: 20),

            _buildEmergencyButton(context),

            const SizedBox(height: 12),

            _buildPriorityRequestsButton(
              context,
            ),

            const SizedBox(height: 12),

            _buildChecklistButton(context),

            const SizedBox(height: 20),

            _buildSystemStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.traffic,
                    size: 40,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'GreenWave AI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Emergency Traffic Priority System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage emergency vehicles, priority requests, routing and response actions.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 26,
                ),
                SizedBox(width: 10),
                Text(
                  'Vehicle Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _vehicleRow(
              Icons.badge,
              'Vehicle ID',
              vehicle.vehicleId,
            ),

            _vehicleRow(
              Icons.emergency,
              'Vehicle Type',
              vehicle.vehicleType,
            ),

            _vehicleRow(
              Icons.person,
              'Driver',
              vehicle.driverName,
            ),

            _vehicleRow(
              Icons.confirmation_number,
              'Registration',
              vehicle.registrationNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  Widget _buildEmergencyButton(
    BuildContext context,
  ) {
    return SizedBox(
      height: 58,
      child: FilledButton.icon(
        onPressed: () {
          _openEmergencyMode(context);
        },
        icon: const Icon(
          Icons.emergency,
        ),
        label: const Text(
          'ACTIVATE EMERGENCY MODE',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityRequestsButton(
    BuildContext context,
  ) {
    return SizedBox(
      height: 58,
      child: OutlinedButton.icon(
        onPressed: () {
          _openPriorityRequests(context);
        },
        icon: const Icon(
          Icons.filter_list,
        ),
        label: const Text(
          'ACTIVE PRIORITY REQUESTS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistButton(
    BuildContext context,
  ) {
    return SizedBox(
      height: 58,
      child: OutlinedButton.icon(
        onPressed: () {
          _openResponseChecklist(context);
        },
        icon: const Icon(
          Icons.checklist,
        ),
        label: const Text(
          'VIEW RESPONSE CHECKLIST',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text(
                  'System Status',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _statusRow(
              'Traffic Priority',
              'Ready',
            ),

            _statusRow(
              'Emergency Routing',
              'Ready',
            ),

            _statusRow(
              'Priority Requests',
              'Active',
            ),

            _statusRow(
              'Response Checklist',
              'Available',
            ),

            _statusRow(
              'Vehicle',
              'Connected',
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(
    String label,
    String status,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(label),
          ),
          Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}