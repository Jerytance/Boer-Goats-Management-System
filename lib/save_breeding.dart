import 'package:flutter/material.dart';
import 'package:welcome/database_helper.dart';

class SaveBreeding extends StatefulWidget {
  final String doeId;
  final String buckId;
  final String breedingInfo;

  const SaveBreeding({
    super.key,
    required this.doeId,
    required this.buckId,
    required this.breedingInfo,
  });

  @override
  State<SaveBreeding> createState() => _SaveBreedingState();
}

class _SaveBreedingState extends State<SaveBreeding> {
  final TextEditingController doeIdController = TextEditingController();
  final TextEditingController buckIdController = TextEditingController();
  DateTime? selectedDate;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Helper method to format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    doeIdController.text = widget.doeId;
    buckIdController.text = widget.buckId;
    // Calculate expected DOB by adding 5 months (150 days) to current date
    final currentDate = DateTime.now();
    selectedDate = DateTime(
      currentDate.year,
      currentDate.month + 5,
      currentDate.day,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.teal),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _viewDetails(BuildContext context) async {
    List<Map<String, dynamic>> breedingRecords =
        await _dbHelper.getBreedingRecords();

    if (breedingRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No breeding records found.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (BuildContext dialogContext) => AlertDialog(
              title: const Text(
                'Breeding Details',
                style: TextStyle(color: Colors.teal),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      breedingRecords.map((record) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.female,
                                color: Colors.pink,
                              ),
                              title: Text('Doe ID: ${record['doeId']}'),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.male,
                                color: Colors.blue,
                              ),
                              title: Text('Buck ID: ${record['buckId']}'),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Colors.teal,
                              ),
                              title: Text(
                                'Expected DOB: ${_formatDate(DateTime.parse(record['expectedDOB']))}',
                              ),
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('OK', style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _saveBreeding(BuildContext context) async {
    String doeId = doeIdController.text;
    String buckId = buckIdController.text;

    if (doeId.isEmpty || buckId.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter Doe ID, Buck ID, and select a date.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> breeding = {
      'doeId': doeId,
      'buckId': buckId,
      'expectedDOB': _formatDate(selectedDate!),
    };

    try {
      int? result = await _dbHelper.insertBoerBreeds(breeding);

      if (result <= 0) {
        throw Exception('Database operation returned invalid result');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goat breeds saved successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving breeding: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Save Breeding',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE0F2F1)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: doeIdController,
                        decoration: InputDecoration(
                          labelText: 'Doe ID',
                          labelStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.teal,
                          ),
                          prefixIcon: const Icon(
                            Icons.female,
                            color: Colors.pink,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: buckIdController,
                        decoration: InputDecoration(
                          labelText: 'Buck ID',
                          labelStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.teal,
                          ),
                          prefixIcon: const Icon(
                            Icons.male,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          selectedDate == null
                              ? 'No date selected'
                              : 'Expected DOB (5 months gestation): ${_formatDate(selectedDate!)}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                        ),
                        onPressed: () => _selectDate(context),
                        tooltip: 'Select Date',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text('Save'),
                    onPressed: () => _saveBreeding(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.visibility, size: 20),
                    label: const Text('View'),
                    onPressed: () => _viewDetails(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 20),
                    label: const Text('Back'),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
