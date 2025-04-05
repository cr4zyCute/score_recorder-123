import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
  bool _isSaving = false; // Prevents multiple taps

  void _saveQuiz() async {
    if (_isSaving) return; // Prevent multiple taps

    setState(() {
      _isSaving = true;
    });

    String quizName = nameController.text.trim();
    int score = int.tryParse(scoreController.text) ?? 0;
    int overallScore = int.tryParse(overallScoreController.text) ?? 1;

    if (quizName.isEmpty || overallScore <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    // Store quiz in the database
    await _quizController.addQuiz(quizName, score, overallScore);

    // Notify the parent widget that a quiz has been added
    widget.onQuizAdded();

    // Calculate percentage and decide next screen
    double percentage = (score / overallScore) * 100;

    // Navigate to the appropriate screen
    Widget resultScreen =
        (percentage < 50)
            ? FailScreen(score: score, overallScore: overallScore)
            : PassScreen(score: score, overallScore: overallScore);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => resultScreen),
    ).then((_) {
      // Go back to previous screen after result screen
      Navigator.pop(context);
    });

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Quiz Recorder',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns form to the left
              children: [
                Center(
                  // Centers the image and text
                  child: Column(
                    children: [
                      Image.asset('assets/add.png', height: 120),
                      const SizedBox(height: 10),
                      const Text(
                        'Add your Quizzes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Quiz Name',
                    prefixIcon: const Icon(FeatherIcons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: scoreController,
                  decoration: InputDecoration(
                    labelText: 'Your Score',
                    prefixIcon: const Icon(FeatherIcons.edit3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: overallScoreController,
                  decoration: InputDecoration(
                    labelText: 'Overall Score',
                    prefixIcon: const Icon(FeatherIcons.target),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Center(
                  // Centers the Save button
                  child: ElevatedButton(
                    onPressed:
                        _isSaving
                            ? null
                            : _saveQuiz, // Disable button while saving
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FeatherIcons.checkCircle,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isSaving ? 'Saving...' : 'Save',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Image.asset(
            'assets/ad_banner.png', // Change this to your ad image
            height: 60, // Adjust height as needed
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
