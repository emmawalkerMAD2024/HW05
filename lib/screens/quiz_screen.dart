import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int categoryId;
  final String difficulty;
  final String questionType;

  const QuizScreen({
    Key? key,
    required this.numberOfQuestions,
    required this.categoryId,
    required this.difficulty,
    required this.questionType,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _selectedAnswer = "";
  String _feedbackText = "";
  int _timeRemaining = 15;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions();
      setState(() {
        _questions = questions;
        _loading = false;
        _startTimer();
      });
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  void _startTimer() {
    _timeRemaining = 15;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();
          _markQuestionIncorrect();
        }
      });
    });
  }

  void _markQuestionIncorrect() {
    if (!_answered) {
      setState(() {
        _answered = true;
        _feedbackText = "Time's up! The correct answer is: ${_questions[_currentQuestionIndex].correctAnswer}.";
      });
    }
  }

  void _submitAnswer(String selectedAnswer) {
    _timer.cancel();
    setState(() {
      _answered = true;
      _selectedAnswer = selectedAnswer;

      final correctAnswer = _questions[_currentQuestionIndex].correctAnswer;
      if (selectedAnswer == correctAnswer) {
        _score++;
        _feedbackText = "Correct! The answer is $correctAnswer.";
      } else {
        _feedbackText = "Incorrect. The correct answer is $correctAnswer.";
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _answered = false;
        _selectedAnswer = "";
        _feedbackText = "";
        _currentQuestionIndex++;
        _startTimer();
      });
    } else {
      _timer.cancel();
      Navigator.pushReplacementNamed(context, '/results', arguments: {
        'score': _score,
        'totalQuestions': _questions.length,
      });
    }
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: _answered ? null : () => _submitAnswer(option),
      child: Text(option),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress),
            SizedBox(height: 16),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              question.question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ...question.options.map((option) => _buildOptionButton(option)),
            SizedBox(height: 20),
            Text(
              'Time remaining: $_timeRemaining seconds',
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            if (_answered)
              Text(
                _feedbackText,
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedAnswer == question.correctAnswer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text('Next Question'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
