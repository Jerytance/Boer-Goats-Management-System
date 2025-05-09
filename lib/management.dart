import 'package:flutter/material.dart';
import 'package:welcome/addgoatsonsale.dart';
import 'package:welcome/updategoats.dart';
import 'package:welcome/updatesickgoats.dart';
import 'package:welcome/viewgoatsosale.dart';

class Management extends StatelessWidget {
  const Management({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goat Management Dashboard',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.3),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade600, Colors.green.shade600],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.green.shade50],
          ),
          image: DecorationImage(
            image: AssetImage(
              'assets/images/goat_background.png',
            ), // Add your own asset
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 32, color: Colors.teal.shade800),
                  SizedBox(width: 10),
                  Text(
                    'Manage Your Goats',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.white.withOpacity(0.5),
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // First row of buttons
              Row(
                children: [
                  Expanded(
                    child: _buildManagementButton(
                      context,
                      icon: Icons.edit,
                      label: 'Update Goats',
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade200, Colors.teal.shade400],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateGoatScreen(goatId: 0),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildManagementButton(
                      context,
                      icon: Icons.medical_services,
                      label: 'Sick Goats',
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade200,
                          Colors.orange.shade400,
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => UpdateSickGoatScreen(goatId: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Second row of buttons
              Row(
                children: [
                  Expanded(
                    child: _buildManagementButton(
                      context,
                      icon: Icons.add_circle,
                      label: 'Add for Sale',
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade200, Colors.green.shade400],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGoatsOnSale(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildManagementButton(
                      context,
                      icon: Icons.remove_red_eye,
                      label: 'View for Sale',
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade200, Colors.blue.shade400],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoatsOnSale(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Decorative divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Divider(
                  thickness: 2,
                  color: Colors.teal.shade300,
                  height: 20,
                ),
              ),
              SizedBox(height: 20),

              // Back button with improved styling
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, size: 24),
                  label: Text(
                    'Back to Main Menu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal.shade800,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.teal.shade300, width: 1.5),
                    ),
                    elevation: 5,
                    shadowColor: Colors.teal.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: color),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
