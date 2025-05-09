import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupMembers extends StatelessWidget {
  const GroupMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HIT Boer Application Developers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 10,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              _buildMemberCard(
                context,
                'Project Manager',
                'Heather Kambarami',
                'android/assets/images/heather.jpg',
                phone: '+263 71 475 5690',
                email: '', // Add email here
              ),
              const SizedBox(height: 16),
              _buildMemberCard(
                context,
                'Quality Assurance Officer',
                'Morewell Chikara',
                'android/assets/images/morewell.jpg',
                phone: '+263 78 257 3539',
                email: '', // Add email here
              ),
              const SizedBox(height: 16),
              _buildMemberCard(
                context,
                'Frontend Developer (& Design)',
                'Mark Chimunhu',
                'android/assets/images/mark.jpg',
                phone: '+263 77 877 9515',
                email: '', // Add email here
              ),
              const SizedBox(height: 16),
              _buildMemberCard(
                context,
                'Backend Developer',
                'Jerytance Samhu-Kauyani',
                'android/assets/images/jedza.jpg',
                phone: '+263 71 935 7497',
                email: 'bossjedza04@gmail.com',
              ),
              const SizedBox(height: 16),
              _buildMemberCard(
                context,
                'Technical Lead',
                'Hassan Phiri',
                'android/assets/images/hassain.jpg',
                phone: '+263 77 437 7868',
                email: '', // Add email here
              ),
              const SizedBox(height: 24),
              Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('android/assets/images/gmembers.jpg'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'BACK',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    String role,
    String name,
    String imagePath, {
    String? phone,
    String? email,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              role,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 200,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            if (phone != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _makePhoneCall(phone),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (email != null) ...[
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _sendEmail(context, email),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Regarding HIT Boer Application',
        'body': 'Dear Team Member,\n\n',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch email client')));
    }
  }
}
