import 'package:flutter/material.dart';
import 'quiz_view.dart'; // Import the QuizView screen

class PassScreen extends StatelessWidget {
  final int score;
  final int overallScore;

  const PassScreen({
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
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 10),
              Text(
                'You Passed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text('Score: $score/$overallScore'),
              SizedBox(height: 10),
              Image.asset(
                'assets/pass.png',
                height: 180, // Adjust height
                width: 180, // Adjust width proportionally
                fit: BoxFit.contain, // Ensures it scales correctly
              ),
              // Add image
              SizedBox(height: 20),
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
                child: Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
