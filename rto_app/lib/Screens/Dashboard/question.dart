import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionBankScreen extends StatelessWidget {
  final int id = 1;
  Future<List<dynamic>> fetchQuestionsFromAPI(int id) async {
    try {
      var url = Uri.parse("https://prakrutitech.xyz/gaurang/view_question_by_id.php?id=$id");
      var response = await http.get(url);

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['question'] != null) {
          List<dynamic> data = [responseData['question']];
          return data;
        } else {
          print('No "question" key found in response.');
          return [];
        }
      } else {
        print('Failed to load questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

  // List of traffic signs for the second tab
  final List<Map<String, String>> trafficSigns = [
    {
      'sign': 'Stop Sign',
      'description': 'A red octagonal sign indicating that vehicles must stop and give way to other traffic.',
      'image': 'assets/stop_sign.jpg',
    },
    {
      'sign': 'Yield Sign',
      'description': 'A triangular sign indicating that vehicles should slow down or stop to give way to other vehicles.',
      'image': 'assets/yield_sign.jpg',
    },
    {
      'sign': 'Speed Limit 30',
      'description': 'A round sign indicating the maximum speed of 30 km/h on a particular road.',
      'image': 'assets/speed_limit_30.jpg',
    },
    {
      'sign': 'Speed Limit 50',
      'description': 'A round sign indicating the maximum speed of 50 km/h on a particular road.',
      'image': 'assets/speed_limit_50.png',
    },
    {
      'sign': 'Pedestrian Crossing',
      'description': 'A sign indicating a pedestrian crossing area for safety.',
      'image': 'assets/children_crossing.png',
    },
    // Add other signs here as necessary
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Question Bank"),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: "Questions"),
              Tab(text: "Traffic Signs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Questions list with FutureBuilder
            FutureBuilder<List<dynamic>>(
              future: fetchQuestionsFromAPI(id), // Fetch questions here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  var questions = snapshot.data!;
                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      var question = questions[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['question_text'] ?? 'No question',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'A: ${question['option_a'] ?? 'No option'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'B: ${question['option_b'] ?? 'No option'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'C: ${question['option_c'] ?? 'No option'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Correct Option: ${question['correct_option'] ?? 'Not provided'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              IconButton(
                                icon: Icon(Icons.bookmark_border),
                                onPressed: () {
                                  // Bookmark logic
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No questions found."));
                }
              },
            ),

            // Tab 2: Traffic Signs list
            ListView.builder(
              itemCount: trafficSigns.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            trafficSigns[index]['image']!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          trafficSigns[index]['sign']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          trafficSigns[index]['description']!,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
