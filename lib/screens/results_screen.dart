import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultsScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Summary')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score/$totalQuestions',
                style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Setup'),
            ),
          ],
        ),
      ),
    );
  }
}
