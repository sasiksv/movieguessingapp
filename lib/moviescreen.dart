import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Add this import for ads
import 'package:movieguessingapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MoviesScreen extends StatefulWidget {
  final String genre;
  final int startIndex;

  const MoviesScreen({super.key, required this.genre, this.startIndex = 0});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<List<dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  String _selectedOption = "";
  bool _isAnswered = false; // To track if the user has submitted an answer
  int _submitCounter = 0; // Counter to track the number of submits
  InterstitialAd? _interstitialAd; // For the interstitial ad
  bool _isAdReady = false; // To check if the ad is ready

  @override
  void initState() {
    super.initState();
    _loadProgress();
    loadCSV();
    _loadInterstitialAd(); // Load the interstitial ad when the screen starts
  }

  Future<void> loadCSV() async {
    final data = await rootBundle.loadString('assets/movies.csv');
    List<List<dynamic>> csvData = const CsvToListConverter().convert(data);
    setState(() {
      _questions =
          csvData.where((question) => question[6] == widget.genre).toList();
    });
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentQuestionIndex =
          prefs.getInt('progress_${widget.genre}') ?? widget.startIndex;
    });
  }

  Future<void> _saveCurrentIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_${widget.genre}', _currentQuestionIndex);
  }

  void _selectOption(String option) {
    if (!_isAnswered) {
      setState(() {
        _selectedOption = option;
      });
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = "";
        _isAnswered = false; // Reset answer status for the next question
      });
      _saveCurrentIndex();
    }
  }

  void _submitAnswer() {
    if (_selectedOption.isEmpty) {
      // Show an alert dialog if no option is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Color(0xFF99C2C2),
                width: 5,
              ),
            ),
            content: const SizedBox(
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '"Please select an option!"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    backgroundColor: const Color(0xFF6BB634),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _submitCounter++;
      if (_submitCounter >= 3 && _isAdReady) {
        _showInterstitialAd();
        _submitCounter = 0;
      }
      setState(() {
        _isAnswered = true;
      });

      if (_selectedOption == _questions[_currentQuestionIndex][5]) {
        _goToNextQuestion();
      } else {
        // Custom dialog for incorrect answers
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Color(0xFF99C2C2),
                  width: 6,
                ),
              ),
              content: SizedBox(
                width: 500, // Fixed width
                height: 292, // Fixed height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline, // Oops! icon
                      color: Colors.red,
                      size: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Oops...!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "The answer is wrong",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The Correct answer is",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _questions[_currentQuestionIndex][5], // Correct answer
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _goToNextQuestion();
                    },
                    child: Container(
                      width: 200, // Adjust width
                      height: 50, // Adjust height
                      decoration: BoxDecoration(
                        color: const Color(0xFF6BB634), // Green background
                        borderRadius:
                            BorderRadius.circular(30), // Rounded button
                        border: Border.all(
                          color: Colors.white, // White border
                          width: 4,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Use your ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdReady = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  // Show the interstitial ad
  void _showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load another ad after the previous one is dismissed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Ad failed to show: $error');
          ad.dispose();
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Show confirmation dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Color(0xFF99C2C2),
              width: 5,
            ),
          ),
          content: const SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Are you sure you want to leave?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // User confirmed exit
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      backgroundColor: const Color(0xFF6BB634),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // User canceled exit
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      backgroundColor: const Color(0xFF6BB634),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    // Return true if the result is true, otherwise return false
    return result ?? false;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading spinner while the CSV file is being loaded
    if (_questions.isEmpty) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF066867),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ), // Show a loading indicator
                const SizedBox(
                    height: 20), // Add space between indicator and text
                const Text(
                  'Please wait a moment...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    var question = _questions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: _onWillPop, // Handle back navigation
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF066867),
          appBar: const CustomAppBar(
            title: '',
            showBackButton: false, // No back button on Start Screen
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Display selected genre below the AppBar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Genre - ${widget.genre}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between genre and container
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Container that includes both the quote and options
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(
                              10), // Increased border radius
                          border: Border.all(
                            color: const Color(0xFF99C2C2),
                            width: 4,
                          ), // Added border
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 430, // Adjust the height as needed
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Display the quote at the top
                            Center(
                              child: Text(
                                question[0],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Display the options below the quote
                            for (int i = 1; i <= 4; i++)
                              Center(
                                child: GestureDetector(
                                  onTap: () => _selectOption(question[i]),
                                  child: Container(
                                    width: 300, // Adjust the width as needed
                                    height:
                                        53, // Adjust the height for the options
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      color: _selectedOption == question[i]
                                          ? const Color(
                                              0xFF6BB634) // Focus color
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: const Color(0xFF99C2C2),
                                        width: 3,
                                      ), // Added border
                                    ),
                                    child: Center(
                                      child: Text(
                                        question[i],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedOption == question[i]
                                              ? Colors
                                                  .white // Set text color to white when selected
                                              : Colors
                                                  .black, // Default text color
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height:
                              20), // Space between options container and submit button
                      // Submit Button
                      GestureDetector(
                        onTap: _isAnswered ? null : _submitAnswer,
                        child: Container(
                          width: 200, // Adjust width as needed
                          height: 60, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFF6BB634), // Updated background color to 0xFF6BB634
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                                color: const Color(0xFFFFFFFF), width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Add space at the bottom
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
