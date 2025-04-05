import 'package:flutter/material.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz.dart';
import 'addquizscreen.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final QuizController _controller = QuizController();
  List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final data = await _controller.fetchQuizzes();
    setState(() {
      quizzes = data;
    });
  }

  void _deleteQuiz(int quizId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Quiz'),
            content: const Text('Are you sure you want to delete this quiz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await _controller.deleteQuiz(
                    quizId,
                  ); // ✅ Calls the delete method in QuizController
                  _loadQuizzes(); // ✅ Refresh the list after deletion
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  int getTotalQuizzes() => quizzes.length;
  int getTotalPassedQuizzes() => quizzes.where((quiz) => quiz.passed).length;
  int getTotalFailedQuizzes() => quizzes.where((quiz) => !quiz.passed).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 4,
        title: const Text(
          'Quiz Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddQuizScreen(
                    onQuizAdded:
                        _loadQuizzes, // ✅ Pass the callback to refresh quizzes
                  ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.assignment,
                  size: 40,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Score Recorder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Your Scores",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox(
                  title: 'Total Quizzes',
                  value: getTotalQuizzes().toString(),
                  color: Colors.deepPurple,
                ),
                _buildStatBox(
                  title: 'Passed',
                  value: getTotalPassedQuizzes().toString(),
                  color: Colors.green,
                ),
                _buildStatBox(
                  title: 'Failed',
                  value: getTotalFailedQuizzes().toString(),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                quizzes.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/nolist.png',
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "No quizzes added yet!",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            quizzes[index].quizName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Score: ${quizzes[index].score}/${quizzes[index].overallScore}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                quizzes[index].passed
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    quizzes[index].passed
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _deleteQuiz(quizzes[index].id!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
