import 'package:flutter/material.dart';

import '../../data/sample_priority_requests.dart';
import '../../models/emergency_request.dart';
import '../../screens/mission/priority_response_checklist_screen.dart';

class PriorityRequestFilterScreen
    extends StatefulWidget {
  const PriorityRequestFilterScreen({
    super.key,
  });

  @override
  State<PriorityRequestFilterScreen> createState() =>
      _PriorityRequestFilterScreenState();
}

class _PriorityRequestFilterScreenState
    extends State<PriorityRequestFilterScreen> {
  String _severity = 'All';
  String _location = 'All';
  String _resourceType = 'All';
  String _status = 'All';
  String _eta = 'All';

  List<EmergencyRequest> get _filteredRequests {
    final filtered =
        samplePriorityRequests.where((request) {
      final severityMatch =
          _severity == 'All' ||
              request.severity == _severity;

      final locationMatch =
          _location == 'All' ||
              request.location == _location;

      final resourceMatch =
          _resourceType == 'All' ||
              request.resourceType == _resourceType;

      final statusMatch =
          _status == 'All' ||
              request.status == _status;

      final etaMatch =
          _matchesEta(request);

      return severityMatch &&
          locationMatch &&
          resourceMatch &&
          statusMatch &&
          etaMatch;
    }).toList();

    filtered.sort(
      (a, b) => b.priorityScore.compareTo(
        a.priorityScore,
      ),
    );

    return filtered;
  }

  bool _matchesEta(
    EmergencyRequest request,
  ) {
    switch (_eta) {
      case '0-5 min':
        return request.etaMinutes <= 5;

      case '6-10 min':
        return request.etaMinutes >= 6 &&
            request.etaMinutes <= 10;

      case '11-15 min':
        return request.etaMinutes >= 11 &&
            request.etaMinutes <= 15;

      case '16+ min':
        return request.etaMinutes >= 16;

      default:
        return true;
    }
  }

  List<String> get _locations {
    final locations = samplePriorityRequests
        .map((request) => request.location)
        .toSet()
        .toList();

    locations.sort();

    return [
      'All',
      ...locations,
    ];
  }

  void _clearFilters() {
    setState(() {
      _severity = 'All';
      _location = 'All';
      _resourceType = 'All';
      _status = 'All';
      _eta = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filteredRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Active Priority Requests',
        ),
        actions: [
          IconButton(
            tooltip: 'Clear filters',
            onPressed: _clearFilters,
            icon: const Icon(
              Icons.filter_alt_off,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterPanel(),

            Expanded(
              child: requests.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.all(16),
                      itemCount: requests.length,
                      itemBuilder:
                          (context, index) {
                        return _buildRequestCard(
                          requests[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Card(
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.filter_alt,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Filter Requests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${_filteredRequests.length} found',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _filterDropdown(
                  label: 'Severity',
                  value: _severity,
                  values: const [
                    'All',
                    'Critical',
                    'High',
                    'Medium',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _severity = value;
                    });
                  },
                ),

                _filterDropdown(
                  label: 'Location',
                  value: _location,
                  values: _locations,
                  onChanged: (value) {
                    setState(() {
                      _location = value;
                    });
                  },
                ),

                _filterDropdown(
                  label: 'Resource',
                  value: _resourceType,
                  values: const [
                    'All',
                    'Ambulance',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _resourceType = value;
                    });
                  },
                ),

                _filterDropdown(
                  label: 'Status',
                  value: _status,
                  values: const [
                    'All',
                    'Pending',
                    'Active',
                    'Dispatched',
                    'Escalated',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),

                _filterDropdown(
                  label: 'ETA',
                  value: _eta,
                  values: const [
                    'All',
                    '0-5 min',
                    '6-10 min',
                    '11-15 min',
                    '16+ min',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _eta = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> values,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        items: values.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow:
                  TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildRequestCard(
    EmergencyRequest request,
  ) {
    final severityColor =
        _severityColor(request.severity);

    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PriorityResponseChecklistScreen(
                  emergencyRequest: request,
                );
              },
            ),
          );
        },
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(
                      color: severityColor
                          .withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Icon(
                      Icons.local_hospital,
                      color: severityColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          request.requestId,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          request
                              .emergencyCategory,
                        ),
                      ],
                    ),
                  ),

                  _severityBadge(
                    request.severity,
                    severityColor,
                  ),
                ],
              ),

              const Divider(
                height: 24,
              ),

              _requestInfoRow(
                Icons.location_on,
                'Location',
                request.location,
              ),

              _requestInfoRow(
                Icons.local_shipping,
                'Resource',
                request.resourceType,
              ),

              _requestInfoRow(
                Icons.timer,
                'ETA',
                '${request.etaMinutes} min',
              ),

              _requestInfoRow(
                Icons.info_outline,
                'Status',
                request.status,
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Priority Score: '
                      '${request.priorityScore}/100',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w600,
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

  Widget _severityBadge(
    String severity,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color:
            color.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _severityColor(
    String severity,
  ) {
    switch (severity) {
      case 'Critical':
        return Colors.red.shade700;
      case 'High':
        return Colors.orange.shade800;
      case 'Medium':
        return Colors.amber.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            const Text(
              'No matching priority requests',
              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing or clearing '
              'the filters.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(
                Icons.filter_alt_off,
              ),
              label: const Text(
                'Clear Filters',
              ),
            ),
          ],
        ),
      ),
    );
  }
}