import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure this import is present
import 'package:welcome/database_helper.dart';

class ViewGoatsScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  ViewGoatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Boers', // Changed title to reflect the table name
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.tealAccent, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.list_alt, size: 50, color: Colors.teal),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future:
                    _databaseHelper
                        .getGoats(), // Using the getGoats method which queries the 'Boers' table
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error,
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.blue,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No Boers found', // Updated message
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text(
                                  'Add Boer',
                                ), // Updated button text
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  // Add navigation to add boer screen if needed
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    final boers = snapshot.data!; // Renamed variable to 'boers'
                    return Card(
                      margin: const EdgeInsets.all(16.0),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: ListView.builder(
                          itemCount: boers.length,
                          itemBuilder: (context, index) {
                            final boer =
                                boers[index]; // Renamed variable to 'boer'
                            // Format the date here
                            String formattedDate = 'N/A';
                            if (boer['dateOfBirth'] != null) {
                              DateTime dob = DateTime.parse(
                                boer['dateOfBirth'],
                              );
                              formattedDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(dob);
                            }
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      index < boers.length - 1
                                          ? const BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          )
                                          : BorderSide.none,
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.pets,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  'Tag: ${boer['goatTag']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
                                        Text('Type: ${boer['goatType']}'),
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
                                        Text('Breed: ${boer['breed']}'),
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
                                        Text('Weight: ${boer['weight']} kg'),
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
                                    Icons.visibility,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () {
                                    // Add view details functionality for the specific Boer
                                    // You might want to navigate to a new screen or show a dialog
                                    // to display more details about the selected Boer.
                                    print(
                                      'View details for ${boer['goatTag']}',
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
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
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
