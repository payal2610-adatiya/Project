// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:budget_app/shared_preference/shared_pref.dart';
import 'package:budget_app/dashboard/home.dart';
import 'package:budget_app/screens/auth/login.dart';
import 'package:budget_app/screens/intro/intro.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final firstLaunch = await Pref.isFirstLaunch();
    final userId = await Pref.getUserId();

    if (!mounted) return;

    if (firstLaunch) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Intro()));
      await Pref.setFirstLaunchDone();
    } else if (userId != null && userId.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home(userId: userId)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.account_balance_wallet_rounded, size: 90, color: Colors.white),
            SizedBox(height: 24),
            Text('Budget App', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Track • Manage • Save', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
          ]),
        ),
      ),
    );
  }
}
