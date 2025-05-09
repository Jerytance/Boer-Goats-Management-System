import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:welcome/save_breeding.dart';

void main() {
  runApp(const MaterialApp(home: Breeding()));
}

// Helper method to parse short breeding info
String _parseShortBreedingInfo(String breedingType) {
  // Extract a concise summary from the breedingType string
  return breedingType
      .split('\n')
      .firstWhere(
        (line) => line.trim().isNotEmpty,
        orElse: () => 'No summary available',
      );
}

class BreedingDetailsDialog extends StatelessWidget {
  final String breedingType;
  final String doeId;
  final String buckId;

  const BreedingDetailsDialog({
    super.key,
    required this.breedingType,
    required this.doeId,
    required this.buckId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Breeding Details',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Genetics & Meat Quality'),
            _buildInfoTable(breedingType),
            const SizedBox(height: 25),
            _buildSectionTitle('Common Diseases'),
            _buildDiseasesTable(breedingType),
            const SizedBox(height: 25),
            _buildSectionTitle('Recommended Vaccines'),
            _buildVaccinesTable(breedingType),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.save, color: Colors.green),
          label: const Text('Save', style: TextStyle(color: Colors.green)),
          onPressed: () async {
            Navigator.pop(context); // Close the dialog first
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SaveBreeding(
                      doeId: doeId,
                      buckId: buckId,
                      breedingInfo: _parseShortBreedingInfo(breedingType),
                    ),
              ),
            );
            // Show success message when returning from SaveBreeding
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Breeding information saved successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  // Helper method to build the vaccines table
  Widget _buildVaccinesTable(String breedingType) {
    return Table(
      border: TableBorder.all(color: Colors.green),
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Vaccine',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Dosage',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...breedingType.split('\n').where((line) => line.contains(':')).map((
          line,
        ) {
          final parts = line.split(':');
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(parts[0].trim()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(parts[1].trim()),
              ),
            ],
          );
        }),
      ],
    );
  }

  // Helper method to build the diseases table
  Widget _buildDiseasesTable(String breedingType) {
    return Table(
      border: TableBorder.all(color: Colors.green),
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Disease',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...breedingType.split('\n').where((line) => line.contains(':')).map((
          line,
        ) {
          final parts = line.split(':');
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(parts[0].trim()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(parts[1].trim()),
              ),
            ],
          );
        }),
      ],
    );
  }

  // Helper method to build the info table
  Widget _buildInfoTable(String breedingType) {
    return Table(
      border: TableBorder.all(color: Colors.green),
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Attribute',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...breedingType.split('\n').map((line) {
          final parts = line.split(':');
          if (parts.length == 2) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(parts[0].trim()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(parts[1].trim()),
                ),
              ],
            );
          } else {
            return const TableRow(
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: Text('')),
                Padding(padding: EdgeInsets.all(8.0), child: Text('')),
              ],
            );
          }
        }),
      ],
    );
  }
}

class Breeding extends StatelessWidget {
  const Breeding({super.key});

