import 'package:flutter/material.dart';

import 'moviescreen.dart';

class GenreSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Genre')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MoviesScreen(genre: 'Action')));
              },
              child: Text('Action'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MoviesScreen(genre: 'Thriller')));
              },
              child: Text('Thriller'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MoviesScreen(genre: 'Comedy')));
              },
              child: Text('Comedy'),
            ),
          ],
        ),
      ),
    );
  }
}
