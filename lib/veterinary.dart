import 'package:flutter/material.dart';
import 'package:welcome/groupmembers.dart';

class Vertinary extends StatefulWidget {
  const Vertinary({super.key});

  @override
  _VertinaryState createState() => _VertinaryState();
}

class _VertinaryState extends State<Vertinary> {
  String? _selectedSymptom;
  Map<String, dynamic>? _treatmentInfo;

  final List<String> _symptoms = [
    'Loss of Appetite',
    'Abnormal Stool',
    'Coughing or Difficulty Breathing',
    'Lethargy or Weakness',
    'Abnormal Temperature',
    'Changes in Behavior',
    'Swelling or Lumps',
    'Changes in Milk Production',
    'Rough or Dull Coat',
    'Sudden Death',
    'Weight Loss',
    'Bloating',
    'Nasal Discharge',
    'Excessive Drooling',
    'Pale Gums/Anemia',
    'Excessive Itching',
    'Lameness/Joint Swelling',
  ];

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinary Assistant'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.medical_services, size: 50, color: Colors.teal),
                    SizedBox(height: 10),
                    Text(
                      'Animal Symptom Checker',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Select a symptom to get treatment recommendations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medical_information, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(
                          'Select Symptom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      items:
                          _symptoms.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSymptom = newValue;
                          _treatmentInfo = null;
                        });
                      },
                      value: _selectedSymptom,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      hint: Text('Choose from the list'),
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: Text('Generate Treatment'),
                onPressed: () async {
                  if (_selectedSymptom != null) {
                    final treatmentInfo = await _databaseHelper
                        .getTreatmentAndFeed(_selectedSymptom!);
                    setState(() {
                      _treatmentInfo = treatmentInfo;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a symptom first'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 200),
                padding: const EdgeInsets.all(16.0),
                child:
                    _treatmentInfo != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assignment, color: Colors.teal),
                                SizedBox(width: 10),
                                Text(
                                  'Treatment Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey.shade300),
                            SizedBox(height: 10),
                            _InfoRow(
                              icon: Icons.health_and_safety,
                              title: 'Possible Diseases:',
                              content: _treatmentInfo!['diseases'],
                            ),
                            SizedBox(height: 15),
                            _InfoRow(
                              icon: Icons.medication,
                              title: 'Recommended Treatment:',
                              content: _treatmentInfo!['treatment'],
                            ),
                            SizedBox(height: 15),
                            _InfoRow(
                              icon: Icons.fastfood,
                              title: 'Dietary Recommendations:',
                              content: _treatmentInfo!['feed'],
                            ),
                          ],
                        )
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Treatment information will appear here\nafter selecting a symptom and generating treatment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                icon: Icon(Icons.help_outline),
                label: Text('Need more help? Contact a veterinarian'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupMembers()),
                  );
                  // Navigate to help section
                },
                style: TextButton.styleFrom(foregroundColor: Colors.teal),
              ),
            ),

            // BACK Button
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text('BACK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.teal),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(content, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

class DatabaseHelper {
  Future<Map<String, dynamic>> getTreatmentAndFeed(String symptom) async {
    // Simulate fetching data from a database
    await Future.delayed(Duration(seconds: 1));

    Map<String, Map<String, String>> data = {
      'Loss of Appetite': {
        'diseases': 'Parasites, Ketosis, Bloat',
        'treatment': 'Antiparasitics, Antibiotics',
        'feed': 'High-energy feed, electrolytes',
      },
      'Abnormal Stool': {
        'diseases': 'Coccidiosis, Worms',
        'treatment': 'Antiparasitics, Probiotics',
        'feed': 'Probiotic feed, hay',
      },
      'Coughing or Difficulty Breathing': {
        'diseases': 'Pneumonia, Bloat',
        'treatment': 'Antibiotics, Anti-inflammatories',
        'feed': 'High-quality forage',
      },
      'Lethargy or Weakness': {
        'diseases': 'Ketosis, Anemia',
        'treatment': 'Vitamins, Iron supplements',
        'feed': 'Iron-rich feed, energy supplements',
      },
      'Abnormal Temperature': {
        'diseases': 'Infection, Pneumonia',
        'treatment': 'Antibiotics, Anti-inflammatories',
        'feed': 'Electrolytes, hay',
      },
      'Changes in Behavior': {
        'diseases': 'Listeriosis, Ketosis',
        'treatment': 'Antibiotics, Supportive care',
        'feed': 'High-energy feed',
      },
      'Swelling or Lumps': {
        'diseases': 'Abscess, Anthrax',
        'treatment': 'Antibiotics, Drainage',
        'feed': 'Normal feed',
      },
      'Changes in Milk Production': {
        'diseases': 'Mastitis',
        'treatment': 'Antibiotics, Anti-inflammatories',
        'feed': 'Normal feed',
      },
      'Rough or Dull Coat': {
        'diseases': 'Parasites, Nutritional',
        'treatment': 'Antiparasitics, Supplements',
        'feed': 'Vitamin/mineral supplements',
      },
      'Sudden Death': {
        'diseases': 'Anthrax, Poisoning',
        'treatment': 'Vaccination (prevention)',
        'feed': 'N/A',
      },
      'Weight Loss': {
        'diseases': 'Parasites, Ketosis',
        'treatment': 'Antiparasitics, Energy supplements',
        'feed': 'High-energy feed',
      },
      'Bloating': {
        'diseases': 'Bloat',
        'treatment': 'Antifoaming agents, Surgery',
        'feed': 'Low-protein feed',
      },
      'Nasal Discharge': {
        'diseases': 'Pneumonia, Respiratory',
        'treatment': 'Antibiotics',
        'feed': 'High-quality forage',
      },
      'Excessive Drooling': {
        'diseases': 'Bloat, Poisoning',
        'treatment': 'Antifoaming agents, Supportive care',
        'feed': 'Normal feed',
      },
      'Pale Gums/Anemia': {
        'diseases': 'Parasites, Nutritional',
        'treatment': 'Iron supplements, Antiparasitics',
        'feed': 'Iron-rich feed',
      },
      'Excessive Itching': {
        'diseases': 'Mange, Lice',
        'treatment': 'Antiparasitics',
        'feed': 'Normal feed',
      },
      'Lameness/Joint Swelling': {
        'diseases': 'Foot Rot, Joint Ill',
        'treatment': 'Antibiotics, Anti-inflammatories',
        'feed': 'Normal feed',
      },
    };

    return data[symptom] ?? {};
  }
}
