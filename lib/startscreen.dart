import 'package:flutter/material.dart';

import 'GenreSelectionScreen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => GenreSelectionScreen()));
              },
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('Zingtek Movie Guessing Application'),
                    );
                  },
                );
              },
              child: Text('How to Play'),
            ),
          ],
        ),
      ),
    );
  }
}
