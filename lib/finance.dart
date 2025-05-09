import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:welcome/addtransaction.dart';
import 'package:welcome/database_helper.dart';

class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  String selectedFilter = "Last 30 Days";
  String selectedTab = "All"; // "Income" or "Expense"
  String? selectedCategory; // Track selected category
  String searchQuery = "";
  DateTime? startDate;
  DateTime? endDate;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transactions = [];
  double _totalGoatSales = 0.0;

  final List<String> categories = [
    'Milk Sales',
    'Feed Purchase',
    'Veterinary',
    'Goat Sales',
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadTransactions();
    await _loadGoatSales();
  }

  Future<void> _loadTransactions() async {
    List<Map<String, dynamic>> fetchedTransactions = await _databaseHelper
        .getTransactions(
          type: selectedTab == 'All' ? null : selectedTab,
          category:
              selectedCategory == 'All Categories' || selectedCategory == null
                  ? null
                  : selectedCategory,
          startDate: startDate,
          endDate: endDate,
        );
    setState(() {
      _transactions = fetchedTransactions;
    });
  }

  Future<void> _loadGoatSales() async {
    List<Map<String, dynamic>> soldGoats = await _databaseHelper.getSoldGoats();
    double total = 0.0;

    for (var goat in soldGoats) {
      try {
        double price = double.tryParse(goat['price'] ?? '0') ?? 0;
        total += price;
      } catch (e) {
        print('Error parsing goat price: $e');
      }
    }

    setState(() {
      _totalGoatSales = total;
    });
  }

  List<Map<String, dynamic>> get filteredTransactions {
    return _transactions.where((transaction) {
      // Already filtered by the _loadTransactions method
      return true;
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange:
          startDate != null && endDate != null
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate income from transactions (excluding goat sales)
    double transactionIncome = _transactions
        .where(
          (transaction) =>
              transaction["type"] == "Income" &&
              transaction["category"] != "Goat Sales",
        )
        .fold<double>(
          0,
          (sum, item) => sum + (item["amount"] as num).toDouble(),
        );

    // Include goat sales in total income
    double totalIncome = transactionIncome + _totalGoatSales;

    double totalExpenses = _transactions
        .where((transaction) => transaction["type"] == "Expense")
        .fold<double>(
          0,
          (sum, item) => sum + (item["amount"] as num).toDouble(),
        );

    double netBalance = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text("Income/Expenses"),
        backgroundColor: Colors.blue[800],
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
            label: Text("Back", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Date Filter Row - Updated version
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    // Category Dropdown - made flexible
                    Flexible(
                      flex: 2, // Gives more space to dropdown
                      child: DropdownButtonFormField<String>(
                        isExpanded: true, // Important to prevent overflow
                        value: selectedCategory,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Select category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text("All Categories"),
                          ),
                          ...categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                category,
                                overflow:
                                    TextOverflow.ellipsis, // Handle long text
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          _loadTransactions();
                        },
                      ),
                    ),
                    SizedBox(width: 8), // Reduced spacing
                    // Date Picker Button - made flexible
                    Flexible(
                      flex: 1, // Takes less space than dropdown
                      child: SizedBox(
                        // Constrains the button width
                        width: double.infinity, // Expands to available space
                        child: ElevatedButton.icon(
                          onPressed: () => _selectDateRange(context),
                          icon: Icon(Icons.date_range),
                          label: FittedBox(
                            // Scales down text if needed
                            fit: BoxFit.scaleDown,
                            child: Text(
                              startDate != null && endDate != null
                                  ? "${intl.DateFormat('dd/MM/yyyy').format(startDate!)} - ${intl.DateFormat('dd/MM/yyyy').format(endDate!)}"
                                  : "Date Range",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Summary Cards
          Card(
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      "Goat Sales",
                      _totalGoatSales.toInt(),
                      Colors.green,
                    ),
                    _buildStatCard(
                      "Other Income",
                      transactionIncome.toInt(),
                      Colors.green,
                    ),
                    _buildStatCard(
                      "Total Expenses",
                      totalExpenses.toInt(),
                      Colors.red,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildStatCard(
                    "Net Balance",
                    netBalance.toInt(),
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Tabs for filtering transactions
          Card(
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  ["All", "Income", "Expense"].map((tab) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = tab;
                        });
                        _loadTransactions();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  selectedTab == tab
                                      ? Colors.blue
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                selectedTab == tab
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Transactions List
          Expanded(
            child:
                filteredTransactions.isEmpty
                    ? Center(child: Text("No Records found"))
                    : ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        var transaction = filteredTransactions[index];
                        return ListTile(
                          title: Text(transaction["category"]),
                          subtitle: Text(
                            "${transaction["type"]} - ${intl.DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(transaction["date"]))}",
                          ),
                          trailing: Text(
                            "\$${transaction["amount"].toStringAsFixed(2)}",
                            style: TextStyle(
                              color:
                                  transaction["type"] == "Income"
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
          ),

          // Added BACK button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text(
                'Back',
                style: TextStyle(
                  fontStyle: FontStyle.italic, // Button text in italic
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );

          if (result != null && result == true) {
            _loadTransactions(); // Reload transactions after adding
          }
        },
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget _buildStatCard(String title, int amount, Color color) {
  return Column(
    children: [
      Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      Text(
        "\$$amount",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
