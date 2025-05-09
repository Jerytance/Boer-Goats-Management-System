import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:welcome/database_helper.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  int doeCount = 0;
  int buckCount = 0;

  int breederCount = 0;
  int pregnantCount = 0;
  int sickBoersCount = 0;
  int boersOnSaleCount = 0;
  int soldBoersCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Get counts from Boers table
    final doeResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM Boers WHERE goatType = ?',
      ['Doe'],
    );
    doeCount = doeResult.first['count'] as int;

    final buckResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM Boers WHERE goatType = ?',
      ['Buck'],
    );
    buckCount = buckResult.first['count'] as int;

    // Get counts from BoerBreeds table
    final breederResult = await db.rawQuery(
      'SELECT COUNT(DISTINCT doeId) as count FROM BoerBreeds',
    );
    breederCount = breederResult.first['count'] as int;

    final pregnantResult = await db.rawQuery(
      'SELECT COUNT(DISTINCT buckId) as count FROM BoerBreeds',
    );
    pregnantCount = pregnantResult.first['count'] as int;

    // Get counts from SickBoers table
    final sickBoersResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM SickBoers',
    );
    sickBoersCount = sickBoersResult.first['count'] as int;

    // Get counts from BoersonSale table
    final boersOnSaleResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM BoersonSale',
    );
    boersOnSaleCount = boersOnSaleResult.first['count'] as int;

    // Get counts from SoldBoers table
    final soldBoersResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM SoldBoers',
    );
    soldBoersCount = soldBoersResult.first['count'] as int;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAnimals =
        doeCount +
        buckCount +
        sickBoersCount +
        boersOnSaleCount +
        soldBoersCount +
        breederCount +
        pregnantCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goat Farm Report'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCounts),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goat Distribution Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height:
                  300, // Increased height for better bar graph visibility(Boss Jedza)
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY().toDouble(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8.0),
                      tooltipMargin: 8,
                      tooltipRoundedRadius: 4,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final category = _getCategories()[group.x.toInt()];
                        return BarTooltipItem(
                          '$category\n${rod.toY.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final category = _getCategories()[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval().toDouble(),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detailed Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatCard(
              context,
              'Total Animals',
              totalAnimals.toString(),
              Colors.blue,
              Icons.pets,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              //Boers types(Boss Jedza)
              children: [
                _buildMiniStatCard('Doe', doeCount, Colors.orange),
                _buildMiniStatCard('Buck', buckCount, Colors.green),
                _buildMiniStatCard('Breeder', breederCount, Colors.purple),
                _buildMiniStatCard('Pregnant', pregnantCount, Colors.pink),
                _buildMiniStatCard('Sick Boers', sickBoersCount, Colors.red),
                _buildMiniStatCard(
                  'Boers on Sale',
                  boersOnSaleCount,
                  Colors.teal,
                ),
                _buildMiniStatCard('Sold Boers', soldBoersCount, Colors.brown),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back, size: 20),
                label: const Text('BACK TO DASHBOARD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // List of categories for the bar chart (Boss Jedza)
  List<String> _getCategories() {
    return ['Doe', 'Buck', 'Breeder', 'Pregnant', 'Sick', 'For Sale', 'Sold'];
  }

  // Build bar groups for the bar chart (Boss Jedza)
  List<BarChartGroupData> _buildBarGroups() {
    final List<int> counts = [
      doeCount,
      buckCount,
      breederCount,
      pregnantCount,
      sickBoersCount,
      boersOnSaleCount,
      soldBoersCount,
    ];

    // List of colors for the bars (Boss Jedza)
    final List<Color> colors = [
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.teal,
      Colors.brown,
    ];

    // Generate bar groups based on the counts and colors (Boss Jedza)
    return List.generate(counts.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: counts[index].toDouble(),
            color: colors[index],
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  // Calculate the maximum Y value for the bar chart (Boss Jedza)
  // Ensures that the chart is scaled appropriately (Boss Jedza)
  int _calculateMaxY() {
    final counts = [
      doeCount,
      buckCount,
      breederCount,
      pregnantCount,
      sickBoersCount,
      boersOnSaleCount,
      soldBoersCount,
    ];

    // Find the maximum count from the list (Boss Jedza)
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    // Round up to nearest 5 for better Y axis scaling
    return ((maxCount / 5).ceil() * 5) + 5;
  }

  // Calculate the interval for the Y axis based on the maximum value (Boss Jedza)
  int _calculateInterval() {
    final maxY = _calculateMaxY();
    // Calculate a reasonable interval based on the max value
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 20;
  }

  // Build a stat card for the detailed statistics (Boss Jedza)
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a mini stat card for the detailed statistics (Boss Jedza)
  Widget _buildMiniStatCard(String title, int value, Color color) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
