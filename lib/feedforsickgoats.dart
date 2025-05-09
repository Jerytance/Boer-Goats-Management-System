import 'package:flutter/material.dart';

class FeedForSickGoats extends StatelessWidget {
  const FeedForSickGoats({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sick Goats Feed Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SickGoatsFeedScreen(),
    );
  }
}

class SickGoatsFeedScreen extends StatefulWidget {
  const SickGoatsFeedScreen({super.key});

  @override
  State<SickGoatsFeedScreen> createState() => _SickGoatsFeedScreenState();
}

class _SickGoatsFeedScreenState extends State<SickGoatsFeedScreen> {
  final TextEditingController _numberController = TextEditingController();
  String? _selectedGoatType;
  String? _selectedSymptom;
  String? _selectedWeightRange;
  String? _selectedAgeRange;

  // Symptoms data organized by goat type
  final Map<String, List<String>> _symptomsByType = {
    'Doe': [
      'Diarrhea',
      'Loss of Appetite',
      'Lethargy',
      'Coughing',
      'Bloating',
      'Weight Loss',
      'Fever',
      'Nasal Discharge',
      'Mastitis',
      'Abortion',
    ],
    'Buck': [
      'Diarrhea',
      'Loss of Appetite',
      'Lethargy',
      'Coughing',
      'Bloating',
      'Weight Loss',
      'Fever',
      'Urinary Calculi',
      'Lameness',
      'Skin Lesions',
    ],
    'Lactating Doe': [
      'Diarrhea',
      'Loss of Appetite',
      'Lethargy',
      'Mastitis',
      'Reduced Milk Production',
      'Weight Loss',
      'Fever',
      'Ketosis',
      'Milk Fever',
      'Abortion',
    ],
    'Doeling': [
      'Diarrhea',
      'Loss of Appetite',
      'Lethargy',
      'Coughing',
      'Bloating',
      'Failure to Thrive',
      'Fever',
      'Pneumonia',
      'Joint Ill',
      'Coccidiosis',
    ],
    'Buckling': [
      'Diarrhea',
      'Loss of Appetite',
      'Lethargy',
      'Coughing',
      'Bloating',
      'Failure to Thrive',
      'Fever',
      'Pneumonia',
      'Joint Ill',
      'Coccidiosis',
    ],
  };

  // Weight ranges for adult goats
  final Map<String, List<String>> _weightRanges = {
    'Doe': [
      '20-35 kg (3-6 months)',
      '35-55 kg (6-12 months)',
      '55-80 kg (1-2 years)',
      '70-100 kg (2+ years)',
    ],
    'Buck': [
      '25-45 kg (3-6 months)',
      '45-70 kg (6-12 months)',
      '70-100 kg (1-2 years)',
      '90-135 kg (2+ years)',
    ],
    'Lactating Doe': ['55-80 kg (Standard)', '80-100 kg (Large Breed)'],
  };

  // Age ranges for kids
  final List<String> _ageRanges = [
    '0-3 weeks',
    '3-6 weeks',
    '6-8 weeks',
    '8+ weeks',
  ];

  // Disease diagnosis based on symptoms
  final Map<String, String> _diseaseDiagnosis = {
    'Diarrhea': 'Possible Coccidiosis or Parasites',
    'Loss of Appetite': 'Possible Digestive Issues or Infection',
    'Lethargy': 'Possible Anemia or Systemic Illness',
    'Coughing': 'Possible Respiratory Infection',
    'Bloating': 'Possible Bloat or Digestive Disorder',
    'Weight Loss': 'Possible Parasites or Chronic Disease',
    'Failure to Thrive': 'Possible Nutritional Deficiency or Parasites',
    'Fever': 'Possible Bacterial or Viral Infection',
    'Lameness': 'Possible Foot Rot or Injury',
    'Nasal Discharge': 'Possible Respiratory Infection',
    'Skin Lesions': 'Possible Mange or Fungal Infection',
    'Mastitis': 'Mammary Gland Infection',
    'Abortion': 'Possible Infectious Cause (e.g., Brucellosis)',
    'Urinary Calculi': 'Urinary Stones',
    'Reduced Milk Production': 'Possible Nutritional Deficiency or Stress',
    'Ketosis': 'Pregnancy Toxemia',
    'Milk Fever': 'Hypocalcemia',
    'Pneumonia': 'Respiratory Infection',
    'Joint Ill': 'Bacterial Infection (Arthritis)',
    'Coccidiosis': 'Parasitic Infection of Intestines',
  };

