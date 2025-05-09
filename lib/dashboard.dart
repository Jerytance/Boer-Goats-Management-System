import 'package:flutter/material.dart';
import 'dart:io';

import 'package:welcome/addgoats.dart';
import 'package:welcome/addsickgoats.dart';
import 'package:welcome/addsoldgoats.dart';
import 'package:welcome/alerts.dart';
import 'package:welcome/breeding.dart';
import 'package:welcome/finance.dart';
import 'package:welcome/goatsfeed.dart';
import 'package:welcome/groupmembers.dart';
import 'package:welcome/help.dart';
import 'package:welcome/loginscreen.dart';
import 'package:welcome/management.dart';
import 'package:welcome/reports.dart';
import 'package:welcome/veterinary.dart';
import 'package:welcome/view_goats_screen.dart';
import 'package:welcome/view_sick_goats_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.pets, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Goat Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            _buildDrawerDivider(),
            _buildDrawerItem(
              icon: Icons.monetization_on,
              title: 'Sold Goats',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSoldGoats()),
                  ),
            ),
            _buildDrawerDivider(),
            _buildDrawerItem(
              icon: Icons.favorite,
              title: 'Breeding',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Breeding()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.manage_accounts,
              title: 'Management',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Management()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.attach_money,
              title: 'Finance',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Finance()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.fastfood,
              title: 'Feed',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoatFeed()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.medical_services,
              title: 'Vaccination',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vertinary()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.bar_chart,
              title: 'Reports',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reports()),
                  ),
            ),

            _buildDrawerItem(
              icon: Icons.help,
              title: 'Goats Notifications',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoatAlertsScreen()),
                  ),
            ),

            _buildDrawerItem(
              icon: Icons.help,
              title: 'Help',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BoerGoatGuide()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.group,
              title: 'Group Members',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupMembers()),
                  ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            const Icon(
                              Icons.pets,
                              size: 50,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Welcome to Boer Goats\nManagement System',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Manage your goat farm efficiently',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // First row of buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.add_circle,
                            label: 'Add Goats',
                            color: Colors.green,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddGoatScreen(),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.remove_red_eye,
                            label: 'View Goats',
                            color: Colors.blue,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewGoatsScreen(),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Second row of buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.medical_services,
                            label: 'Add Sick Goats',
                            color: Colors.orange,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSickGoatScreen(),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.medical_information,
                            label: 'View Sick Goats',
                            color: Colors.red,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewSickGoatsScreen(),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Navigation buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.arrow_back,
                            label: 'Back',
                            color: Colors.grey,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.exit_to_app,
                            label: 'Exit',
                            color: Colors.red,
                            onPressed: () => exit(0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _buildDrawerDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        shadowColor: color.withOpacity(0.3),
      ),
    );
  }
}
