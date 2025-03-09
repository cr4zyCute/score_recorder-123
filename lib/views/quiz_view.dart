import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz.dart';
import 'addquizscreen.dart'; // Import the AddQuizScreen class

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final QuizController _controller = QuizController();
  final nameController = TextEditingController();
  final scoreController = TextEditingController();
  final overallScoreController = TextEditingController();
  List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  // Fetch quizzes from database
  Future<void> _loadQuizzes() async {
    final data = await _controller.fetchQuizzes();
    setState(() {
      quizzes = data;
    });

    // Debugging log to check retrieved quizzes
    debugPrint("Loaded Quizzes: ${quizzes.map((q) => q.toMap()).toList()}");
  }

  // Add a new quiz and refresh list
  void _addQuiz() async {
    if (nameController.text.isEmpty ||
        scoreController.text.isEmpty ||
        overallScoreController.text.isEmpty) {
      return;
    }

    int score = int.parse(scoreController.text);
    int overallScore = int.parse(overallScoreController.text);
    await _controller.addQuiz(nameController.text, score, overallScore);

    // Refresh quiz list
    await _loadQuizzes();

    // Clear text fields
    nameController.clear();
    scoreController.clear();
    overallScoreController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Score Recorder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddQuizScreen(
                    onQuizAdded: _loadQuizzes, // Pass the callback function
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addQuiz, child: const Text('Add Quiz')),
            const SizedBox(height: 20),
            Expanded(
              child:
                  quizzes.isEmpty
                      ? const Center(child: Text("No quizzes added yet"))
                      : ListView.builder(
                        itemCount: quizzes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              title: Text(
                                quizzes[index].quizName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Score: ${quizzes[index].score}/${quizzes[index].overallScore}',
                              ),
                              trailing:
                                  quizzes[index].passed
                                      ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                      : const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
