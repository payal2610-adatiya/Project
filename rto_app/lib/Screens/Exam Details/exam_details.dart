import 'package:flutter/material.dart';

import '../Start Exam/start_exam.dart';

class ExamDetails extends StatefulWidget {
  @override
  State<ExamDetails> createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {
  final int totalQuestions = 10;

  final int timePerQuestion = 50;

  final int passingMarks = 6;

  String get totalDuration {
    int totalSeconds = totalQuestions * timePerQuestion;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Details"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "📝 Exam Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Text("📌 Total Questions: $totalQuestions", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text("⏱ Time per Question: $timePerQuestion seconds", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text("🕒 Total Duration: $totalDuration", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text("❌ Negative Marking: No", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text("🎯 Passing Marks: $passingMarks / $totalQuestions", style: TextStyle(fontSize: 16)),

          SizedBox(height: 30),

          Text(
            "📖 Instructions:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("• Each question has only one correct answer."),
          Text("• You cannot go back once you submit an answer."),
          Text("• Try to answer all questions within time."),
          Text("• Avoid switching apps during the test."),

          SizedBox(height: 30),

          ElevatedButton.icon(
            icon: Icon(Icons.play_arrow),
            label: Text("Start Exam"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StartExam()));
            },
          ),
        ],
      ),
    );
  }
}
