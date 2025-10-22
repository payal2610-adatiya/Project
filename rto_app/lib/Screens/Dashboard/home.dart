import 'package:flutter/material.dart';
import 'package:rto_app/Screens/Dashboard/question.dart';
import '../../Widgets/App Colors/AppColors.dart';
import '../../Widgets/Custom Appbar/custom_appbar.dart';
import '../Practice/practice.dart';
import '../Process Of License/processOfLicense.dart';
import '../RTO Offices/rto_offices.dart';
import 'Exam.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(title: 'Dashboard', centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final cards = [
              {
                'title': 'Question Bank',
                'description':
                    'List of questions & answers and meaning of road signs',
                'image': 'assets/book.png',
              },
              {
                'title': 'Practice',
                'description':
                    'Practice your knowledge without worrying about time',
                'image': 'assets/practice.png',
              },
              {
                'title': 'Exam',
                'description':
                    'Exam with time and questions like actual RTO test',
                'image': 'assets/exam.png',
              },
              {
                'title': 'RTO Offices',
                'description':
                    'Check RTO Offices in State Capital',
                'image': 'assets/driving.png',
              },
              {
                'title': 'Statistics',
                'description':
                'Search and connect with driving schools near you',
                'image': 'assets/driving.png',
              },
              {
                'title': 'Process of Driving License',
                'description': 'New license, Renewal License',
                'image': 'assets/settings.png',
              },
            ];

            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionBankScreen(),
                    ),
                  );
                }
                if (index == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Practice(),));
                }
                if (index == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Exam()));
                }
                if (index == 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RtoOffices()));
                }
                if (index == 4) {

                }
                if (index == 5) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Processoflicense()));
                }
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Image.asset(
                          height: 50,width: 50,
                          cards[index]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        cards[index]['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        flex: 3,
                        child: Text(
                          cards[index]['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
