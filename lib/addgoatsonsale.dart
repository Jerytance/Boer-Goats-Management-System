import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddGoatsOnSale extends StatefulWidget {
  const AddGoatsOnSale({super.key});

  @override
  _AddGoatsOnSaleState createState() => _AddGoatsOnSaleState();
}

class _AddGoatsOnSaleState extends State<AddGoatsOnSale> {
  final List<String> goatTypes = ['Doe', 'Buck', 'Kids'];
  String? selectedGoatType;
  final TextEditingController goatTagController = TextEditingController();
  final TextEditingController goatWeightController = TextEditingController();
  final TextEditingController goatPriceController = TextEditingController();

  Future<void> _deleteGoat() async {
    if (goatTagController.text.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Please enter a goat tag to delete'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
      return;
    }

    try {
      final dbHelper = DatabaseHelper();
      final deletedRows = await dbHelper.deleteGoatFromSale(
        goatTagController.text,
      );

      if (deletedRows > 0) {
        setState(() {
          goatTagController.clear();
          goatWeightController.clear();
          goatPriceController.clear();
          selectedGoatType = null;
        });

        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully deleted goat with tag ${goatTagController.text}',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(
            content: Text('No goat found with this tag'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text('Error deleting goat: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Goats on Sale',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.green[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Goat Type Dropdown
                        Row(
                          children: [
                            const Icon(
                              Icons.pets,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedGoatType,
                                  hint: const Text(
                                    'Select Goat Type',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.green,
                                  ),
                                  underline: const SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedGoatType = newValue;
                                    });
                                  },
                                  items:
                                      goatTypes.map<DropdownMenuItem<String>>((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        // Goat Tag Field
                        TextFormField(
                          controller: goatTagController,
                          decoration: InputDecoration(
                            labelText: 'Goat Tag',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon: const Icon(
                              Icons.tag,
                              color: Colors.green,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Goat Weight Field
                        TextFormField(
                          controller: goatWeightController,
                          decoration: InputDecoration(
                            labelText: 'Goat Weight (Kgs)',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon: const Icon(
                              Icons.scale,
                              color: Colors.green,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.green,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        // Goat Price Field
                        TextFormField(
                          controller: goatPriceController,
                          decoration: InputDecoration(
                            labelText: 'Goat Price (\$)',
                            labelStyle: const TextStyle(color: Colors.green),
                            prefixIcon: const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Save Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          225,
                          217,
                          224,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        if (selectedGoatType != null &&
                            goatTagController.text.isNotEmpty &&
                            goatWeightController.text.isNotEmpty &&
                            goatPriceController.text.isNotEmpty) {
                          Map<String, dynamic> goat = {
                            'goatType': selectedGoatType,
                            'goatTag': goatTagController.text,
                            'weight': goatWeightController.text,
                            'price': goatPriceController.text,
                          };
                          int result = await DatabaseHelper().insertBoersonSale(
                            goat,
                          );
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Goat saved successfully!'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to save goat'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // Delete Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _deleteGoat,
                    ),
                    // Back Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700]!,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
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

  Future<int> deleteGoatFromSale(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'BoersonSale',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
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

  updateGoat(String string, Map<String, dynamic> goat) {}

  deleteGoat(String text) {}

  getTreatmentAndFeed(String s) {}
}
