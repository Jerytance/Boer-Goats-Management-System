import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:welcome/database_helper.dart';

class GoatAlertsScreen extends StatefulWidget {
  const GoatAlertsScreen({super.key});

  @override
  State<GoatAlertsScreen> createState() => _GoatAlertsScreenState();
}

class _GoatAlertsScreenState extends State<GoatAlertsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _healthAlerts = [];
  List<Map<String, dynamic>> _saleReadyGoats = [];
  List<Map<String, dynamic>> _breedingAgeGoats = [];
  Map<String, List<Map<String, dynamic>>> _monthlyGoatData = {};
  List<Map<String, String>> _weeklyTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadHealthAlerts(),
      _loadSaleReadyGoats(),
      _loadBreedingAgeGoats(),
      _loadMonthlyGoatData(),
      _generateWeeklyTasks(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _loadHealthAlerts() async {
    final allGoats = await _dbHelper.getGoats();
    _healthAlerts =
        allGoats.where((goat) {
          if (goat['goatType'] == 'Kid') {
            final weight = double.tryParse(goat['weight'] ?? '0') ?? 0;
            return weight > 50;
          }
          return false;
        }).toList();
  }

  Future<void> _loadSaleReadyGoats() async {
    final allGoats = await _dbHelper.getGoats();
    _saleReadyGoats =
        allGoats.where((goat) {
          final weight = double.tryParse(goat['weight'] ?? '0') ?? 0;
          return weight > 100;
        }).toList();
  }

  Future<void> _loadBreedingAgeGoats() async {
    final allGoats = await _dbHelper.getGoats();
    _breedingAgeGoats =
        allGoats.where((goat) {
          final dob = goat['dateOfBirth'];
          if (dob != null) {
            final birthDate = DateTime.tryParse(dob);
            if (birthDate != null) {
              final age = DateTime.now().difference(birthDate).inDays ~/ 365;
              return age > 3;
            }
          }
          return false;
        }).toList();
  }

  Future<void> _loadMonthlyGoatData() async {
    final allGoats = await _dbHelper.getGoats();
    final monthlyData = <String, List<Map<String, dynamic>>>{};

    for (var goat in allGoats) {
      final dob = goat['dateOfBirth'];
      if (dob != null) {
        final birthDate = DateTime.tryParse(dob);
        if (birthDate != null) {
          final monthYear = DateFormat('MMMM yyyy').format(birthDate);
          if (!monthlyData.containsKey(monthYear)) {
            monthlyData[monthYear] = [];
          }
          monthlyData[monthYear]!.add(goat);
        }
      }
    }

    setState(() => _monthlyGoatData = monthlyData);
  }

  Future<void> _generateWeeklyTasks() async {
    final tasks = <Map<String, String>>[
      {
        'day': 'Monday',
        'task': 'Administer vitamins to pregnant does',
        'details':
            'Provide balanced vitamins (A, D, E, B-complex) to support fetal development. Ensure fresh water is available.',
      },
      {
        'day': 'Tuesday',
        'task': 'Clean and disinfect all feeding troughs',
        'details':
            'Remove leftover feed, scrub with mild detergent, rinse thoroughly, and disinfect with goat-safe solution.',
      },
      {
        'day': 'Wednesday',
        'task': 'Weigh all kids and record growth',
        'details':
            'Use livestock scale or weigh tape. Track weight gain to assess health and adjust feeding if needed.',
      },
      {
        'day': 'Thursday',
        'task': 'Check and trim hooves of adult goats',
        'details':
            'Inspect for overgrowth or rot. Use clean hoof trimmers and apply conditioner if needed.',
      },
      {
        'day': 'Friday',
        'task': 'Administer dewormer to all goats',
        'details':
            'Rotate dewormer types to prevent resistance. Dose according to weight for effectiveness.',
      },
      {
        'day': 'Saturday',
        'task': 'Clean barn and replace bedding',
        'details':
            'Remove soiled bedding, disinfect surfaces, and spread fresh, dry bedding material.',
      },
      {
        'day': 'Sunday',
        'task': 'General health check for all goats',
        'details':
            'Examine eyes, nose, coat, and monitor appetite/behavior for early illness detection.',
      },
    ];

    final sickGoats = await _dbHelper.getSickGoats();
    if (sickGoats.isNotEmpty) {
      tasks.add({
        'day': 'Daily',
        'task': 'Administer medication to ${sickGoats.length} sick goats',
        'details':
            'Follow veterinary instructions carefully. Isolate sick goats if necessary.',
      });
    }

    setState(() => _weeklyTasks = tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goat Management Alerts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health Alerts Section
                    if (_healthAlerts.isNotEmpty)
                      _buildAlertSection(
                        title: 'Health Alerts',
                        subtitle: 'Kids with excessive weight (over 50kg)',
                        goats: _healthAlerts,
                        icon: Icons.health_and_safety,
                        color: Colors.red,
                      ),

                    // Sale Ready Goats
                    if (_saleReadyGoats.isNotEmpty)
                      _buildAlertSection(
                        title: 'Sale Recommendations',
                        subtitle: 'Goats ready for sale (over 100kg)',
                        goats: _saleReadyGoats,
                        icon: Icons.attach_money,
                        color: Colors.orange,
                      ),

                    // Breeding Age Alerts
                    if (_breedingAgeGoats.isNotEmpty)
                      _buildAlertSection(
                        title: 'Breeding Age Alerts',
                        subtitle:
                            'Boers over five years old are available for sale and are not suitable for breeding',
                        goats: _breedingAgeGoats,
                        icon: Icons.warning,
                        color: Colors.blue,
                      ),

                    // Monthly Goat Data
                    _buildMonthlyGoatSection(),

                    // Weekly Tasks
                    _buildWeeklyTasksSection(),

                    // Refresh Button
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh All Data'),
                        onPressed: _loadAllData,
                      ),
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text('BACK'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildAlertSection({
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> goats,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        '$subtitle (${goats.length} found)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...goats.map((goat) => _buildGoatInfoCard(goat, color)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoatInfoCard(Map<String, dynamic> goat, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            goat['goatType'] == 'Doe'
                ? Icons.female
                : goat['goatType'] == 'Buck'
                ? Icons.male
                : Icons.child_care,
            color: color,
          ),
        ),
        title: Text(
          '${goat['goatTag']} (${goat['goatType']})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (goat['breed'] != null) Text('Breed: ${goat['breed']}'),
            if (goat['weight'] != null) Text('Weight: ${goat['weight']} kg'),
            if (goat['dateOfBirth'] != null)
              Text('Age: ${_calculateAge(goat['dateOfBirth'])}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showGoatDetails(goat),
        ),
      ),
    );
  }

  Widget _buildMonthlyGoatSection() {
    if (_monthlyGoatData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No monthly goat data available'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Monthly Goat Distribution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._monthlyGoatData.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  '${entry.key} (${entry.value.length} goats)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children:
                    entry.value
                        .map((goat) => _buildGoatInfoCard(goat, Colors.purple))
                        .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTasksSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.task, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Weekly Management Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._weeklyTasks.map((task) {
              return ExpansionTile(
                title: Text(
                  '${task['day']}: ${task['task']}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      task['details']!,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String _calculateAge(String dob) {
    final birthDate = DateTime.tryParse(dob);
    if (birthDate != null) {
      final now = DateTime.now();
      final years = now.difference(birthDate).inDays ~/ 365;
      final months = (now.difference(birthDate).inDays % 365) ~/ 30;
      return '$years years, $months months';
    }
    return 'Age unknown';
  }

  void _showGoatDetails(Map<String, dynamic> goat) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Goat Details - ${goat['goatTag']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Type', goat['goatType']),
                  _buildDetailRow('Breed', goat['breed'] ?? 'Unknown'),
                  _buildDetailRow(
                    'Weight',
                    '${goat['weight'] ?? 'Unknown'} kg',
                  ),
                  if (goat['dateOfBirth'] != null)
                    _buildDetailRow('Age', _calculateAge(goat['dateOfBirth'])),
                  const SizedBox(height: 16),
                  if (goat['goatType'] == 'Kid' &&
                      (double.tryParse(goat['weight'] ?? '0') ?? 0) > 50)
                    const Text(
                      '⚠️ Health Alert: This kid is overweight!',
                      style: TextStyle(color: Colors.red),
                    ),
                  if ((double.tryParse(goat['weight'] ?? '0') ?? 0) > 100)
                    const Text(
                      '💰 Ready for sale!',
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
