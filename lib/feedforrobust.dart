import 'package:flutter/material.dart';

class RobustGoatsFeed extends StatefulWidget {
  const RobustGoatsFeed({super.key});

  @override
  State<RobustGoatsFeed> createState() => _RobustGoatsFeedState();
}

class _RobustGoatsFeedState extends State<RobustGoatsFeed> {
  // Controllers for text fields
  final numberController = TextEditingController();
  final ageController = TextEditingController();
  String? selectedFeedType;
  String? selectedGoatType = 'Doe'; // Default value
  String? selectedWeightRange;

  // Weight ranges data
  final Map<String, List<String>> weightRanges = {
    'Doe': ['3-6 months', '6-12 months', '1-2 years', '2+ years'],
    'Buck': ['3-6 months', '6-12 months', '1-2 years', '2+ years'],
    'Lactating Does': ['55-80 kg (Standard)', '80-100 kg (Large Breed)'],
    'Buckling Kids': [' 0-3 weeks', '3-6 weeks', '6-8 weeks'],
    'Doeling Kids': [' 0-3 weeks', '3-6 weeks', '6-8 weeks'],
  };

  // Feed requirements data
  final Map<String, Map<String, List<String>>> feedRequirements = {
    'Doe': {
      'Alfalfa Hay': ['5.7'],
      'Grass Hay': ['3.2'],
      'Clover Hay': ['2.5'],
      'Oat Hay': ['3.3'],
      'Lucerne': ['2.8'],
      'Pasture Grasses': ['4.30'],
      'Corn Silage': ['3.1'],
      'Sorghum Silage': ['3.2'],
      'Legume Forages': ['2.6'],
      'Weeds and Browse': ['0.22'],
      'Corn': ['1.0'],
      'Barley': ['1.0'],
      'Wheat': ['1.0'],
      'Oats': ['1.0'],
      'Soybean Meal': ['0.5'],
      'Cottonseed Meal': ['0.5'],
      'Sunflower Seeds': ['0.4'],
      'Molasses': ['0.2'],
      'Bran (Wheat or Rice)': ['0.5'],
      'Commercial Goat Pellets': ['2.0'],
      'Salt Blocks': ['0.2'],
      'Mineral Blocks': ['0.2'],
      'Baking Soda': ['0.02'],
      'Bone Meal': ['0.03'],
      'Vitamin E and Selenium Supplements': ['As per vet advice'],
      'Outlier Boer Feed': [
        'Lucerne Hay + High-Protein Concentrate',
        '18-22% CP, Calcium-Phosphorus supplements',
      ],
    },
    'Lactating Does': {
      'Alfalfa Hay': ['6.0'],
      'Lucerne': ['3.0'],
      'Clover Hay': ['3.0'],
      'Oat Hay': ['3.5'],
      'Corn Silage': ['3.5'],
      'Sorghum Silage': ['3.5'],
      'Legume Forages': ['3.0'],
      'Soybean Meal': ['0.7'],
      'Cottonseed Meal': ['0.7'],
      'Sunflower Seeds': ['0.5'],
      'Molasses': ['0.3'],
      'Wheat Bran / Rice Bran': ['0.6'],
      'Commercial Goat Pellets': ['2.5'],
      'Salt Blocks': ['0.25'],
      'Mineral Blocks': ['0.25'],
      'Baking Soda': ['0.03'],
      'Vitamin E and Selenium Supplements': ['As per vet advice'],
      'Bone Meal': ['0.04'],
    },
    'Buck': {
      'Grass Hay': ['3.0'],
      'Oat Hay': ['3.1'],
      'Pasture Grasses': ['4.29'],
      'Barley': ['1.0'],
      'Sunflower Seeds': ['0.3'],
      'Mineral Blocks': ['0.19'],
      'Salt Blocks': ['0.19'],
      'Baking Soda': ['0.025'],
      'Vitamin E and Selenium Supplements': ['As per vet advice'],
      'Outlier Boer Feed': [
        'High-Energy Mix + Bypass Protein',
        '16-18% CP, L-Carnitine supplements',
      ],
    },
    'Buckling Kids': {
      '0-3 weeks': ['Colostrum', '0.7 L per feeding, 4 times daily'],
      '3-6 weeks': ['Milk + Alfalfa Hay', '1.0 L milk + 0.1 kg hay'],
      '6-8 weeks': [
        'Milk + Alfalfa Hay + Starter Feed',
        '0.5 L milk + 0.2 kg hay + 0.1 kg starter',
      ],
      '8+ weeks': ['Transition to Buck feed regimen'],
    },
    'Doeling Kids': {
      '0-3 weeks': ['Colostrum', '0.5 L per feeding, 4 times daily'],
      '3-6 weeks': ['Milk + Clover Hay', '1.2 L milk + 0.1 kg hay'],
      '6-8 weeks': [
        'Milk + Clover Hay + Starter Feed',
        '0.5 L milk + 0.2 kg hay + 0.1 kg starter',
      ],
      '8+ weeks': ['Transition to Doe feed regimen'],
    },
  };

