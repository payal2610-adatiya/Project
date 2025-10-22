import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  int _currentQuestionIndex = 0;
  int _selectedAnswer = -1;
  bool _showAnswer = false;
  int _correctAnswers = 0;
  int _totalQuestions = 0;

  final List<Map<String, dynamic>> _practiceQuestions = [
    {
      'question': 'What does this sign mean? 🛑',
      'options': ['Stop', 'Yield', 'No Entry', 'One Way'],
      'correctAnswer': 0,
      'explanation': 'Red octagonal sign means you must come to a complete stop.'
    },
    {
      'question': 'What should you do when approaching a yellow light?',
      'options': ['Speed up', 'Stop if safe', 'Continue normally', 'Honk horn'],
      'correctAnswer': 1,
      'explanation': 'Yellow light means prepare to stop if it\'s safe to do so.'
    },
    {
      'question': 'Minimum safe following distance is:',
      'options': ['1 second', '2 seconds', '3 seconds', '4 seconds'],
      'correctAnswer': 2,
      'explanation': 'Maintain at least 3 seconds distance from the vehicle ahead.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _totalQuestions = _practiceQuestions.length;
  }

  void _checkAnswer() {
    if (_selectedAnswer != -1) {
      setState(() {
        _showAnswer = true;
        if (_selectedAnswer == _practiceQuestions[_currentQuestionIndex]['correctAnswer']) {
          _correctAnswers++;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an answer first')),
      );
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _practiceQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = -1;
        _showAnswer = false;
      });
    } else {
      _showFinalScore();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = -1;
        _showAnswer = false;
      });
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Practice Completed'),
        content: Text('You got $_correctAnswers out of $_totalQuestions questions correct!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _selectedAnswer = -1;
                _showAnswer = false;
                _correctAnswers = 0;
              });
            },
            child: Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _practiceQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: CustomAppbar(title: 'Practice', centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Text(
              'Question ${_currentQuestionIndex + 1}/$_totalQuestions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _totalQuestions,
            ),
            SizedBox(height: 20),

            // Question
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion['options'].length,
                itemBuilder: (context, index) {
                  bool isCorrect = index == currentQuestion['correctAnswer'];
                  bool isSelected = index == _selectedAnswer;

                  Color? backgroundColor;
                  if (_showAnswer) {
                    if (isCorrect) {
                      backgroundColor = Colors.green[100];
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red[100];
                    }
                  }

                  return Card(
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(currentQuestion['options'][index]),
                      leading: Radio(
                        value: index,
                        groupValue: _selectedAnswer,
                        onChanged: !_showAnswer ? (value) {
                          setState(() {
                            _selectedAnswer = value!;
                          });
                        } : null,
                      ),
                      onTap: !_showAnswer ? () {
                        setState(() {
                          _selectedAnswer = index;
                        });
                      } : null,
                    ),
                  );
                },
              ),
            ),

            // Explanation
            if (_showAnswer) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explanation:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(currentQuestion['explanation']),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  child: Text('Previous'),
                ),
                if (!_showAnswer)
                  ElevatedButton(
                    onPressed: _selectedAnswer != -1 ? _checkAnswer : null,
                    child: Text('Check Answer'),
                  ),
                if (_showAnswer)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(
                        _currentQuestionIndex == _practiceQuestions.length - 1
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