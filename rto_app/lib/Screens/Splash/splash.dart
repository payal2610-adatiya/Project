import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../Auth/login.dart';
import '../Connectivity  Error/connectivity_error_screen.dart';
import '../Dashboard/home.dart';
import '../SharedPreference/SharePref.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Delay 2 sec to show logo before checking
    Future.delayed(const Duration(seconds: 2), _checkConnectivity);
  }

  void _checkConnectivity() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
          if (_navigated) return; // prevent double navigation

          if (result.contains(ConnectivityResult.mobile) ||
              result.contains(ConnectivityResult.wifi)) {
            bool isLoggedIn = await SharedPref.getLoginStatus();

            setState(() {
              _navigated = true;
            });

            if (isLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            }
          } else {
            setState(() {
              _navigated = true;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ConnectivityErrorScreen()),
            );
          }
        });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
          height: 150,
        ),
      ),
    );
  }
}
