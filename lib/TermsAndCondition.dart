import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart'; // Import url_launcher

class Termsandcondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF066867),
        appBar: const CustomAppBar(
          title: '',
          showBackButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Description of Service:'),
                _buildContentText(
                  'The Whats The Movie application offers a variety of game implementations categorized into fiction, non-fiction, comedy, art, animation, and romance.',
                ),
                const SizedBox(height: 18),
                _buildSectionTitle('No Permissions Required:'),
                _buildContentText(
                  'You do not need to grant any permissions to access or use the Whats The Movie application. We do not require access to any personal information or data on your device.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Disclaimer:'),
                _buildContentText(
                  'The Whats The Movie application is designed to provide an enjoyable gaming experience. While we strive to offer accurate quotes and hints from well-known movies, we do not guarantee the completeness, accuracy, or reliability of the information provided. The app aims to help users enhance their knowledge of movies but should not be relied upon as a sole source of information.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Changes to our Terms of Service:'),
                _buildContentText(
                  'If we decide to update our Terms of Service, we will post the changes on this page and within our application. This policy was last modified on September 13, 2024.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Contact Us:'),
                _buildContentTextWithLinks(
                  'If you have any questions or concerns about these Terms, please contact us at ',
                  'Email:zealtown22.com',
                ),
                _buildContentText(
                  'By using the Word Guessing application,       you acknowledge that you have read, understood, and agree to be bound by these Terms of Service',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildContentText(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildContentTextWithLinks(String content, String link) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: link,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunch(link)) {
                  await launch(link);
                } else {
                  throw 'Could not launch $link';
                }
              },
          ),
        ],
      ),
    );
  }
}
