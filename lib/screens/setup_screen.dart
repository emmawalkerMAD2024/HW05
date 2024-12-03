import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _numberOfQuestions = 5;
  String _selectedCategory = "9"; // General Knowledge by default
  String _selectedDifficulty = "easy";
  String _selectedType = "multiple";

  final List<String> _categories = [
    "9", // Add category IDs here (fetch them dynamically in a real app)
  ];

  void _startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          numberOfQuestions: _numberOfQuestions,
          categoryId: int.parse(_selectedCategory),
          difficulty: _selectedDifficulty,
          questionType: _selectedType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Customize Your Quiz', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: _numberOfQuestions,
              onChanged: (value) => setState(() => _numberOfQuestions = value!),
              items: [5, 10, 15]
                  .map((number) => DropdownMenuItem(
                        value: number,
                        child: Text('$number Questions'),
                      ))
                  .toList(),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) =>
                  setState(() => _selectedCategory = value!),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category), // Replace with actual category names
                      ))
                  .toList(),
            ),
            DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: (value) =>
                  setState(() => _selectedDifficulty = value!),
              items: ['easy', 'medium', 'hard']
                  .map((difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      ))
                  .toList(),
            ),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
              items: ['multiple', 'boolean']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type == 'multiple'
                            ? 'Multiple Choice'
                            : 'True/False'),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startQuiz,
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
