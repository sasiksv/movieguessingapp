import 'package:flutter/material.dart';
import 'GenreSelectionScreen.dart';
import 'main.dart'; // For CustomBottomNavigationBar

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF066867),
        appBar: const CustomAppBar(
          title: '',
          showBackButton: false, // No back button on Start Screen
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to GenreSelectionScreen with fade transition
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const GenreSelectionScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.easeInOut;

                        var opacityAnimation =
                            Tween<double>(begin: begin, end: end).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: curve,
                          ),
                        );

                        return FadeTransition(
                          opacity: opacityAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6BB634),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                        color: Colors.white, width: 2), // White border
                  ),
                  minimumSize: const Size(250, 50), // Button width
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20), // Spacing between buttons

              // How to Play Button
              ElevatedButton(
                onPressed: () {
                  // Show Instructions Dialog
                  _showInstructionsDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01A4E2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                        color: Colors.white, width: 2), // White border
                  ),
                  minimumSize: const Size(250, 50), // Button width
                ),
                child: const Text(
                  'How to play ?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // Custom bottom navigation bar
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }

  // Show Instructions Dialog Method
  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF066867),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the dialog is not fullscreen
            children: [
              const Text(
                'Instructions:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '➤ Tap "Start" to begin.\n'
                '➤ Choose a movie category\n     (Ex: Fiction).\n'
                '➤ Choose a movie genre \n     (Ex: Thriller).\n'
                '➤ Read the quote and pick the\n     correct movie title.\n'
                '➤ Tap "Submit" after choosing\n     your answer.\n'
                '➤ If you are right, move to the\n     next question. If not, see the\n     correct answer and tap\n     "Next" to play.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 253, 253, 0.58),
                      width: 5,
                    ),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFF066867),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