  // Complete feed recommendations for all symptoms
  final Map<String, Map<String, Map<String, List<String>>>>
  _feedRecommendations = {
    'Doe': {
      'Diarrhea': {
        '20-35 kg (3-6 months)': [
          'Electrolyte Solution',
          'High-Quality Hay',
          '0.7',
          '1.7',
        ],
        '35-55 kg (6-12 months)': [
          'Electrolyte Solution',
          'High-Quality Hay',
          '1.5',
          '2.5',
        ],
        '55-80 kg (1-2 years)': [
          'Electrolyte Solution',
          'High-Quality Hay + Probiotics',
          '2.0',
          '3.0',
        ],
        '70-100 kg (2+ years)': [
          'Electrolyte Solution',
          'High-Quality Hay + Probiotics',
          '2.5',
          '3.5',
        ],
      },
      'Loss of Appetite': {
        '20-35 kg (3-6 months)': [
          'Molasses Water',
          'Fresh Tender Leaves',
          '0.7',
          '1.4',
        ],
        '35-55 kg (6-12 months)': [
          'Molasses Water',
          'Fresh Tender Leaves',
          '1.2',
          '1.7',
        ],
        '55-80 kg (1-2 years)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain Mix',
          '2.0',
          '2.5',
        ],
        '70-100 kg (2+ years)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain Mix',
          '2.5',
          '3.0',
        ],
      },
      'Lethargy': {
        '20-35 kg (3-6 months)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa',
          '1.0',
          '2.0',
        ],
        '35-55 kg (6-12 months)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa',
          '1.5',
          '2.5',
        ],
        '55-80 kg (1-2 years)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '2.0',
          '2.7',
        ],
        '70-100 kg (2+ years)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '2.5',
          '3..5',
        ],
      },
      'Coughing': {
        '20-35 kg (3-6 months)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay',
          '0.7',
          '1.7',
        ],
        '35-55 kg (6-12 months)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay',
          '1.5',
          '2.5',
        ],
        '55-80 kg (1-2 years)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay + Grain',
          '1.7',
          '2.6',
        ],
        '70-100 kg (2+ years)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay + Grain',
          '2.5',
          '3.5',
        ],
      },
      'Bloating': {
        '20-35 kg (3-6 months)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '0.7',
          '1.5',
        ],
        '35-55 kg (6-12 months)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '1.5',
          '1.9',
        ],
        '55-80 kg (1-2 years)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '1.8',
          '2.5',
        ],
        '70-100 kg (2+ years)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '2.5',
          '3.0',
        ],
      },
      'Weight Loss': {
        '20-35 kg (3-6 months)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage',
          '0.70',
          '1.57',
        ],
        '35-55 kg (6-12 months)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage',
          '1.5',
          '2.5',
        ],
        '55-80 kg (1-2 years)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '2.0',
          '3.0',
        ],
        '70-100 kg (2+ years)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '2.5',
          '3.5',
        ],
      },
      'Fever': {
        '20-35 kg (3-6 months)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '1.0',
          '1.5',
        ],
        '35-55 kg (6-12 months)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '1.5',
          '2.0',
        ],
        '55-80 kg (1-2 years)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '2.0',
          '2.5',
        ],
        '70-100 kg (2+ years)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '2.5',
          '3.0',
        ],
      },
      'Nasal Discharge': {
        '20-35 kg (3-6 months)': [
          'Warm Herbal Tea',
          'High-Quality Hay',
          '1.0',
          '2.0',
        ],
        '35-55 kg (6-12 months)': [
          'Warm Herbal Tea',
          'High-Quality Hay',
          '1.5',
          '2.5',
        ],
        '55-80 kg (1-2 years)': [
          'Warm Herbal Tea',
          'High-Quality Hay + Grain',
          '2.0',
          '3.0',
        ],
        '70-100 kg (2+ years)': [
          'Warm Herbal Tea',
          'High-Quality Hay + Grain',
          '2.5',
          '3.5',
        ],
      },
      'Mastitis': {
        '20-35 kg (3-6 months)': [
          'Warm Compress',
          'Anti-inflammatory Herbs',
          '1.0',
          '1.5',
        ],
        '35-55 kg (6-12 months)': [
          'Warm Compress',
          'Anti-inflammatory Herbs',
          '1.5',
          '2.0',
        ],
        '55-80 kg (1-2 years)': [
          'Warm Compress',
          'Anti-inflammatory Herbs + Grain Mix',
          '2.0',
          '2.5',
        ],
        '70-100 kg (2+ years)': [
          'Warm Compress',
          'Anti-inflammatory Herbs + Grain Mix',
          '2.5',
          '3.0',
        ],
      },
      'Abortion': {
        '20-35 kg (3-6 months)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage',
          '1.0',
          '1.5',
        ],
        '35-55 kg (6-12 months)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage',
          '1.5',
          '2.0',
        ],
        '55-80 kg (1-2 years)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage + Grain',
          '2.0',
          '2.5',
        ],
        '70-100 kg (2+ years)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage + Grain',
          '2.5',
          '3.0',
        ],
      },
    },
    'Buck': {
      'Diarrhea': {
        '25-45 kg (3-6 months)': [
          'Electrolyte Solution',
          'High-Quality Hay',
          '1.0',
          '2.0',
        ],
        '45-70 kg (6-12 months)': [
          'Electrolyte Solution',
          'High-Quality Hay',
          '1.5',
          '2.5',
        ],
        '70-100 kg (1-2 years)': [
          'Electrolyte Solution',
          'High-Quality Hay + Probiotics',
          '2.0',
          '3.0',
        ],
        '90-135 kg (2+ years)': [
          'Electrolyte Solution',
          'High-Quality Hay + Probiotics',
          '2.5',
          '3.0',
        ],
      },
      'Loss of Appetite': {
        '25-45 kg (3-6 months)': [
          'Molasses Water',
          'Fresh Tender Leaves',
          '0.5',
          '1.5',
        ],
        '45-70 kg (6-12 months)': [
          'Molasses Water',
          'Fresh Tender Leaves',
          '1.5',
          '2.5',
        ],
        '70-100 kg (1-2 years)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain Mix',
          '1.5',
          '3.0',
        ],
        '90-135 kg (2+ years)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain Mix',
          '2.0',
          '3.0',
        ],
      },
      'Lethargy': {
        '25-45 kg (3-6 months)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa',
          '0.5',
          '2.0',
        ],
        '45-70 kg (6-12 months)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa',
          '1.5',
          '2.5',
        ],
        '70-100 kg (1-2 years)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '1.5',
          '2.5',
        ],
        '90-135 kg (2+ years)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '2.0',
          '3.0',
        ],
      },
      'Coughing': {
        '25-45 kg (3-6 months)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay',
          '0.5',
          '1.5',
        ],
        '45-70 kg (6-12 months)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay',
          '1.0',
          '2.0',
        ],
        '70-100 kg (1-2 years)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay + Grain',
          '1.5',
          '2.5',
        ],
        '90-135 kg (2+ years)': [
          'Herbal Tea (Thyme, Mint)',
          'High-Quality Hay + Grain',
          '2.0',
          '3.0',
        ],
      },
      'Bloating': {
        '25-45 kg (3-6 months)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '0.5',
          '1.5',
        ],
        '45-70 kg (6-12 months)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '1.0',
          '2.0',
        ],
        '70-100 kg (1-2 years)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '1.5',
          '2.5',
        ],
        '90-135 kg (2+ years)': [
          'Baking Soda Solution',
          'Limited High-Quality Hay',
          '2.0',
          '3.0',
        ],
      },
      'Weight Loss': {
        '25-45 kg (3-6 months)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage',
          '0.5',
          '1.5',
        ],
        '45-70 kg (6-12 months)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage',
          '1.0',
          '2.0',
        ],
        '70-100 kg (1-2 years)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '1.5',
          '2.5',
        ],
        '90-135 kg (2+ years)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '2.0',
          '3.0',
        ],
      },
      'Fever': {
        '25-45 kg (3-6 months)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '0.5',
          '1.5',
        ],
        '45-70 kg (6-12 months)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '1.0',
          '2.0',
        ],
        '70-100 kg (1-2 years)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '1.5',
          '2.5',
        ],
        '90-135 kg (2+ years)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '2.0',
          '3.0',
        ],
      },
      'Urinary Calculi': {
        '25-45 kg (3-6 months)': [
          'Ammonium Chloride Solution',
          'Low-Calcium Forage',
          '1.0',
          '1.0',
        ],
        '45-70 kg (6-12 months)': [
          'Ammonium Chloride Solution',
          'Low-Calcium Forage',
          '1.5',
          '1.5',
        ],
        '70-100 kg (1-2 years)': [
          'Ammonium Chloride Solution',
          'Low-Calcium Forage + Grain Mix',
          '2.0',
          '2.0',
        ],
        '90-135 kg (2+ years)': [
          'Ammonium Chloride Solution',
          'Low-Calcium Forage + Grain Mix',
          '2.5',
          '3.0',
        ],
      },
      'Lameness': {
        '25-45 kg (3-6 months)': [
          'Anti-inflammatory Solution',
          'High-Quality Forage',
          '0.7',
          '2.0',
        ],
        '45-70 kg (6-12 months)': [
          'Anti-inflammatory Solution',
          'High-Quality Forage',
          '1.5',
          '2.5',
        ],
        '70-100 kg (1-2 years)': [
          'Anti-inflammatory Solution',
          'High-Quality Forage + Grain',
          '2.0',
          '3.0',
        ],
        '90-135 kg (2+ years)': [
          'Anti-inflammatory Solution',
          'High-Quality Forage + Grain',
          '2.5',
          '3.0',
        ],
      },

      'Skin Lesions': {
        '25-45 kg (3-6 months)': [
          'Hydrating Solution',
          'High-Protein Forage',
          '1.0',
          '2.0',
        ],
        '45-70 kg (6-12 months)': [
          'Hydrating Solution',
          'High-Protein Forage',
          '1.5',
          '2.5',
        ],
        '70-100 kg (1-2 years)': [
          'Hydrating Solution',
          'High-Protein Forage + Grain',
          '1.5',
          '-3.0',
        ],
        '90-135 kg (2+ years)': [
          'Hydrating Solution',
          'High-Protein Forage + Grain',
          '2.0',
          '3.5',
        ],
      },
    },
    'Lactating Doe': {
      'Diarrhea': {
        '55-80 kg (Standard)': [
          'Electrolyte Solution',
          'High-Quality Alfalfa + Probiotics',
          '2.5',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'Electrolyte Solution',
          'High-Quality Alfalfa + Probiotics',
          '3.0',
          '4.0',
        ],
      },
      'Loss of Appetite': {
        '55-80 kg (Standard)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain',
          '2.0',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'Molasses Water',
          'Fresh Tender Leaves + Grain',
          '2.5',
          '4.0',
        ],
      },
      'Lethargy': {
        '55-80 kg (Standard)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '2.5',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'Energy Booster Solution',
          'High-Quality Alfalfa + Grain',
          '2.5',
          '3.5',
        ],
      },
      'Mastitis': {
        '55-80 kg (Standard)': [
          'Warm Compress',
          'High-Quality Alfalfa + Anti-inflammatory Herbs',
          '2.0',
          '3.0',
        ],
        '80-100 kg (Large Breed)': [
          'Warm Compress',
          'High-Quality Alfalfa + Anti-inflammatory Herbs',
          '2.5',
          '3.5',
        ],
      },
      'Reduced Milk Production': {
        '55-80 kg (Standard)': [
          'High-Protein Liquid Feed',
          'High-Quality Alfalfa + Grain',
          '2.0',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'High-Protein Liquid Feed',
          'High-Quality Alfalfa + Grain',
          '3.0',
          '4.0',
        ],
      },
      'Weight Loss': {
        '55-80 kg (Standard)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '2.0',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'High-Energy Liquid Feed',
          'High-Protein Forage + Grain',
          '3.0',
          '4.0',
        ],
      },
      'Fever': {
        '55-80 kg (Standard)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '2.5',
          '3.9',
        ],
        '80-100 kg (Large Breed)': [
          'Cool Water with Electrolytes',
          'Easy-to-Digest Forage',
          '3.0',
          '3.5',
        ],
      },
      'Ketosis': {
        '55-80 kg (Standard)': [
          'Propylene Glycol Solution',
          'High-Quality Alfalfa + Grain',
          '2.0',
          '3.5',
        ],
        '80-100 kg (Large Breed)': [
          'Propylene Glycol Solution',
          'High-Quality Alfalfa + Grain',
          '2.5',
          '4.0',
        ],
      },
      'Milk Fever': {
        '55-80 kg (Standard)': [
          'Calcium Solution',
          'High-Quality Alfalfa',
          '2.0',
          '3.0',
        ],
        '80-100 kg (Large Breed)': [
          'Calcium Solution',
          'High-Quality Alfalfa',
          '2.5',
          '3.5',
        ],
      },
      'Abortion': {
        '55-80 kg (Standard)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage + Grain',
          '2.5',
          '2.5',
        ],
        '80-100 kg (Large Breed)': [
          'Nutrient-Rich Liquid',
          'High-Quality Forage + Grain',
          '2.0',
          '3.5',
        ],
      },
    },
    'Doeling': {
      'Diarrhea': {
        '0-3 weeks': [
          'Electrolyte Solution',
          'Milk with Probiotics',
          '0.5',
          '5',
        ],
        '3-6 weeks': [
          'Electrolyte Solution',
          'Milk + Tender Leaves',
          '0.8',
          '4',
        ],
        '6-8 weeks': [
          'Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '2',
        ],
        '8+ weeks': [
          'Electrolyte Solution',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Loss of Appetite': {
        '0-3 weeks': [
          'Warm Molasses Water',
          'Milk with Appetite Stimulant',
          '0.7',
          '4',
        ],
        '3-6 weeks': [
          'Warm Molasses Water',
          'Milk + Tender Leaves',
          '0.7',
          '3',
        ],
        '6-8 weeks': [
          'Warm Molasses Water',
          'Milk + Starter Feed',
          '1.2',
          '2-3',
        ],
        '8+ weeks': [
          'Warm Molasses Water',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Lethargy': {
        '0-3 weeks': [
          'Energy Booster Solution',
          'Milk with Supplements',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Energy Booster Solution',
          'Milk + Tender Leaves',
          '0.8',
          '3',
        ],
        '6-8 weeks': [
          'Energy Booster Solution',
          'Milk + Starter Feed',
          '1.2',
          '2',
        ],
        '8+ weeks': [
          'Energy Booster Solution',
          'Transition to Doe Feed',
          '1.2',
          'Regular',
        ],
      },
      'Coughing': {
        '0-3 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk with Immune Boosters',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk + Tender Leaves',
          '0.7',
          '3',
        ],
        '6-8 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Bloating': {
        '0-3 weeks': ['Baking Soda Solution', 'Limited Milk', '0.5-0.7', '4-5'],
        '3-6 weeks': [
          'Baking Soda Solution',
          'Limited Milk + Tender Leaves',
          '0.8',
          '3',
        ],
        '6-8 weeks': [
          'Baking Soda Solution',
          'Limited Milk + Starter Feed',
          '1.2',
          '2',
        ],
        '8+ weeks': [
          'Baking Soda Solution',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Failure to Thrive': {
        '0-3 weeks': [
          'High-Energy Liquid',
          'Milk with Supplements',
          '0.7',
          '4',
        ],
        '3-6 weeks': [
          'High-Energy Liquid',
          'Milk + High-Quality Leaves',
          '0.7',
          '3',
        ],
        '6-8 weeks': [
          'High-Energy Liquid',
          'Milk + High-Protein Starter',
          '1.2',
          '2',
        ],
        '8+ weeks': [
          'High-Energy Liquid',
          'Transition to Doe Feed',
          '1.3',
          'Regular',
        ],
      },
      'Fever': {
        '0-3 weeks': [
          'Cool Electrolyte Solution',
          'Milk with Immune Boosters',
          '0.7',
          '4',
        ],
        '3-6 weeks': [
          'Cool Electrolyte Solution',
          'Milk + Tender Leaves',
          '0.7',
          '3',
        ],
        '6-8 weeks': [
          'Cool Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '2',
        ],
        '8+ weeks': [
          'Cool Electrolyte Solution',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Pneumonia': {
        '0-3 weeks': [
          'Warm Herbal Tea',
          'Milk with Immune Boosters',
          '0.7',
          '4',
        ],
        '3-6 weeks': ['Warm Herbal Tea', 'Milk + Tender Leaves', '0.7', '3'],
        '6-8 weeks': ['Warm Herbal Tea', 'Milk + Starter Feed', '1.2', '3'],
        '8+ weeks': [
          'Warm Herbal Tea',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Joint Ill': {
        '0-3 weeks': [
          'Anti-inflammatory Solution',
          'Milk with Immune Boosters',
          '0.7',
          '4',
        ],
        '3-6 weeks': [
          'Anti-inflammatory Solution',
          'Milk + Tender Leaves',
          '0.8',
          '4',
        ],
        '6-8 weeks': [
          'Anti-inflammatory Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Anti-inflammatory Solution',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
      'Coccidiosis': {
        '0-3 weeks': [
          'Electrolyte Solution',
          'Milk with Probiotics',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Electrolyte Solution',
          'Milk + Tender Leaves',
          '0.8',
          '4',
        ],
        '6-8 weeks': [
          'Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Electrolyte Solution',
          'Transition to Doe Feed',
          '1.5',
          'Regular',
        ],
      },
    },
    'Buckling': {
      'Diarrhea': {
        '0-3 weeks': [
          'Electrolyte Solution',
          'Milk with Probiotics',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Electrolyte Solution',
          'Milk + Tender Leaves',
          '0.8',
          '4',
        ],
        '6-8 weeks': [
          'Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Electrolyte Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Loss of Appetite': {
        '0-3 weeks': [
          'Warm Molasses Water',
          'Milk with Appetite Stimulant',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Warm Molasses Water',
          'Milk + Tender Leaves',
          '0.7',
          '4',
        ],
        '6-8 weeks': ['Warm Molasses Water', 'Milk + Starter Feed', '1.2', '3'],
        '8+ weeks': [
          'Warm Molasses Water',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Lethargy': {
        '0-3 weeks': [
          'Energy Booster Solution',
          'Milk with Supplements',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Energy Booster Solution',
          'Milk + Tender Leaves',
          '0.7',
          '4',
        ],
        '6-8 weeks': [
          'Energy Booster Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Energy Booster Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Coughing': {
        '0-3 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk with Immune Boosters',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk + Tender Leaves',
          '1.0',
          '4',
        ],
        '6-8 weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Herbal Tea (Thyme, Mint)',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Bloating': {
        '0-3 weeks': ['Baking Soda Solution', 'Limited Milk', '0.7', '5'],
        '3-6 weeks': [
          'Baking Soda Solution',
          'Limited Milk + Tender Leaves',
          '0.8',
          '4',
        ],
        '6-8 weeks': [
          'Baking Soda Solution',
          'Limited Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Baking Soda Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Failure to Thrive': {
        '0-3 weeks': [
          'High-Energy Liquid',
          'Milk with Supplements',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'High-Energy Liquid',
          'Milk + High-Quality Leaves',
          '1.0',
          '4',
        ],
        '6-8 weeks': [
          'High-Energy Liquid',
          'Milk + High-Protein Starter',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'High-Energy Liquid',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Fever': {
        '0-3 weeks': [
          'Cool Electrolyte Solution',
          'Milk with Immune Boosters',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Cool Electrolyte Solution',
          'Milk + Tender Leaves',
          '1.0',
          '4',
        ],
        '6-8 weeks': [
          'Cool Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Cool Electrolyte Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Pneumonia': {
        '0-3 weeks': [
          'Warm Herbal Tea',
          'Milk with Immune Boosters',
          '0.7',
          '5',
        ],
        '3-6 weeks': ['Warm Herbal Tea', 'Milk + Tender Leaves', '1.0', '4'],
        '6-8 weeks': ['Warm Herbal Tea', 'Milk + Starter Feed', '1.2', '3'],
        '8+ weeks': [
          'Warm Herbal Tea',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Joint Ill': {
        '0-3 weeks': [
          'Anti-inflammatory Solution',
          'Milk with Immune Boosters',
          '0.7',
          '5',
        ],
        '3-6 weeks': [
          'Anti-inflammatory Solution',
          'Milk + Tender Leaves',
          '0.9',
          '4',
        ],
        '6-8 weeks': [
          'Anti-inflammatory Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Anti-inflammatory Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
      'Coccidiosis': {
        '0-3 weeks': [
          'Electrolyte Solution',
          'Milk with Probiotics',
          '0.6',
          '4',
        ],
        '3-6 weeks': [
          'Electrolyte Solution',
          'Milk + Tender Leaves',
          '0.7',
          '3',
        ],
        '6-8 weeks': [
          'Electrolyte Solution',
          'Milk + Starter Feed',
          '1.2',
          '3',
        ],
        '8+ weeks': [
          'Electrolyte Solution',
          'Transition to Buck Feed',
          '1.5',
          'Regular',
        ],
      },
    },
  };

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sick Goats Feed Calculator'),
        backgroundColor: Colors.green[700],
        elevation: 8,
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
                // Number of Goats
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Number of Goats',
                    prefixIcon: const Icon(Icons.pets),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Goat Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGoatType,
                  decoration: InputDecoration(
                    labelText: 'Goat Type',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Doe', child: Text('Doe')),
                    DropdownMenuItem(value: 'Buck', child: Text('Buck')),
                    DropdownMenuItem(
                      value: 'Lactating Doe',
                      child: Text('Lactating Doe'),
                    ),
                    DropdownMenuItem(
                      value: 'Doeling',
                      child: Text('Doeling (Young Female)'),
                    ),
                    DropdownMenuItem(
                      value: 'Buckling',
                      child: Text('Buckling (Young Male)'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGoatType = value;
                      _selectedSymptom = null;
                      _selectedWeightRange = null;
                      _selectedAgeRange = null;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Age Range (only for kids)
                if (_selectedGoatType == 'Doeling' ||
                    _selectedGoatType == 'Buckling')
                  DropdownButtonFormField<String>(
                    value: _selectedAgeRange,
                    decoration: InputDecoration(
                      labelText: 'Age Range',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        _ageRanges.map((range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAgeRange = value;
                      });
                    },
                  ),

                // Weight Range (not for kids)
                if (_selectedGoatType != null &&
                    _selectedGoatType != 'Doeling' &&
                    _selectedGoatType != 'Buckling')
                  DropdownButtonFormField<String>(
                    value: _selectedWeightRange,
                    decoration: InputDecoration(
                      labelText: 'Weight Range',
                      prefixIcon: const Icon(Icons.line_weight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        _weightRanges[_selectedGoatType]?.map((range) {
                          return DropdownMenuItem<String>(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWeightRange = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),

                // Symptoms Dropdown
                if (_selectedGoatType != null)
                  DropdownButtonFormField<String>(
                    value: _selectedSymptom,
                    decoration: InputDecoration(
                      labelText: 'Primary Symptom',
                      prefixIcon: const Icon(Icons.medical_services),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        _symptomsByType[_selectedGoatType]?.map((symptom) {
                          return DropdownMenuItem<String>(
                            value: symptom,
                            child: Text(symptom),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSymptom = value;
                      });
                    },
                  ),
                const SizedBox(height: 30),

                // Calculate Button
                ElevatedButton(
                  onPressed: _calculateFeed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CALCULATE FEED RECOMMENDATION',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateFeed() {
    final numberOfGoats = int.tryParse(_numberController.text) ?? 0;
    if (numberOfGoats <= 0) {
      _showError('Please enter a valid number of goats');
      return;
    }

    if (_selectedGoatType == null) {
      _showError('Please select goat type');
      return;
    }

    if (_selectedSymptom == null) {
      _showError('Please select primary symptom');
      return;
    }

    // Validate kids age range
    if ((_selectedGoatType == 'Doeling' || _selectedGoatType == 'Buckling') &&
        _selectedAgeRange == null) {
      _showError('Please select age range for kids');
      return;
    }

    // Validate adult weight range
    if (_selectedGoatType != 'Doeling' &&
        _selectedGoatType != 'Buckling' &&
        _selectedWeightRange == null) {
      _showError('Please select weight range');
      return;
    }

    // Get diagnosis
    final diagnosis =
        _diseaseDiagnosis[_selectedSymptom] ?? 'Unknown Condition';

    // Get feed recommendation
    List<String>? feedRecommendation;
    if (_selectedGoatType == 'Doeling' || _selectedGoatType == 'Buckling') {
      feedRecommendation =
          _feedRecommendations[_selectedGoatType]?[_selectedSymptom]?[_selectedAgeRange];
    } else {
      feedRecommendation =
          _feedRecommendations[_selectedGoatType]?[_selectedSymptom]?[_selectedWeightRange];
    }

    if (feedRecommendation == null || feedRecommendation.isEmpty) {
      _showError('No feed recommendation available for this combination');
      return;
    }

    // Calculate totals
    String perGoatLiquid = '';
    String perGoatFeed = '';
    String totalLiquid = '';
    String totalFeed = '';

    if (_selectedGoatType == 'Doeling' || _selectedGoatType == 'Buckling') {
      // For kids
      if (_selectedAgeRange == '0-3 weeks' ||
          _selectedAgeRange == '3-6 weeks') {
        // For very young kids, show per feeding amounts
        final liquidPerFeeding = feedRecommendation[2];
        final feedingsPerDay = feedRecommendation[3];
        perGoatLiquid =
            '$liquidPerFeeding L per feeding ($feedingsPerDay feedings/day)';
        perGoatFeed = feedRecommendation[1];

        // Calculate total liquid per day
        final liquidPerDay = double.tryParse(liquidPerFeeding) ?? 0;
        final feedings = int.tryParse(feedingsPerDay) ?? 0;
        totalLiquid =
            '${(liquidPerDay * feedings * numberOfGoats).toStringAsFixed(1)} L/day total';
        totalFeed =
            'Follow feeding instructions for $numberOfGoats ${numberOfGoats == 1 ? 'kid' : 'kids'}';
      } else {
        // For older kids
        final liquidPerDay = feedRecommendation[2];
        perGoatLiquid = '$liquidPerDay L/day';
        perGoatFeed = feedRecommendation[1];

        totalLiquid =
            '${(double.tryParse(liquidPerDay) ?? 0 * numberOfGoats).toStringAsFixed(1)} L/day total';
        totalFeed =
            'Follow feeding instructions for $numberOfGoats ${numberOfGoats == 1 ? 'kid' : 'kids'}';
      }
    } else {
      // For adult goats
      final liquidRange = feedRecommendation[2].split('-');
      final feedRange = feedRecommendation[3].split('-');

      final minLiquid = double.tryParse(liquidRange[0]) ?? 0;
      final maxLiquid =
          liquidRange.length > 1
              ? double.tryParse(liquidRange[1]) ?? minLiquid
              : minLiquid;
      final minFeed = double.tryParse(feedRange[0]) ?? 0;
      final maxFeed =
          feedRange.length > 1
              ? double.tryParse(feedRange[1]) ?? minFeed
              : minFeed;

      perGoatLiquid = '${maxLiquid.toStringAsFixed(1)} L/day';
      perGoatFeed = '${maxFeed.toStringAsFixed(1)} kg/day';

      totalLiquid =
          '${(maxLiquid * numberOfGoats).toStringAsFixed(1)} L/day total';
      totalFeed =
          '${(maxFeed * numberOfGoats).toStringAsFixed(1)} kg/day total';
    }

    // Show results
    _showResults(
      diagnosis: diagnosis,
      liquidType: feedRecommendation[0],
      feedType: feedRecommendation[1],
      perGoatLiquid: perGoatLiquid,
      perGoatFeed: perGoatFeed,
      totalLiquid: totalLiquid,
      totalFeed: totalFeed,
      numberOfGoats: numberOfGoats,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showResults({
    required String diagnosis,
    required String liquidType,
    required String feedType,
    required String perGoatLiquid,
    required String perGoatFeed,
    required String totalLiquid,
    required String totalFeed,
    required int numberOfGoats,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Feed Recommendation'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Diagnosis: $diagnosis',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text('Recommended Liquid: $liquidType'),
                  Text('Recommended Feed: $feedType'),
                  const SizedBox(height: 15),
                  const Text(
                    'Per Goat:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text('Liquid: $perGoatLiquid'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.grass, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Feed: $perGoatFeed'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Total for all $numberOfGoats goats:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('Total Liquid: $totalLiquid'),
                  Text('Total Feed: $totalFeed'),
                  const SizedBox(height: 15),
                  const Text(
                    'Note: Consult a veterinarian for proper diagnosis and treatment.',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
