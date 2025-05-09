import 'package:flutter/material.dart';
import 'package:welcome/database_helper.dart';
import 'package:welcome/view_sick_goats_screen.dart';

class AddSickGoatScreen extends StatefulWidget {
  const AddSickGoatScreen({super.key});

  @override
  _AddSickGoatScreenState createState() => _AddSickGoatScreenState();
}

class _AddSickGoatScreenState extends State<AddSickGoatScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGoatType;
  String? _selectedBreed;
  DateTime? _selectedDate;
  final _goatTagController = TextEditingController();
  final _weightController = TextEditingController();

  final List<String> _goatTypes = ['Doe', 'Buck', 'Kids'];
  final List<String> _breeds = [
    'Traditional Boer',
    'Full Blood Boer',
    'Percentage Boer',
    'Red Boer',
    'Black Boer',
    'Doppled Boer',
  ];

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<bool> _isSickGoatTagExists(String tagId) async {
    final sickGoats = await _databaseHelper.getSickGoats();
    return sickGoats.any((goat) => goat['goatTag'] == tagId);
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the weight';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight < 1) {
      return 'Weight must be at least 1 kg';
    }

    if (_selectedGoatType == 'Kids' && weight > 60) {
      return 'Weight cannot exceed 60 kg for Kids';
    }
    if (_selectedGoatType == 'Doe' && weight > 100) {
      return 'Weight cannot exceed 100 kg for Does';
    }
    if (_selectedGoatType == 'Buck' && weight > 140) {
      return 'Weight cannot exceed 140 kg for Bucks';
    }
    if (weight > 400) {
      return 'Weight cannot exceed 400 kg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Sick Goat',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Icon(Icons.sick, size: 50, color: Colors.teal),
                      ),
                      const SizedBox(height: 20),
                      // Goat Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGoatType,
                        decoration: InputDecoration(
                          labelText: 'Goat Type',
                          prefixIcon: const Icon(Icons.pets),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items:
                            _goatTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGoatType = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a goat type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Breed Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedBreed,
                        decoration: InputDecoration(
                          labelText: 'Breed',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items:
                            _breeds.map((String breed) {
                              return DropdownMenuItem<String>(
                                value: breed,
                                child: Text(breed),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBreed = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a breed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Date Picker
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Select Date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Goat Tag Field
                      TextFormField(
                        controller: _goatTagController,
                        decoration: InputDecoration(
                          labelText: 'Goat Tag',
                          prefixIcon: const Icon(Icons.tag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goat tag';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Weight Field
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: const Icon(Icons.monitor_weight),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateWeight,
                      ),
                      const SizedBox(height: 30),
                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SAVE Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save, size: 20),
                            label: const Text('SAVE'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final String tagId = _goatTagController.text;
                                bool sickTagExists = await _isSickGoatTagExists(
                                  tagId,
                                );
                                if (sickTagExists) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Sick goat with that tag ID is already saved. Please enter a different tag ID.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                Map<String, dynamic> goat = {
                                  'goatType': _selectedGoatType,
                                  'breed': _selectedBreed,
                                  'goatTag': tagId,
                                  'weight': _weightController.text,
                                  'dateOfBirth':
                                      _selectedDate?.toIso8601String(),
                                };
                                int result = await _databaseHelper
                                    .insertSickGoat(goat);

                                if (result > 0) {
                                  // Check if the goat exists in the Boers table
                                  final List<Map<String, dynamic>> boerGoats =
                                      await _databaseHelper.getGoats();
                                  final boerGoatToDelete = boerGoats.firstWhere(
                                    (boer) => boer['goatTag'] == tagId,
                                    orElse: () => <String, dynamic>{},
                                  );

                                  if (boerGoatToDelete.isNotEmpty) {
                                    // Delete the goat from the Boers table
                                    await _databaseHelper.deleteGoat(tagId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Goat moved to sick list and removed from main list.',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Sick goat saved successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }

                                  _formKey.currentState!.reset();
                                  _goatTagController.clear();
                                  _weightController.clear();
                                  setState(() {
                                    _selectedGoatType = null;
                                    _selectedBreed = null;
                                    _selectedDate = null;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Failed to save sick goat. Please try again.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          // VIEW Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.list, size: 20),
                            label: const Text('VIEW'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSickGoatsScreen(),
                                ),
                              );
                            },
                          ),
                          // BACK Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            label: const Text('BACK'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
