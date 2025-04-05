import 'package:flutter/material.dart';
import 'quiz_view.dart'; // Import your quiz screen

class FailScreen extends StatelessWidget {
  final int score;
  final int overallScore;

  const FailScreen({
    super.key,
    required this.score,
    required this.overallScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 80),
              SizedBox(height: 10),
              Text(
                'You Failed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Score: $score/$overallScore'),
              SizedBox(height: 20),
              Image.asset('assets/failed.png', height: 100), // Add image
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const QuizView()),
                    (Route<dynamic> route) =>
                        false, // Removes all previous routes
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: Text('Try Again', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
