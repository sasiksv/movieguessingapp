import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import the Google Ads SDK
import 'StartScreen.dart';
import 'settings_screen.dart';
import 'splashscreen.dart'; // Import the settings screen

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // Initialize Google Mobile Ads SDK

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Change to StartScreen for demonstration
    );
  }

  static buildGradientBackground({required Padding child}) {}
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true, // Default to true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF066867), // Set the new background color
      elevation: 0, // Optional: remove shadow
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0), // Adjust the top padding if necessary
          child: SvgPicture.asset(
            'assets/images/MG-appbar.svg',
            height: 60.0, // Adjust the height of the SVG image
          ),
        ),
      ),
      actions: actions, // You can pass additional actions here
      iconTheme: const IconThemeData(
        color: Colors.white, // Set the back button color to white
      ),
    );
  }

  @override
  // Size get preferredSize => const Size.fromHeight(100.0);

  Size get preferredSize => const Size.fromHeight(70.0);
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF99C2C2), // Solid background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Rounded top left corner
          topRight: Radius.circular(30), // Rounded top right corner
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), // Ensures the corners are clipped
          topRight: Radius.circular(30), // Ensures the corners are clipped
        ),
        child: BottomNavigationBar(
          backgroundColor:
              const Color(0xFF99C2C2), // Set solid background color
          selectedItemColor: Colors.black, // Color for selected items
          unselectedItemColor: Colors.black, // Unselected icon and label color
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              // Navigate to StartScreen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
                (Route<dynamic> route) => false, // Clear the stack
              );
            } else if (index == 1) {
              // Navigate to SettingsScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd(); // Load the interstitial ad when the app starts
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Use your Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdReady = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load another ad when the current one is dismissed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Ad failed to show: $error');
          ad.dispose();
        },
      );
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showInterstitialAd(); // Show the ad when the button is pressed
          },
          child: const Text('Show Interstitial Ad'),
        ),
      ),
    );
  }
}
