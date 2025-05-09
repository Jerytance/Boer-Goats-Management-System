import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:welcome/database_helper.dart';

class ViewSickGoatsScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  ViewSickGoatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sick Goats Records',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add refresh functionality
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[100]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.medical_services, size: 50, color: Colors.red),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _databaseHelper.getSickGoats(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red[700]),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.health_and_safety,
                                color: Colors.green,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No Sick Goats Found',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'All goats are healthy!',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    final sickGoats = snapshot.data!;
                    return Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListView.builder(
                        itemCount: sickGoats.length,
                        itemBuilder: (context, index) {
                          final goat = sickGoats[index];
                          // Format the date here
                          String formattedDate = 'Unknown';
                          if (goat['dateOfBirth'] != null) {
                            try {
                              final date = DateTime.parse(goat['dateOfBirth']);
                              formattedDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(date);
                            } catch (e) {
                              formattedDate = 'Invalid date';
                            }
                          }
                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  index % 2 == 0
                                      ? Colors.red[50]
                                      : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.sick,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Tag: ${goat['goatTag']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.category,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('Type: ${goat['goatType']}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.agriculture,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('Breed: ${goat['breed']}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.monitor_weight,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('Weight: ${goat['weight']} kg'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'DOB: $formattedDate',
                                      ), // Use formatted date
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.medical_information,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Add medical details functionality
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
