import 'package:flutter/material.dart';
import 'package:welcome/database_helper.dart';

class GoatSearchScreen extends StatefulWidget {
  const GoatSearchScreen({super.key});

  @override
  State<GoatSearchScreen> createState() => _GoatSearchScreenState();
}

class _GoatSearchScreenState extends State<GoatSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBreed;
  String? _selectedType;
  String? _goatTag;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  Map<String, dynamic>? _selectedGoat;
  bool _showGoatDetails = false;

  final List<String> _breeds = ['Doe', 'Buck', 'Kid'];
  final List<String> _types = [
    'Traditional Boer',
    'Full Blood Boer',
    'Percentage Boer',
    'Red Boer',
    'Black Boer',
    'Doppled Boer',
  ];

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await _databaseHelper.database;
    } catch (e) {
      _showErrorSnackBar('Failed to initialize database: $e');
    }
  }

  Future<void> _searchGoats() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSearching = true;
      _searchResults = [];
      _selectedGoat = null;
      _showGoatDetails = false;
    });

    try {
      final results = await _databaseHelper.searchGoats(
        breed: _selectedBreed,
        goatType: _selectedType,
        goatTag: _goatTag,
      );

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showGoatDetails = results.isNotEmpty;
      });

      if (_searchResults.isEmpty) {
        _showInfoSnackBar('No goats found matching your criteria');
      }
    } catch (e) {
      setState(() => _isSearching = false);
      _showErrorSnackBar('Error searching goats: $e');
    }
  }

  Future<void> _viewAllGoats() async {
    setState(() {
      _isSearching = true;
      _searchResults = [];
      _selectedGoat = null;
      _showGoatDetails = false;
    });

    try {
      final results = await _databaseHelper.getAllGoats();

      setState(() {
        _searchResults = results;
        _isSearching = false;
        _showGoatDetails = results.isNotEmpty;
      });

      if (_searchResults.isEmpty) {
        _showInfoSnackBar('No goats found in the database');
      }
    } catch (e) {
      setState(() => _isSearching = false);
      _showErrorSnackBar('Error fetching goats: $e');
    }
  }

  void _showGoatDetail(Map<String, dynamic> goat) {
    setState(() {
      _selectedGoat = goat;
      _showGoatDetails = true;
    });
  }

  void _clearSearch() {
    setState(() {
      _selectedBreed = null;
      _selectedType = null;
      _goatTag = null;
      _searchResults = [];
      _selectedGoat = null;
      _showGoatDetails = false;
      _formKey.currentState?.reset();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Goat Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _viewAllGoats,
            tooltip: 'View All Goats',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal[50]!, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.teal,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Search Goats',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Breed Dropdown
                        _buildDropdown(
                          label: 'Breed',
                          value: _selectedBreed,
                          items: _breeds,
                          icon: Icons.category,
                          onChanged:
                              (value) => setState(() => _selectedBreed = value),
                        ),
                        const SizedBox(height: 16),
                        // Type Dropdown
                        _buildDropdown(
                          label: 'Type',
                          value: _selectedType,
                          items: _types,
                          icon: Icons.pets,
                          onChanged:
                              (value) => setState(() => _selectedType = value),
                        ),
                        const SizedBox(height: 16),
                        // Tag Input
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Goat Tag',
                            prefixIcon: const Icon(
                              Icons.tag,
                              color: Colors.teal,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.teal[700]!,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          onSaved: (value) => _goatTag = value,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _searchGoats,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child:
                                    _isSearching
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          'SEARCH',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _clearSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.grey[800],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'CLEAR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Results Section
            if (_searchResults.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.list,
                              color: Colors.teal,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Search Results (${_searchResults.length})',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 300,
                          child: ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder:
                                (context, index) => const Divider(
                                  height: 8,
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                            itemBuilder: (context, index) {
                              final goat = _searchResults[index];
                              return _buildGoatListItem(goat);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Goat Details Section
            if (_showGoatDetails && _selectedGoat != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[50]!, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.teal,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Goat Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed:
                                  () =>
                                      setState(() => _showGoatDetails = false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(_selectedGoat!),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      items:
          items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null && _selectedType == null && _goatTag == null) {
          return 'At least one search criteria is required';
        }
        return null;
      },
    );
  }

  Widget _buildGoatListItem(Map<String, dynamic> goat) {
    Color statusColor = Colors.grey;
    switch (goat['status']) {
      case 'Healthy':
        statusColor = Colors.green;
        break;
      case 'Sick':
        statusColor = Colors.orange;
        break;
      case 'On Sale':
        statusColor = Colors.blue;
        break;
      case 'Sold':
        statusColor = Colors.purple;
        break;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.teal[100],
        child: Icon(
          goat['goatType'] == 'Buck' ? Icons.male : Icons.female,
          color: Colors.teal[800],
        ),
      ),
      title: Text(
        goat['goatTag'],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        '${goat['goatType']} • ${goat['breed']}',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Chip(
        label: Text(
          goat['status'] ?? 'Unknown',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: statusColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () => _showGoatDetail(goat),
    );
  }

  Widget _buildDetailCard(Map<String, dynamic> goat) {
    Color statusColor = Colors.grey;
    switch (goat['status']) {
      case 'Healthy':
        statusColor = Colors.green;
        break;
      case 'Sick':
        statusColor = Colors.orange;
        break;
      case 'On Sale':
        statusColor = Colors.blue;
        break;
      case 'Sold':
        statusColor = Colors.purple;
        break;
    }

    return Column(
      children: [
        _buildDetailRow('Tag', goat['goatTag']),
        _buildDetailRow('Type', goat['goatType']),
        _buildDetailRow('Breed', goat['breed']),
        _buildDetailRowWithColor(
          'Status',
          goat['status'] ?? 'Unknown',
          statusColor,
        ),
        if (goat.containsKey('weight'))
          _buildDetailRow('Weight', '${goat['weight']} kg'),
        if (goat.containsKey('price'))
          _buildDetailRow('Price', '\$${goat['price']}'),
        if (goat.containsKey('dateOfBirth'))
          _buildDetailRow('Date of Birth', goat['dateOfBirth']),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithColor(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
