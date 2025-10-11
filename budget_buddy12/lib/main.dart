import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(BudgetBuddyApp());
  });
}

class BudgetBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      title: 'Budget Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => SplashScreen(),
      //   //'/login': (context) => LoginScreen(),
      //   //'/signup': (context) => SignupScreen(),
      //   '/home': (context) {
      //     // HomeScreen needs userId, will be passed via arguments
      //     final args = ModalRoute.of(context)!.settings.arguments as int?;
      //     if (args != null) return HomeScreen(userId: args);
      //     return SplashScreen(); // fallback
      //   },
      // },
    );
  }
}
