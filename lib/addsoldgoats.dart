import 'package:flutter/material.dart';
import 'package:welcome/viewsoldgoats.dart';
import 'database_helper.dart';

class AddSoldGoats extends StatefulWidget {
  const AddSoldGoats({super.key});

  @override
  _AddSoldGoatsState createState() => _AddSoldGoatsState();
}

class _AddSoldGoatsState extends State<AddSoldGoats> {
  final List<String> goatTypes = ['Doe', 'Buck', 'Kids'];
  String? selectedGoatType;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _clearForm() {
    setState(() {
      selectedGoatType = null;
      _tagController.clear();
      _weightController.clear();
      _priceController.clear();
    });
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the weight';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }

    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }

    // Validate based on goat type
    if (selectedGoatType == 'Kids' && weight > 60) {
      return 'Kids cannot exceed 60 kgs';
    } else if (selectedGoatType == 'Doe' && weight > 100) {
      return 'Does cannot exceed 100 kgs';
    } else if (selectedGoatType == 'Buck' && weight > 140) {
      return 'Bucks cannot exceed 140 kgs';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Record Sold Goat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.white],
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
                      const Center(
                        child: Icon(
                          Icons.attach_money,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Goat Type Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedGoatType,
                        decoration: InputDecoration(
                          labelText: 'Goat Type',
                          prefixIcon: const Icon(Icons.pets),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        hint: const Text('Select Goat Type'),
                        items:
                            goatTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGoatType = newValue;
                            // Trigger weight validation when type changes
                            if (_weightController.text.isNotEmpty) {
                              _formKey.currentState!.validate();
                            }
                          });
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select a goat type'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      // Goat Tag Field
                      TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: 'Goat Tag',
                          prefixIcon: const Icon(Icons.tag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter a tag' : null,
                      ),
                      const SizedBox(height: 20),
                      // Weight Field
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Weight (Kgs)',
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
                      const SizedBox(height: 20),
                      // Price Field
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price (\$)',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the price';
                          }
                          final price = double.tryParse(value);
                          if (price == null) {
                            return 'Please enter a valid number';
                          }
                          if (price <= 0) {
                            return 'Price must be greater than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Buttons Row
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          // Save Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save, size: 20),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
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
                                DatabaseHelper dbHelper = DatabaseHelper();

                                // Check if goat with this tag already exists
                                bool exists = await dbHelper.checkGoatExists(
                                  _tagController.text,
                                );

                                if (exists) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Goat with tag ${_tagController.text} already exists in sales records!',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                } else {
                                  await dbHelper.insertSoldGoat({
                                    'goatType': selectedGoatType,
                                    'goatTag': _tagController.text,
                                    'weight': _weightController.text,
                                    'price': _priceController.text,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Goat sale recorded successfully!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  _clearForm(); // Clear the form after successful save
                                }
                              }
                            },
                          ),
                          // View Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.list, size: 20),
                            label: const Text('View Sales'),
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
                                  builder: (context) => ViewSoldGoats(),
                                ),
                              );
                            },
                          ),
                          // Back Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            label: const Text('Back'),
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
