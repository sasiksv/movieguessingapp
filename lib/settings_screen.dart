import 'package:flutter/material.dart';
import 'PrivacyPolicyScreen.dart';
import 'TermsAndCondition.dart';
import 'StartScreen.dart';
import 'main.dart'; // For CustomBottomNavigationBar

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When back button is pressed, navigate to StartScreen (Home)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
          (Route<dynamic> route) => false, // Clear the navigation stack
        );
        return false; // Prevent the default back action
      },
      child: SafeArea(
        child: Scaffold(
          appBar: const CustomAppBar(
            title: '',
            showBackButton: false, // Disable the back button
          ),
          backgroundColor: const Color(0xFF066867),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Privacy Policy ListTile
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),

              // Terms of Service ListTile
              ListTile(
                title: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Termsandcondition(),
                    ),
                  );
                },
              ),
            ],
          ),
          // Custom Bottom Navigation Bar
          bottomNavigationBar: const CustomBottomNavigationBar(),
        ),
      ),
    );
  }
}