  // Water requirements data
  final Map<String, String> waterRequirements = {
    'Doe': '10',
    'Buck': '9',
    'Lactating Does': '12',
    'Buckling Kids': '1.5',
    'Doeling Kids': '1.5',
  };

  @override
  void dispose() {
    numberController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Healthy Goats Feed Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 8,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.lightGreen[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with icon
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      size: 32,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Feed Calculation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Number of Goats input
                TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Number of Goats',
                    labelStyle: const TextStyle(color: Colors.green),
                    prefixIcon: const Icon(
                      Icons.format_list_numbered,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of goats';
                    }
                    final num = int.tryParse(value);
                    if (num == null || num <= 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

                // Age in weeks input (only for kids)
                if (selectedGoatType == 'Buckling Kids' ||
                    selectedGoatType == 'Doeling Kids')
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Age in Weeks',
                          labelStyle: const TextStyle(color: Colors.green),
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter age in weeks';
                          }
                          final weeks = int.tryParse(value);
                          if (weeks == null) {
                            return 'Please enter a valid number';
                          }
                          if (weeks <= 0) {
                            return 'Age must be greater than 0 weeks';
                          }
                          if (weeks < 1 &&
                              selectedWeightRange != null &&
                              selectedWeightRange!.contains('5 kg')) {
                            return 'Kids below 1 week cannot exceed 5kg';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                // Weight range dropdown (not for kids)
                if (selectedGoatType != 'Buckling Kids' &&
                    selectedGoatType != 'Doeling Kids' &&
                    selectedGoatType != null)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        hint: const Text('Select age range'),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedWeightRange = newValue;
                          });
                        },
                        value: selectedWeightRange,
                        decoration: InputDecoration(
                          labelText: 'Age Range',
                          labelStyle: const TextStyle(color: Colors.green),
                          prefixIcon: const Icon(
                            Icons.line_weight,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),

                        items:
                            weightRanges[selectedGoatType]!
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),
                // Goat Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedGoatType,
                  decoration: InputDecoration(
                    labelText: 'Goat Type',
                    labelStyle: const TextStyle(color: Colors.green),
                    prefixIcon: const Icon(Icons.pets, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                  hint: const Text('Select goat type'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGoatType = newValue;
                      selectedFeedType = null;
                      selectedWeightRange = null;
                      ageController.clear();
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'Doe', child: Text('Doe')),
                    DropdownMenuItem(
                      value: 'Lactating Does',
                      child: Text('Lactating Doe'),
                    ),
                    DropdownMenuItem(value: 'Buck', child: Text('Buck')),
                    DropdownMenuItem(
                      value: 'Buckling Kids',
                      child: Text('Buckling Kids'),
                    ),
                    DropdownMenuItem(
                      value: 'Doeling Kids',
                      child: Text('Doeling Kids '),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Feed Type Dropdown (dynamic based on goat type)
                if (selectedGoatType != null &&
                    selectedGoatType != 'Buckling Kids' &&
                    selectedGoatType != 'Doeling Kids')
                  DropdownButtonFormField<String>(
                    value: selectedFeedType,
                    decoration: InputDecoration(
                      labelText: 'Feed Type',
                      labelStyle: const TextStyle(color: Colors.green),
                      prefixIcon: const Icon(Icons.grass, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                    ),
                    hint: const Text('Select feed type'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFeedType = newValue;
                      });
                    },
                    items:
                        selectedGoatType != null
                            ? feedRequirements[selectedGoatType]!.keys
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList()
                            : [],
                  ),

                const SizedBox(height: 30),
                // Calculate Button
                ElevatedButton.icon(
                  onPressed: () {
                    _calculateRequirements(context);
                  },
                  icon: const Icon(Icons.calculate, size: 24),
                  label: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'CALCULATE REQUIREMENTS',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 15),
                // Back Button
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('BACK TO MENU', style: TextStyle(fontSize: 16)),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[700],
                    side: BorderSide(color: Colors.green[700]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateRequirements(BuildContext context) {
    final number = int.tryParse(numberController.text) ?? 0;
    final age = int.tryParse(ageController.text) ?? 0;
    final goatType = selectedGoatType;

    if (number <= 0) {
      _showErrorDialog(context, 'Please enter a valid number of goats');
      return;
    }

    if (goatType == null) {
      _showErrorDialog(context, 'Please select goat type');
      return;
    }

    // Validation for kids
    if (goatType == 'Buckling Kids' || goatType == 'Doeling Kids') {
      if (age <= 0) {
        _showErrorDialog(context, 'Please enter a valid age for kids');
        return;
      }

      if (age > 8) {
        _showInfoDialog(
          context,
          'Your ${goatType == 'Buckling Kids' ? 'buckling' : 'doeling'} is now ${age ~/ 4} months old and should be categorized as ${goatType == 'Buckling Kids' ? 'Buck' : 'Doe'}',
        );
        return;
      }

      String ageGroup;
      if (age <= 3) {
        ageGroup = '0-3 weeks';
      } else if (age <= 6)
        ageGroup = '3-6 weeks';
      else
        ageGroup = '6-8 weeks';

      final feedInfo = feedRequirements[goatType]![ageGroup]!;
      final waterReq = waterRequirements[goatType] ?? 'N/A';

      _showKidFeedDialog(
        context,
        ageGroup,
        feedInfo[0],
        feedInfo[1],
        waterReq,
        number,
      );
      return;
    }

    // Validation for adults
    if (selectedWeightRange == null) {
      _showErrorDialog(context, 'Please select age range');
      return;
    }

    final feedType = selectedFeedType;
    if (feedType == null) {
      _showErrorDialog(context, 'Please select feed type');
      return;
    }

    final feedRequirement = feedRequirements[goatType]?[feedType]?[0] ?? 'N/A';
    final waterRequirement = waterRequirements[goatType] ?? 'N/A';

    String totalFeed;
    if (feedRequirement == 'As per vet advice') {
      totalFeed = feedRequirement;
    } else if (feedType == 'Outlier Boer Feed') {
      totalFeed = feedRequirements[goatType]?[feedType]?.join('\n') ?? 'N/A';
    } else {
      totalFeed = _calculateTotal(feedRequirement, number);
    }

    final totalWater = _calculateTotal(waterRequirement, number);

    _showResultsDialog(
      context,
      feedRequirement,
      totalFeed,
      waterRequirement,
      totalWater,
      feedType,
      selectedWeightRange!,
      number,
    );
  }
}

String _calculateTotal(String requirement, int number) {
  if (requirement.contains('–')) {
    final range = requirement.split('–');
    final min = double.tryParse(range[0]) ?? 0;
    final max = double.tryParse(range[1]) ?? 0;
    return '${min * number}–${max * number}';
  }
  final value = double.tryParse(requirement) ?? 0;
  return (value * number).toStringAsFixed(2);
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Input Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
  );
}

void _showInfoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 10),
              Text('Information'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
  );
}

