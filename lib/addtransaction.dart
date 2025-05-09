import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:welcome/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Milk Sales';
  double _amount = 0.0;
  String _type = 'Income';
  DateTime? _selectedDate;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final List<String> _categories = [
    'Milk Sales',
    'Feed Purchase',
    'Veterinary',
    'Electricity',
    'Farm Tools',
    'Health Supplement',
    'Insurance',
    'Internet',
    'Loans',
    'Maintenance',
    'Meat',
    'Rent',
    'Salary',
  ];

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Transaction",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              const SizedBox(height: 16),
              const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(height: 16),
              const Text(
                'Record Your Transaction',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),

              // Category Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      labelStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        _categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(color: Color(0xFF333333)),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value!;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? "Please select a category" : null,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF4CAF50),
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Amount Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) => value!.isEmpty ? "Enter an amount" : null,
                    onSaved: (value) => _amount = double.parse(value!),
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Type Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: "Type",
                      labelStyle: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        ["Income", "Expense"].map((String type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(color: Color(0xFF333333)),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => _type = value!),
                    validator:
                        (value) =>
                            value == null ? "Please select a type" : null,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF4CAF50),
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date Picker
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? "Select Date"
                            : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                        style: TextStyle(
                          color:
                              _selectedDate == null
                                  ? Colors.grey[600]
                                  : const Color(0xFF333333),
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF4CAF50),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null) {
                      _formKey.currentState!.save();

                      int result = await _databaseHelper.insertTransaction({
                        "category": _category,
                        "amount": _amount,
                        "type": _type,
                        "date": _selectedDate!.millisecondsSinceEpoch,
                      });

                      if (result > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Transaction added successfully!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Failed to add transaction',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red[400],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } else if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Please select a date',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red[400],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Add Transaction",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
