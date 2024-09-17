import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart'; // Import url_launcher

class PrivacyPolicyScreen extends StatelessWidget {
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
                _buildSectionTitle('What do we collect:'),
                _buildContentText(
                  'We do not collect any user input, except for the users option selections. Our goal is to enhance your knowledge of movies and provide an enjoyable gaming experience. We will never collect your personal or non-personal information except as outlined in this privacy policy.',
                ),
                const SizedBox(height: 18),
                _buildSectionTitle(
                    'Do we transfer any information to outside parties?'),
                _buildContentText(
                  'Since we do not collect any user information, either directly or indirectly, we have no user data to share with others. The only input we receive is the users option selection, which is used solely to check if the selected movie name is correct.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Third party links:'),
                _buildContentTextWithLinks(
                  'Occasionally, at our discretion, we may include or offer third-party products or services on our app via ads (Admob). These third-party sites have separate and independent privacy policies. We, therefore, have no responsibility or liability for the content and activities of these linked sites. Please read the privacy policy of Admob by using this link: ',
                  'https://support.google.com/admob/answer/6128543?hl=en',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Advertisement in App:'),
                _buildContentText(
                  'We use Google Admob to display an ad in our application. There could be errors in the programming and sometimes programming errors may cause unwanted side effects. Also, to know about Google Ads Privacy Policy Click and jump to: ',
                ),
                _buildContentTextWithLinks(
                  'Google ad privacy policy',
                  ' https://support.google.com/admob/answer/6128543?hl=en',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Storage:'),
                _buildContentText(
                  'We store an index number in the shared preferences on your device. This application does not transfer any information to other networked systems. It will be stored only on your device.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Deletion of Data:'),
                _buildContentText(
                  'The index number is stored only in the local database on your mobile device. Users can delete this index number by uninstalling the application, which will remove all related data from the device.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Do we use cookies?'),
                _buildContentText('No, we do not use cookies.'),
                const SizedBox(height: 16),
                _buildSectionTitle('Do we sell your data?'),
                _buildContentText(
                  'No, we have never sold your data. The index number is stored exclusively in the shared preferences local database on your mobile device. We cannot read, edit, or access the data stored in your device’s local database.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Changes to our Privacy Policy:'),
                _buildContentText(
                  'If we decide to make changes to our privacy policy, we will post the updates on this page and within our application. This policy was last modified on September 13, 2024.',
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Contacting Us:'),
                _buildContentTextWithLinks(
                  'If there are any questions regarding our privacy policy you may contact us using the information below: ',
                  'Email:zealtown22.com@gmail.com',
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
