import 'package:flutter/material.dart';

import '../../models/mission/emergency_request.dart';
import '../../models/vehicle/app_vehicle.dart';
import '../../services/mission/emergency_service.dart';
import '../signal/signal_status_screen.dart';

class EmergencyScreen extends StatefulWidget {
  final AppVehicle vehicle;

  const EmergencyScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final EmergencyService emergencyService = EmergencyService();

  EmergencyRequest? emergencyRequest;

  String emergencyCategory = 'Critical Patient Transport';
  String destination = 'City Hospital';

  bool requestSent = false;
  bool priorityGranted = false;
  bool loading = false;

  Future<void> sendPriorityRequest() async {
    setState(() {
      loading = true;
    });

    final request = emergencyService.createEmergencyRequest(
      vehicle: widget.vehicle,
      emergencyCategory: emergencyCategory,
      destination: destination,
    );

    setState(() {
      requestSent = true;
      priorityGranted = false;
      emergencyRequest = request;
    });

    final verifiedRequest =
        await emergencyService.verifyRequest(request);

    if (!mounted) return;

    setState(() {
      loading = false;
      priorityGranted = true;
      emergencyRequest = verifiedRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
    String status =
        'Emergency mode is active. Select category and destination.';

    if (requestSent && !priorityGranted) {
      status =
          'Request sent. Verifying vehicle, route, and priority...';
    }

    if (priorityGranted) {
      status =
          'Priority granted. Upcoming traffic signals can be processed.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Mode'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.crisis_alert,
                    color: Colors.red,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Live Emergency Request',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(status),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: emergencyCategory,
            decoration: const InputDecoration(
              labelText: 'Emergency Category',
              prefixIcon: Icon(Icons.emergency_outlined),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Critical Patient Transport',
                child: Text('Critical Patient Transport'),
              ),
              DropdownMenuItem(
                value: 'Fire Response',
                child: Text('Fire Response'),
              ),
              DropdownMenuItem(
                value: 'Police Emergency',
                child: Text('Police Emergency'),
              ),
              DropdownMenuItem(
                value: 'Disaster Response',
                child: Text('Disaster Response'),
              ),
              DropdownMenuItem(
                value: 'Organ/Blood Transport',
                child: Text('Organ/Blood Transport'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                emergencyCategory = value;
              });
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: destination,
            decoration: const InputDecoration(
              labelText: 'Destination',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: const [
              DropdownMenuItem(
                value: 'City Hospital',
                child: Text('City Hospital'),
              ),
              DropdownMenuItem(
                value: 'Emergency Care Centre',
                child: Text('Emergency Care Centre'),
              ),
              DropdownMenuItem(
                value: 'Government Hospital',
                child: Text('Government Hospital'),
              ),
              DropdownMenuItem(
                value: 'Fire Incident Site',
                child: Text('Fire Incident Site'),
              ),
              DropdownMenuItem(
                value: 'Police Response Location',
                child: Text('Police Response Location'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                destination = value;
              });
            },
          ),

          const SizedBox(height: 18),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  _infoRow(
                    'Vehicle ID',
                    widget.vehicle.vehicleId,
                  ),
                  _infoRow(
                    'Vehicle Type',
                    widget.vehicle.vehicleType,
                  ),
                  _infoRow(
                    'Emergency Category',
                    emergencyCategory,
                  ),
                  _infoRow(
                    'Destination',
                    destination,
                  ),
                  _infoRow(
                    'Priority Score',
                    emergencyRequest == null
                        ? 'Not calculated'
                        : '${emergencyRequest!.priorityScore}',
                  ),
                  _infoRow(
                    'Activation Zone',
                    emergencyRequest == null
                        ? '500 m default'
                        : '${emergencyRequest!.activationDistanceMeters} m',
                  ),
                  _infoRow(
                    'Status',
                    emergencyRequest?.status ?? 'Not submitted',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          if (!requestSent)
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: loading ? null : sendPriorityRequest,
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  loading
                      ? 'VERIFYING REQUEST...'
                      : 'SEND PRIORITY REQUEST',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (requestSent)
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: priorityGranted
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignalStatusScreen(
              vehicle: widget.vehicle,
              emergencyCategory: emergencyCategory,
              destination: destination,
              priorityGranted: priorityGranted,
              emergencyRequest: emergencyRequest,
            ),
          ),
        );
      }
    : null,
                icon: const Icon(Icons.traffic),
                label: const Text(
                  'VIEW SIGNAL STATUS',
                ),
              ),
            ),

          const SizedBox(height: 12),
          

          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel Emergency'),
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
}