import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/emergency_request.dart';

class PriorityResponseChecklistScreen
    extends StatefulWidget {
  final EmergencyRequest emergencyRequest;

  const PriorityResponseChecklistScreen({
    super.key,
    required this.emergencyRequest,
  });

  @override
  State<PriorityResponseChecklistScreen> createState() =>
      _PriorityResponseChecklistScreenState();
}

class _PriorityResponseChecklistScreenState
    extends State<PriorityResponseChecklistScreen> {
  late EmergencyRequest _request;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _request = widget.emergencyRequest;

    _loadSavedChecklist();
  }

  Future<void> _loadSavedChecklist() async {
    final preferences =
        await SharedPreferences.getInstance();

    final id = _request.requestId;

    setState(() {
      _request = _request.copyWith(
        dispatchCompleted:
            preferences.getBool('${id}_dispatch') ??
                _request.dispatchCompleted,
        contactCompleted:
            preferences.getBool('${id}_contact') ??
                _request.contactCompleted,
        escalationCompleted:
            preferences.getBool('${id}_escalation') ??
                _request.escalationCompleted,
        routingCompleted:
            preferences.getBool('${id}_routing') ??
                _request.routingCompleted,
        resolutionCompleted:
            preferences.getBool('${id}_resolution') ??
                _request.resolutionCompleted,
      );

      _loading = false;
    });
  }

  Future<void> _saveChecklist({
    bool? dispatch,
    bool? contact,
    bool? escalation,
    bool? routing,
    bool? resolution,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    final id = _request.requestId;

    if (dispatch != null) {
      await preferences.setBool(
        '${id}_dispatch',
        dispatch,
      );
    }

    if (contact != null) {
      await preferences.setBool(
        '${id}_contact',
        contact,
      );
    }

    if (escalation != null) {
      await preferences.setBool(
        '${id}_escalation',
        escalation,
      );
    }

    if (routing != null) {
      await preferences.setBool(
        '${id}_routing',
        routing,
      );
    }

    if (resolution != null) {
      await preferences.setBool(
        '${id}_resolution',
        resolution,
      );
    }
  }

  Future<void> _toggleDispatch(bool value) async {
    setState(() {
      _request = _request.copyWith(
        dispatchCompleted: value,
      );
    });

    await _saveChecklist(
      dispatch: value,
    );
  }

  Future<void> _toggleContact(bool value) async {
    setState(() {
      _request = _request.copyWith(
        contactCompleted: value,
      );
    });

    await _saveChecklist(
      contact: value,
    );
  }

  Future<void> _toggleEscalation(bool value) async {
    setState(() {
      _request = _request.copyWith(
        escalationCompleted: value,
      );
    });

    await _saveChecklist(
      escalation: value,
    );
  }

  Future<void> _toggleRouting(bool value) async {
    setState(() {
      _request = _request.copyWith(
        routingCompleted: value,
      );
    });

    await _saveChecklist(
      routing: value,
    );
  }

  Future<void> _toggleResolution(bool value) async {
    setState(() {
      _request = _request.copyWith(
        resolutionCompleted: value,
      );
    });

    await _saveChecklist(
      resolution: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Response Checklist',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildRequestHeader(),

            const SizedBox(height: 16),

            _buildProgressCard(),

            const SizedBox(height: 16),

            _buildChecklist(),

            const SizedBox(height: 16),

            _buildResponseStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: Colors.red.shade700,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Ambulance Priority Request',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _infoRow(
              'Request ID',
              _request.requestId,
            ),

            _infoRow(
              'Vehicle',
              _request.vehicleId,
            ),

            _infoRow(
              'Emergency',
              _request.emergencyCategory,
            ),

            _infoRow(
              'Destination',
              _request.destination,
            ),

            _infoRow(
              'Priority',
              '${_request.priorityScore}/100',
            ),

            _infoRow(
              'Status',
              _request.status.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final completed =
        _request.completedChecklistItems;

    final percentage =
        (_request.checklistProgress * 100).round();

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Response Progress',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _request.checklistProgress,
                minHeight: 12,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '$completed of 5 actions completed',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist() {
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Operator Action Checklist',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _checklistItem(
            title: 'Dispatch',
            description:
                'Ambulance dispatched and emergency response initiated.',
            icon: Icons.local_shipping,
            value: _request.dispatchCompleted,
            onChanged: _toggleDispatch,
          ),

          _checklistItem(
            title: 'Contact',
            description:
                'Driver and relevant emergency personnel contacted.',
            icon: Icons.phone,
            value: _request.contactCompleted,
            onChanged: _toggleContact,
          ),

          _checklistItem(
            title: 'Escalation',
            description:
                'Priority level reviewed and escalation completed.',
            icon: Icons.warning_amber,
            value: _request.escalationCompleted,
            onChanged: _toggleEscalation,
          ),

          _checklistItem(
            title: 'Routing',
            description:
                'Emergency route reviewed and traffic priority prepared.',
            icon: Icons.route,
            value: _request.routingCompleted,
            onChanged: _toggleRouting,
          ),

          _checklistItem(
            title: 'Resolution',
            description:
                'Emergency response completed and request resolved.',
            icon: Icons.task_alt,
            value: _request.resolutionCompleted,
            onChanged: _toggleResolution,
          ),
        ],
      ),
    );
  }

  Widget _checklistItem({
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: (checked) {
        onChanged(checked ?? false);
      },
      secondary: Container(
        padding:
            const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value
              ? Colors.green.shade50
              : Colors.grey.shade100,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: value
              ? Colors.green
              : Colors.grey.shade700,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: value
              ? Colors.green.shade700
              : null,
        ),
      ),
      subtitle: Text(description),
      controlAffinity:
          ListTileControlAffinity.trailing,
    );
  }

  Widget _buildResponseStatus() {
    final completed =
        _request.checklistCompleted;

    return Card(
      color: completed
          ? Colors.green.shade50
          : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              completed
                  ? Icons.check_circle
                  : Icons.pending_actions,
              color: completed
                  ? Colors.green
                  : Colors.orange.shade800,
              size: 30,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                completed
                    ? 'All response actions completed.'
                    : 'Response is currently in progress.',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
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
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}