  @override
  Widget build(BuildContext context) {
    final doeIdController = TextEditingController();
    final buckIdController = TextEditingController();
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Goat Breeding',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.transparent, size: 0),
            tooltip: 'View Saved Breeding Records',
            onPressed: () async {
              final records = await dbHelper.getBreedingRecords();
              if (records.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No saved breeding records found'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SavedBreedingRecordsScreen(records: records),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: doeIdController,
              decoration: const InputDecoration(
                labelText: 'Doe ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: buckIdController,
              decoration: const InputDecoration(
                labelText: 'Buck ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final doeId = doeIdController.text.trim();
                final buckId = buckIdController.text.trim();

                if (doeId.isEmpty || buckId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both Doe and Buck IDs'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Get the breeds of the doe and buck
                final doe = await dbHelper.getGoatByTag(doeId);
                final buck = await dbHelper.getGoatByTag(buckId);

                if (doe == null || buck == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('One or both goats not found'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final doeBreed = doe['breed'] as String;
                final buckBreed = buck['breed'] as String;
                final breedingType = getBreedingType(doeBreed, buckBreed);

                showDialog(
                  context: context,
                  builder:
                      (context) => BreedingDetailsDialog(
                        breedingType: breedingType,
                        doeId: doeId,
                        buckId: buckId,
                      ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Get Breeding Info',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedBreedingRecordsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  const SavedBreedingRecordsScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Breeding Records'),
        backgroundColor: Colors.green[800],
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Doe: ${record['doeId']} × Buck: ${record['buckId']}',
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${record['date']}'),
                  if (record['notes'] != null && record['notes'].isNotEmpty)
                    Text('Notes: ${record['notes']}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final dbHelper = DatabaseHelper();
                  await dbHelper.deleteBreedingRecord(record['id'] as int);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Record deleted'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.pop(context); // Go back to refresh the list
                },
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Breeding Details'),
                        content: SingleChildScrollView(
                          child: Text(record['breedingInfo'] as String),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

String getBreedingType(String doeBreed, String buckBreed) {
  // Check various combinations of breeds and return the corresponding breeding type
  if (doeBreed == 'Traditional Boer' && buckBreed == 'Full Blood Boer') {
    return '''
Genetics: Percentage Boer (75-100% Boer genetics)
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Caseous Lymphadenitis (CL): Chronic disease causing abscesses in lymph nodes.
2. Caprine Arthritis Encephalitis (CAE): Viral disease affecting joints and nervous system.
3. Parasitic Infections (e.g., worms): Common in grazing goats, leading to weight loss and anemia.
Vaccines:
For enterotoxemia:
Vaccine: CDT Vaccine
Dosage: 2 ml subcutaneously, initial dose followed by a booster in 3-4 weeks, then annually.
For coccidiosis:
Vaccine: None
Prevention: Management and anticoccidial drugs like Amprolium.
Dosage: Follow manufacturer's instructions for anticoccidial drugs.
For pneumonia:
Vaccine: Pasteurella vaccine
Dosage: 2 ml subcutaneously, initial dose followed by a booster in 3-4 weeks, then annually.
For caseousLymphadenitis:
Vaccine: Case-Bac (available in some regions)
Dosage: 1 ml subcutaneously, initial dose followed by a booster in 3-4 weeks, then annually.
    ''';
  } else if (buckBreed == 'Traditional Boer' && doeBreed == 'Full Blood Boer') {
    return '''
Genetics: Percentage Boer (75-100% Boer genetics)
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat
CommonDiseases: 
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine
2. Pneumonia: Pasteurella vaccine
3. CaseousLymphadenitis: Case-Bac
    ''';
  } else if (doeBreed == 'Traditional Boer' && buckBreed == 'Percentage Boer') {
    return '''
Genetics: Percentage Boer (75-100% Boer genetics)
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine
2. Pneumonia: Pasteurella vaccine
3. CaseousLymphadenitis: Case-Bac
    ''';
  } else if (buckBreed == 'Traditional Boer' && doeBreed == 'Percentage Boer') {
    return '''
Genetics: Percentage Boer (varying percentages of Boer genetics)
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Traditional Boer' && buckBreed == 'Red Boer') {
    return '''
Genetics: Red Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Traditional Boer' && doeBreed == 'Red Boer') {
    return '''
Genetics: Red Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Traditional Boer' && buckBreed == 'Black Boer') {
    return '''
Genetics: Black Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Traditional Boer' && doeBreed == 'Black Boer') {
    return '''
Genetics: Black Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Traditional Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Full Blood Boer' && doeBreed == 'Red Boer') {
    return '''
Genetics: Red Full Blood Boer or High-Percentage Red Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Full Blood Boer' && buckBreed == 'Black Boer') {
    return '''
Genetics: Black Full Blood Boer or High-Percentage Black Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Full Blood Boer' && doeBreed == 'Black Boer') {
    return '''
Genetics: Black Full Blood Boer or High-Percentage Black Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Full Blood Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Full Blood Boer or High-Percentage Doppled Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Full Blood Boer' && doeBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Full Blood Boer or High-Percentage Doppled Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Percentage Boer' && buckBreed == 'Red Boer') {
    return '''
Genetics: Red Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Percentage Boer' && doeBreed == 'Red Boer') {
    return '''
Genetics: Red Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Percentage Boer' && buckBreed == 'Black Boer') {
    return '''
Genetics: Black Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Percentage Boer' && doeBreed == 'Black Boer') {
    return '''
Genetics: Black Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Percentage Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Percentage Boer' && doeBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Red Boer' && buckBreed == 'Black Boer') {
    return '''
Genetics: Red-Black Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Red Boer' && doeBreed == 'Black Boer') {
    return '''
Genetics: Red-Black Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Red Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Red-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Red Boer' && doeBreed == 'Doppled Boer') {
    return '''
Genetics: Red-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Black Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Black-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Black Boer' && doeBreed == 'Doppled Boer') {
    return '''
Genetics: Black-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Traditional Boer' &&
      buckBreed == 'Traditional Boer') {
    return '''
Genetics: Traditional Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Full Blood Boer' && buckBreed == 'Full Blood Boer') {
    return '''
Genetics: Full Blood Boer
MeatQuality rating: Excellent
MeatQuality description: High muscle-to-bone ratio, tender meat, lean with good marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Percentage Boer' && buckBreed == 'Percentage Boer') {
    return '''
Genetics: Percentage Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Red Boer' && buckBreed == 'Red Boer') {
    return '''
Genetics: Red Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Black Boer' && buckBreed == 'Black Boer') {
    return '''
Genetics: Black Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Doppled Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (doeBreed == 'Black Boer' && buckBreed == 'Doppled Boer') {
    return '''
Genetics: Black-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else if (buckBreed == 'Black Boer' && doeBreed == 'Doppled Boer') {
    return '''
Genetics: Black-Doppled Boer
MeatQuality rating: Good
MeatQuality description: Moderate muscle-to-bone ratio, tender meat, lean with some marbling.
CommonDiseases:
1. Enterotoxemia (Overeating Disease): Common in young goats
2. Coccidiosis: Caused by protozoa, leading to diarrhea
3. Pneumonia: Respiratory infection
Vaccines:
1. Enterotoxemia: CDT Vaccine (2 ml subcutaneously)
2. Coccidiosis: Management and anticoccidial drugs
3. Pneumonia: Pasteurella vaccine (2 ml subcutaneously)
    ''';
  } else {
    return 'Unknown Breeding Type , Muchishona tikuti hamuna bhuridhi akadero';
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Get the database instance, initializing it if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'goats.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Boers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        breed TEXT,
        goatTag TEXT,
        weight TEXT,
        dateOfBirth TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE SickBoers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        breed TEXT,
        goatTag TEXT,
        weight TEXT,
        dateOfBirth TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE SoldBoers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        goatTag TEXT,
        weight TEXT,
        price TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE BoersonSale (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        goatTag TEXT,
        weight TEXT,
        price TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE BreedingRecords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doeId TEXT,
        buckId TEXT,
        date TEXT,
        breedingInfo TEXT,
        notes TEXT
      )
    ''');
  }

  // Insert a goat into the Boers table
  Future<int> insertGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('Boers', goat);
  }

  // Insert a breeding record
  Future<int> insertBreedingRecord(Map<String, dynamic> record) async {
    Database db = await database;
    return await db.insert('BreedingRecords', record);
  }

  // Get all breeding records
  Future<List<Map<String, dynamic>>> getBreedingRecords() async {
    Database db = await database;
    return await db.query('BreedingRecords');
  }

  // Insert a sick goat into the SickBoers table
  Future<int> insertSickGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SickBoers', goat);
  }

  // Insert a sold goat into the SoldBoers table
  Future<int> insertSoldGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SoldBoers', goat);
  }

  // Insert a goat on sale into the BoersonSale table
  Future<int> insertBoersonSale(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('BoersonSale', goat);
  }

  // Delete a sold goat from the SoldBoers table
  Future<int> deleteSoldGoat(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'SoldBoers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  // Get all goats from the Boers table
  Future<List<Map<String, dynamic>>> getGoats() async {
    Database db = await database;
    return await db.query('Boers');
  }

  // Get all sick goats from the SickBoers table
  Future<List<Map<String, dynamic>>> getSickGoats() async {
    Database db = await database;
    return await db.query('SickBoers');
  }

  // Get all sold goats from the SoldBoers table
  Future<List<Map<String, dynamic>>> getSoldGoats() async {
    Database db = await database;
    return await db.query('SoldBoers');
  }

  // Search for a goat in the Boers table by breed, type, and tag
  Future<List<Map<String, dynamic>>> searchGoat(
    String breed,
    String type,
    String tag,
  ) async {
    Database db = await database;
    return await db.query(
      'Boers',
      where: 'breed = ? AND goatType = ? AND goatTag = ?',
      whereArgs: [breed, type, tag],
    );
  }

  // Update a goat's details in the Boers table
  Future<int> updateGoat(String goatTag, Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.update(
      'Boers',
      goat,
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  // Delete a goat from the Boers table
  Future<int> deleteGoat(String goatTag) async {
    Database db = await database;
    return await db.delete('Boers', where: 'goatTag = ?', whereArgs: [goatTag]);
  }

  Future<int> deleteBreedingRecord(int id) async {
    Database db = await database;
    return await db.delete('BreedingRecords', where: 'id = ?', whereArgs: [id]);
  }

  // Get a goat by its tag from the Boers table
  Future<Map<String, dynamic>?> getGoatByTag(String goatTag) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Boers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  insertBoerBreeds(Map<String, dynamic> breeding) {}
}