void _showResultsDialog(
  BuildContext context,
  String feedPerGoat,
  String totalFeed,
  String waterPerGoat,
  String totalWater,
  String feedType,
  String weightRange,
  int number,
) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.calculate, color: Colors.green),
              SizedBox(width: 10),
              Text('Feed Requirements'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Age Range: $weightRange',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 10),
              if (feedType == 'Outlier Boer Feed')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Special Feed Recommendation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(totalFeed.replaceAll(r'\n', '\n')),
                  ],
                )
              else ...[
                // Per goat requirements
                const Text(
                  'Per Goat:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.grass, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('$feedType: $feedPerGoat kg/day'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('Water: $waterPerGoat L/day'),
                  ],
                ),
                const SizedBox(height: 10),
                // Total requirements
                Text(
                  'Total feed for $number ${number == 1 ? 'goat' : 'goats'}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.grass, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '$feedType: $totalFeed kg/day',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Water: $totalWater L/day',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
  );
}

String _calculateKidMilk(String feedAmount, int number) {
  final parts = feedAmount.split(' ');
  final range =
      parts[0].contains('–') ? parts[0].split('–') : parts[0].split('-');

  final max = double.tryParse(range[1]) ?? 0;
  final times = int.tryParse(parts[4]) ?? 1;

  return '${max * number * times} L/day';
}

void _showKidFeedDialog(
  BuildContext context,
  String ageGroup,
  String feedType,
  String feedAmount,
  String waterAmount,
  int number,
) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.child_care, color: Colors.orange),
              SizedBox(width: 10),
              Text('Kid Feeding Guide'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Age Group: $ageGroup',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Per kid requirements
              const Text(
                'Per Kid:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text('Recommended Feed: $feedType'),
              Text('Amount: $feedAmount'),
              Text('Water: $waterAmount L/day'),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              // Total requirements
              Text(
                'For $number kids:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              if (feedType.contains('Milk'))
                Text('Total Milk: ${_calculateKidMilk(feedAmount, number)}'),
              if (feedType.contains('hay'))
                Text(
                  'Total Hay: ${_calculateKidFeed(feedAmount, 'hay', number)}',
                ),
              if (feedType.contains('starter'))
                Text(
                  'Total Starter: ${_calculateKidFeed(feedAmount, 'starter', number)}',
                ),
              Text(
                'Total Water: ${(double.tryParse(waterAmount) ?? 0) * number} L/day',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
  );
}

// Removed duplicate _calculateRequirements function to resolve conflict.

String _calculateKidFeed(String feedAmount, String type, int number) {
  final amount = feedAmount.split(' ')[0];
  final value = double.tryParse(amount) ?? 0;
  return '${value * number} kg/day';
}
