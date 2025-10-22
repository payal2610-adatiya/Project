import 'package:flutter/material.dart';

class ConnectivityErrorScreen extends StatefulWidget {
  const ConnectivityErrorScreen({super.key});

  @override
  State<ConnectivityErrorScreen> createState() => _ConnectivityErrorScreenState();
}

class _ConnectivityErrorScreenState extends State<ConnectivityErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                '\t\t \tOOPS! \nNo Internet',
                style: TextStyle(fontSize: 35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
