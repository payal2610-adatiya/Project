import 'package:flutter/material.dart';
import '../../Widgets/Custom Appbar/custom_appbar.dart';

class StartExam extends StatefulWidget {
  const StartExam({Key? key}) : super(key: key);

  @override
  State<StartExam> createState() => _StartExamState();
}

class _StartExamState extends State<StartExam> {
  int _currentQuestionIndex = 0;
  int _selectedAnswer = -1;
  int _score = 0;
  List<Map<String, dynamic>> _questions = [];
  List<int> _userAnswers = [];

  // Sample questions - replace with API call
  final List<Map<String, dynamic>> _sampleQuestions = [
    {
      'question': 'What does a red traffic light indicate?',
      'options': ['Stop', 'Go', 'Slow Down', 'Turn Right'],
      'correctAnswer': 0,
    },
    {
      'question': 'What is the speed limit in residential areas?',
      'options': ['25 km/h', '50 km/h', '75 km/h', '100 km/h'],
      'correctAnswer': 1,
    },
    {
      'question': 'When should you use your horn?',
      'options': [
        'To greet friends',
        'To alert other drivers of danger',
        'To express frustration',
        'All of the above'
      ],
      'correctAnswer': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _questions = _sampleQuestions;
    _userAnswers = List.generate(_questions.length, (index) => -1);
  }

  void _nextQuestion() {
    if (_selectedAnswer != -1) {
      // Check if answer is correct
      if (_selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }

      _userAnswers[_currentQuestionIndex] = _selectedAnswer;

      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = _userAnswers[_currentQuestionIndex];
        });
      } else {
        // Exam completed
        _showResults();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an answer')),
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _userAnswers[_currentQuestionIndex];
      });
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Exam Completed'),
        content: Text('Your score: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to exam screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Start Exam', centerTitle: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Question
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: _questions[_currentQuestionIndex]['options'].length,
                itemBuilder: (context, index) {
                  return Card(
                    color: _selectedAnswer == index ? Colors.blue[100] : null,
                    child: ListTile(
                      title: Text(_questions[_currentQuestionIndex]['options'][index]),
                      leading: Radio(
                        value: index,
                        groupValue: _selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswer = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedAnswer = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? 'Finish'
                          : 'Next'
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}