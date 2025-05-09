import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoatsOnSale extends StatefulWidget {
  const GoatsOnSale({super.key});

  @override
  GoatsOnSaleState createState() => GoatsOnSaleState();
}

class GoatsOnSaleState extends State<GoatsOnSale> {
  final List<String> goatTypes = ['Doe', 'Buck', 'Kids'];
  String? selectedGoatType;
  final TextEditingController goatTagController = TextEditingController();
  List<Map<String, dynamic>> goatsOnSale = [];
  List<Map<String, dynamic>> filteredGoats = [];

  @override
  void initState() {
    super.initState();
    _loadGoatsOnSale();
  }

  Future<void> _loadGoatsOnSale() async {
    final dbHelper = DatabaseHelper();
    final goats = await dbHelper.getGoatsOnSale();
    setState(() {
      goatsOnSale = goats;
      filteredGoats = goats;
    });
  }

  Future<void> _filterGoats() async {
    if (selectedGoatType == null) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
          content: Text('Please select a goat type to view'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
      return;
    }

    final dbHelper = DatabaseHelper();
    final allGoats = await dbHelper.getGoatsOnSale();

    setState(() {
      filteredGoats =
          allGoats
              .where((goat) => goat['goatType'] == selectedGoatType)
              .toList();
    });

    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        content: Text(
          'Showing ${filteredGoats.length} ${selectedGoatType!}(s) on sale',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

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
          selectedGoatType = null;
        });

        await _loadGoatsOnSale();

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
          'View Goats on Sale',
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
            colors: [Colors.green[800]!, Colors.green[900]!],
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
                  color: Colors.green[700],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Goat Type Dropdown
                        Row(
                          children: [
                            const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Goat Type:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedGoatType,
                                  hint: const Text(
                                    'Select Goat Type',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
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
                                              color: Colors.black,
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
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Goat Tag',
                            labelStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.tag,
                              color: Colors.white,
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
                    // View Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        'View',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _filterGoats,
                    ),
                    // Delete Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Delete'),
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
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
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
                const SizedBox(height: 30),
                // List of goats on sale
                const Text(
                  'Goats Currently on Sale:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                filteredGoats.isEmpty
                    ? const Center(
                      child: Text(
                        'No goats currently on sale',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredGoats.length,
                      itemBuilder: (context, index) {
                        final goat = filteredGoats[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.green[700],
                          child: ListTile(
                            leading: const Icon(
                              Icons.pets,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Tag: ${goat['goatTag']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type: ${goat['goatType']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                if (goat['weight'] != null)
                                  Text(
                                    'Weight: ${goat['weight']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                if (goat['price'] != null)
                                  Text(
                                    'Price: ${goat['price']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                final dbHelper = DatabaseHelper();
                                await dbHelper.deleteGoatFromSale(
                                  goat['goatTag'],
                                );
                                await _loadGoatsOnSale();
                              },
                            ),
                          ),
                        );
                      },
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
      CREATE TABLE BoersonSale (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        goatTag TEXT UNIQUE,
        weight TEXT,
        price TEXT
      )
    ''');
    // Other table creations...
  }

  Future<List<Map<String, dynamic>>> getGoatsOnSale() async {
    Database db = await database;
    return await db.query('BoersonSale');
  }

  Future<int> deleteGoatFromSale(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'BoersonSale',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }
}
