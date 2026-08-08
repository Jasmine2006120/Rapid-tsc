import 'package:flutter/material.dart';

import '../../models/vehicle/app_vehicle.dart';
import 'emergency_screen.dart';

class ResponseChecklistScreen extends StatefulWidget {
  final AppVehicle vehicle;

  const ResponseChecklistScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<ResponseChecklistScreen> createState() =>
      _ResponseChecklistScreenState();
}

class _ResponseChecklistScreenState
    extends State<ResponseChecklistScreen> {
  final Map<String, bool> _checklist = {
    'Emergency lights activated': false,
    'Siren activated': false,
    'Driver identity verified': false,
    'Vehicle ready for emergency response': false,
    'Destination confirmed': false,
    'Route reviewed': false,
    'Priority request prepared': false,
  };

  int get _completedCount {
    return _checklist.values
        .where((completed) => completed)
        .length;
  }

  bool get _allCompleted {
    return _completedCount == _checklist.length;
  }

  void _toggleItem(
    String item,
    bool? value,
  ) {
    setState(() {
      _checklist[item] = value ?? false;
    });
  }

  void _continueToEmergency() {
    if (!_allCompleted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EmergencyScreen(
            vehicle: widget.vehicle,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _checklist.length;
    final progress = _completedCount / totalItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Response Action Checklist',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.checklist,
                          size: 38,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Emergency Response Preparation',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Complete the required response actions before continuing to emergency mode.',
                    ),
                    const SizedBox(height: 18),
                    LinearProgressIndicator(
                      value: progress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_completedCount of $totalItems actions completed',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: _checklist.entries.map((entry) {
                  final item = entry.key;
                  final completed = entry.value;

                  return CheckboxListTile(
                    value: completed,
                    onChanged: (value) {
                      _toggleItem(
                        item,
                        value,
                      );
                    },
                    title: Text(
                      item,
                      style: TextStyle(
                        fontWeight: completed
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    secondary: Icon(
                      completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: completed
                          ? Colors.green
                          : Colors.grey,
                    ),
                    controlAffinity:
                        ListTileControlAffinity.trailing,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _infoRow(
                      'Vehicle ID',
                      widget.vehicle.vehicleId,
                    ),
                    _infoRow(
                      'Vehicle Type',
                      widget.vehicle.vehicleType,
                    ),
                    _infoRow(
                      'Driver',
                      widget.vehicle.driverName,
                    ),
                    _infoRow(
                      'Registration',
                      widget.vehicle.registrationNumber,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _allCompleted
                    ? _continueToEmergency
                    : null,
                icon: const Icon(
                  Icons.arrow_forward,
                ),
                label: Text(
                  _allCompleted
                      ? 'CONTINUE TO EMERGENCY MODE'
                      : 'COMPLETE ALL ACTIONS',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
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
}