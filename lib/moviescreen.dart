import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:async';

class MoviesScreen extends StatefulWidget {
  final String genre;

  MoviesScreen({required this.genre});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<List<dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  String _selectedOption = "";

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final data = await rootBundle.loadString('assets/movies.csv');
    List<List<dynamic>> csvData = CsvToListConverter().convert(data);
    setState(() {
      _questions =
          csvData.where((question) => question[6] == widget.genre).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question[0], style: TextStyle(fontSize: 24)),
            for (int i = 1; i <= 4; i++)
              RadioListTile(
                title: Text(question[i]),
                value: question[i],
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value.toString();
                  });
                },
              ),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption == question[5]) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedOption = "";
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('Correct answer: ${question[5]}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _currentQuestionIndex++;
                                _selectedOption = "";
                              });
                            },
                            child: Text('Next'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
