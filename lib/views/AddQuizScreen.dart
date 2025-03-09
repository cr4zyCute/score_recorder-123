import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart'; // Import controller
import 'FailScreen.dart';
import 'PassScreen.dart';

class AddQuizScreen extends StatefulWidget {
  final Function() onQuizAdded; // Callback function

  const AddQuizScreen({super.key, required this.onQuizAdded});

  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController overallScoreController = TextEditingController();
  final QuizController _quizController = QuizController();

  void _saveQuiz() async {
    String quizName = nameController.text;
    int score = int.tryParse(scoreController.text) ?? 0;
    int overallScore = int.tryParse(overallScoreController.text) ?? 1;

    if (quizName.isEmpty || overallScore == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    // Store quiz in the database
    await _quizController.addQuiz(quizName, score, overallScore);

    // Notify the parent widget that a quiz has been added
    widget.onQuizAdded();

    // Calculate percentage and decide next screen
    double percentage = (score / overallScore) * 100;

    // Navigate to the appropriate screen
    if (percentage < 50) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => FailScreen(score: score, overallScore: overallScore),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PassScreen(score: score, overallScore: overallScore),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Score Recorder')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Quiz/Activity Name'),
            ),
            TextField(
              controller: scoreController,
              decoration: InputDecoration(labelText: 'Your Score'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: overallScoreController,
              decoration: InputDecoration(labelText: 'Overall Score'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveQuiz, child: Text('Save Quiz')),
          ],
        ),
      ),
    );
  }
}
