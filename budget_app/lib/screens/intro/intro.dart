// intro.dart
import 'package:flutter/material.dart';
import 'package:budget_app/screens/auth/login.dart';
import 'package:budget_app/app_colors/app_colors.dart';
import 'package:budget_app/shared_preference/shared_pref.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final PageController _pc = PageController();
  int _index = 0;
  final List<Map<String, String>> pages = [
    {'title': 'Welcome To Budget App', 'subtitle': 'Track expenses and control finances', 'image': 'assets/intro1.png'},
    {'title': 'Take Control', 'subtitle': 'Add categories and transactions easily', 'image': 'assets/intro2.png'},
  ];

  void _next() async {
    if (_index < pages.length - 1) {
      _pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      await Pref.setFirstLaunchDone();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomNavSelected,
      body: PageView.builder(
        controller: _pc,
        itemCount: pages.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, index) {
          final item = pages[index];
          return Column(
            children: [
              const SizedBox(height: 80),
              Text(item['title']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // keep your asset images; ensure they exist
                    Image.asset(item['image']!, height: 220, fit: BoxFit.contain),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(item['subtitle']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(onPressed: _next, style: ElevatedButton.styleFrom(backgroundColor: AppColors.bottomNavSelected), child: Text(_index == pages.length - 1 ? 'Get Started' : 'Next')),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(pages.length, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _index == i ? AppColors.bottomNavSelected : Colors.grey)))),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
