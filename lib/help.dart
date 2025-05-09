import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BoerGoatGuide extends StatelessWidget {
  const BoerGoatGuide({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boer Goat Expert Guide'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[800],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _makePhoneCall('+263719357497'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildSection(
                icon: Icons.history,
                title: 'Origin and History',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      'Development',
                      'Systematically developed in early 1900s by South African farmers through crossing indigenous African goats with European and Indian breeds',
                    ),
                    _buildTimelineCard('Historical Milestones', [
                      '1959: First breed standards established',
                      '1977: First exports to Germany',
                      '1993: Introduced to United States',
                    ]),
                  ],
                ),
              ),
              _buildSection(
                icon: Icons.public,
                title: 'Global Distribution',
                content: Column(
                  children: [
                    _buildDataTable(
                      'Primary Production Regions',
                      ['Country', 'Details'],
                      [
                        [
                          'United States',
                          'Texas, Oklahoma, Tennessee\nPopulation: 1M+ purebred',
                        ],
                        ['Australia', 'Arid regions\nGrowing SE Asia exports'],
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Climate Adaptability',
                      'Optimal range: 10-30°C (50-86°F)\nCold: Need windbreaks below -5°C\nHeat: Require shade and extra water',
                    ),
                  ],
                ),
              ),
              _buildSection(
                icon: Icons.restaurant,
                title: 'Meat Production',
                content: Column(
                  children: [
                    _buildDataTable(
                      'Carcass Characteristics',
                      ['Metric', 'Value'],
                      [
                        ['Dressing %', '50-60%'],
                        ['Meat-to-bone', '4:1'],
                        ['Loin eye area', '5-7 cm²'],
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDataTable(
                      'Nutritional Profile',
                      ['Nutrient', 'Content'],
                      [
                        ['Protein', '20-22%'],
                        ['Fat', '3-5%'],
                        ['Iron', '3.5 mg/100g'],
                      ],
                    ),
                  ],
                ),
              ),
              _buildSection(
                icon: Icons.compare,
                title: 'Breed Comparison',
                content: _buildComparisonTable(),
              ),
              _buildSection(
                icon: Icons.architecture,
                title: 'Physical Characteristics',
                content: Column(
                  children: [
                    _buildInfoCard(
                      'Ideal Standards',
                      'Head: Roman nose\nNeck: Well-muscled\nForequarters: Broad chest\nBarrel: Deep rib cage\nHindquarters: Square and full',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Coat Color Genetics',
                      'Traditional: White body (dominant) with red head (recessive)\nVariants: Paint (spotted), Black, Dappled',
                    ),
                  ],
                ),
              ),
              _buildSection(
                icon: Icons.psychology,
                title: 'Behavior & Temperament',
                content: _buildBehaviorContent(),
              ),
              _buildSection(
                icon: Icons.home,
                title: 'Housing & Management',
                content: _buildHousingContent(),
              ),
              _buildSection(
                icon: Icons.grass,
                title: 'Feeding Requirements',
                content: _buildFeedingContent(),
              ),
              _buildSection(
                icon: Icons.medical_services,
                title: 'Health Management',
                content: _buildHealthContent(),
              ),
              _buildSection(
                icon: Icons.family_restroom,
                title: 'Breeding & Reproduction',
                content: _buildBreedingContent(),
              ),
              _buildSection(
                icon: Icons.attach_money,
                title: 'Economics',
                content: _buildEconomicsContent(),
              ),
              const SizedBox(height: 24),
              _buildContactButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange[700]!, Colors.deepOrange[500]!],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Boer Goats',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The premier meat goat breed with superior growth rates, carcass quality, and adaptability',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.agriculture,
              size: 60,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.deepOrange[800], size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(String title, List<String> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[800],
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, right: 8),
                            child: Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.deepOrange[600],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(
    String title,
    List<String> headers,
    List<List<String>> rows,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[800],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns:
                    headers
                        .map(
                          (header) => DataColumn(
                            label: Text(
                              header,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange[700],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                rows:
                    rows
                        .map(
                          (row) => DataRow(
                            cells:
                                row
                                    .map(
                                      (cell) => DataCell(
                                        Text(
                                          cell,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        )
                        .toList(),
                dataRowHeight: 60,
                headingRowHeight: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meat Goat Breed Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Characteristic')),
                  DataColumn(label: Text('Boer')),
                  DataColumn(label: Text('Kiko')),
                  DataColumn(label: Text('Spanish')),
                  DataColumn(label: Text('Savanna')),
                ],
                rows: [
                  _buildComparisonRow('Origin', [
                    'South Africa',
                    'New Zealand',
                    'United States',
                    'South Africa',
                  ]),
                  _buildComparisonRow('Mature Buck Weight', [
                    '110-135 kg',
                    '70-90 kg',
                    '60-80 kg',
                    '100-120 kg',
                  ]),
                  _buildComparisonRow('Dressing %', [
                    '50-60%',
                    '45-50%',
                    '40-45%',
                    '50-55%',
                  ]),
                  _buildComparisonRow('Twinning Rate', [
                    '180-200%',
                    '160-180%',
                    '140-160%',
                    '170-190%',
                  ]),
                  _buildComparisonRow('Feed Efficiency', [
                    '4:1',
                    '5:1',
                    '6:1',
                    '4.5:1',
                  ]),
                  _buildComparisonRow('Adaptability', [
                    'High',
                    'Very High',
                    'Moderate',
                    'High',
                  ]),
                  _buildComparisonRow('Market Preference', [
                    'Premium',
                    'Commercial',
                    'Niche',
                    'Premium',
                  ]),
                ],
                dataRowHeight: 50,
                headingRowHeight: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildComparisonRow(String characteristic, List<String> values) {
    return DataRow(
      cells: [
        DataCell(Text(characteristic)),
        DataCell(
          Text(
            values[0],
            style: TextStyle(
              color: Colors.deepOrange[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(Text(values[1])),
        DataCell(Text(values[2])),
        DataCell(Text(values[3])),
      ],
    );
  }

  Widget _buildBehaviorContent() {
    return Column(
      children: [
        _buildInfoCard(
          'Social Hierarchy',
          'Linear dominance structure\nBucks establish hierarchy through:\n- Head-butting\n- Scent marking\n- Urine spraying',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'Grazing Behavior',
          'Preference: Browse > Forbs > Grasses\nDaily intake: 3-5% of body weight\nRotational grazing recommended',
        ),
      ],
    );
  }

  Widget _buildHousingContent() {
    return Column(
      children: [
        _buildInfoCard(
          'Shelter Design',
          'Ventilation:\n- 4-6 air exchanges/hour in winter\n- Ridge vents: 5cm per 3m building\n- Sidewall openings: 30-50% in heat',
        ),
        const SizedBox(height: 12),
        _buildDataTable(
          'Space Requirements',
          ['Age Group', 'Indoor (sq ft)', 'Outdoor (sq ft)'],
          [
            ['Adult Doe', '15-20', '200-300'],
            ['Buck', '20-25', '300-400'],
            ['Weanling', '8-10', '100-150'],
            ['Pregnant Doe', '25-30', '250-350'],
          ],
        ),
      ],
    );
  }

  Widget _buildFeedingContent() {
    return Column(
      children: [
        _buildDataTable(
          'Forage Nutritional Values',
          ['Forage', 'CP%', 'TDN%'],
          [
            ['Alfalfa Hay', '18-22', '60-65'],
            ['Bermuda Grass', '8-12', '55-58'],
            ['Clover Mix', '14-18', '58-62'],
            ['Browse Plants', '10-15', '50-55'],
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'Concentrate Formulation',
          'Growth Ration (16% CP):\n- Corn: 50%\n- Soybean Meal: 25%\n- Wheat Midds: 15%\n- Molasses: 5%\n- Mineral Premix: 5%',
        ),
      ],
    );
  }

  Widget _buildHealthContent() {
    return Column(
      children: [
        _buildDataTable(
          'Vaccination Protocol',
          ['Vaccine', 'Primary', 'Boosters'],
          [
            ['CD&T', '4,6,8 wks', 'Annual'],
            ['Rabies', '12 wks', '1-3 yrs'],
            ['Pneumonia', '8 wks', '6 mo'],
            ['Foot Rot', '2 mo', 'Annual'],
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          'Parasite Control',
          'FAMACHA Scoring:\n1 (Red) - No anemia\n5 (White) - Severe anemia\nTreat only 3-5 scores\nRotate drug classes',
        ),
      ],
    );
  }

  Widget _buildBreedingContent() {
    return Column(
      children: [
        _buildInfoCard(
          'Breeding Stock Selection',
          'Key Parameters:\n- Growth rate: 200-300g/day\n- Carcass yield: 55%+\n- Kidding rate: 180%+\nStructural evaluation essential',
        ),
        const SizedBox(height: 12),
        _buildDataTable(
          'Reproductive Technology',
          ['Method', 'Conception Rate'],
          [
            ['Natural Breeding', '85-95%'],
            ['Fresh Semen AI', '70-80%'],
            ['Frozen Semen AI', '50-60%'],
            ['Laparoscopic AI', '75-85%'],
          ],
        ),
      ],
    );
  }

  Widget _buildEconomicsContent() {
    return Column(
      children: [
        _buildDataTable(
          '100-Doe Operation Costs',
          ['Category', 'Annual Cost'],
          [
            ['Feed', '\$18,000'],
            ['Veterinary', '\$3,500'],
            ['Labor', '\$24,000'],
            ['Facilities', '\$5,000'],
            ['Marketing', '\$2,500'],
            ['Total Costs', '\$53,000'],
          ],
        ),
        const SizedBox(height: 12),
        _buildDataTable(
          'Revenue Streams',
          ['Source', 'Amount'],
          [
            ['Kid Sales (200 @ \$200)', '\$40,000'],
            ['Breeding Stock (20 @ \$500)', '\$10,000'],
            ['Meat Sales (5,000 lbs @ \$6)', '\$30,000'],
            ['Total Revenue', '\$80,000'],
            ['Net Profit', '\$27,000 (34%)'],
          ],
        ),
      ],
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Need expert advice on Boer goat farming?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () => _makePhoneCall('+263719357497'),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.call),
                SizedBox(width: 8),
                Text('Contact Goat Expert', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
