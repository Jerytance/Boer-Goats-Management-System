import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UpdateSickGoatScreen extends StatefulWidget {
  final int goatId;

  const UpdateSickGoatScreen({super.key, required this.goatId});

  @override
  _UpdateSickGoatScreenState createState() => _UpdateSickGoatScreenState();
}

class _UpdateSickGoatScreenState extends State<UpdateSickGoatScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String? _selectedGoatType;
  String? _selectedBreed;
  DateTime? _selectedDate;
  final _goatTagController = TextEditingController();
  final _weightController = TextEditingController();
  final _searchBreedController = TextEditingController();
  final _searchTypeController = TextEditingController();
  final _searchTagController = TextEditingController();

  final List<String> _goatTypes = ['Doe', 'Buck', 'Kids'];
  final List<String> _breeds = [
    'Traditional Boer',
    'Full Blood Boer',
    'Percentage Boer',
    'Red Boer',
    'Black Boer',
    'Doppled Boer',
  ];

  Map<String, dynamic>? _searchResult;

  @override
  void initState() {
    super.initState();
    _loadGoatDetails();
  }

  Future<void> _loadGoatDetails() async {
    try {
      List<Map<String, dynamic>> goatList =
          await _databaseHelper.getSickGoats();
      if (goatList.isEmpty) {
        throw Exception('No goats found');
      }
      Map<String, dynamic>? goat = goatList.firstWhere(
        (goat) => goat['id'] == widget.goatId,
        orElse: () => {},
      );
      setState(() {
        _selectedGoatType = goat['goatType'];
        _selectedBreed = goat['breed'];
        _selectedDate = DateTime.parse(goat['dateOfBirth']);
        _goatTagController.text = goat['goatTag'];
        _weightController.text = goat['weight'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Failed to load goat details: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateGoat() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> goat = {
        'goatType': _selectedGoatType,
        'breed': _selectedBreed,
        'dateOfBirth': _selectedDate!.toIso8601String(),
        'goatTag': _goatTagController.text,
        'weight': _weightController.text,
      };
      try {
        int result = await _databaseHelper.updateSickGoat(
          _goatTagController.text,
          goat,
        );
        if (result > 0) {
          _clearForm();
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(
              content: Text('Goat updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context as BuildContext,
          ).showSnackBar(SnackBar(content: Text('Failed to update goat')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context as BuildContext,
        ).showSnackBar(SnackBar(content: Text('Failed to update goat: $e')));
      }
    }
  }

  void _clearForm() {
    setState(() {
      _selectedGoatType = null;
      _selectedBreed = null;
      _selectedDate = null;
      _goatTagController.clear();
      _weightController.clear();
      _searchResult = null;
    });
  }

  Future<void> _deleteGoat() async {
    try {
      await _databaseHelper.deleteSickGoat(_goatTagController.text);
      ScaffoldMessenger.of(
        context as BuildContext,
      ).showSnackBar(SnackBar(content: Text('Goat deleted successfully')));
      Navigator.pop(context as BuildContext);
    } catch (e) {
      ScaffoldMessenger.of(
        context as BuildContext,
      ).showSnackBar(SnackBar(content: Text('Failed to delete goat: $e')));
    }
  }

  Future<void> _searchGoat() async {
    try {
      List<Map<String, dynamic>> result = await _databaseHelper.searchGoat(
        _searchBreedController.text,
        _searchTypeController.text,
        _searchTagController.text,
      );
      if (result.isNotEmpty) {
        setState(() {
          _searchResult = result.first;
        });
      } else {
        setState(() {
          _searchResult = null;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('No goat found with the given details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context as BuildContext,
      ).showSnackBar(SnackBar(content: Text('Failed to search goat: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Sick Goat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[100]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                        child: Icon(
                          Icons.medical_services,
                          size: 50,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDropdownField(
                        value: _selectedGoatType,
                        label: 'Goat Type',
                        icon: Icons.category,
                        items: _goatTypes,
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
                      _buildDropdownField(
                        value: _selectedBreed,
                        label: 'Breed',
                        icon: Icons.agriculture,
                        items: _breeds,
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
                      _buildDateField(context),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _goatTagController,
                        label: 'Goat Tag',
                        icon: Icons.tag,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goat tag';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight,
                        keyboardType: TextInputType.number,
                        validator: (value) {
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
                          if (weight > 400) {
                            return 'Weight cannot exceed 400 kg';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      if (_searchResult != null)
                        Card(
                          color: Colors.orange[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSearchResultItem(
                                  Icons.category,
                                  'Type: ${_searchResult!['goatType']}',
                                ),
                                _buildSearchResultItem(
                                  Icons.agriculture,
                                  'Breed: ${_searchResult!['breed']}',
                                ),
                                _buildSearchResultItem(
                                  Icons.tag,
                                  'Tag: ${_searchResult!['goatTag']}',
                                ),
                                _buildSearchResultItem(
                                  Icons.monitor_weight,
                                  'Weight: ${_searchResult!['weight']} kg',
                                ),
                                _buildSearchResultItem(
                                  Icons.calendar_today,
                                  'DOB: ${_searchResult!['dateOfBirth']}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
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

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
      isExpanded: true,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _updateGoat,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('SAVE CHANGES'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[800],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _deleteGoat,
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text('DELETE GOAT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'goats.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

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
  }

  Future<int> insertGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('Boers', goat);
  }

  Future<int> insertSickGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SickBoers', goat);
  }

  Future<int> insertSoldGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SoldBoers', goat);
  }

  Future<int> insertBoersonSale(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('BoersonSale', goat);
  }

  Future<int> deleteSoldGoat(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'SoldBoers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  Future<List<Map<String, dynamic>>> getGoats() async {
    Database db = await database;
    return await db.query('Boers');
  }

  Future<List<Map<String, dynamic>>> getSickGoats() async {
    Database db = await database;
    return await db.query('SickBoers');
  }

  Future<List<Map<String, dynamic>>> getSoldGoats() async {
    Database db = await database;
    return await db.query('SoldBoers');
  }

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

  Future<int> updateSickGoat(String goatTag, Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.update(
      'SickBoers',
      goat,
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  Future<int> deleteSickGoat(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'SickBoers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }
}
