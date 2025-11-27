import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../role/backend_developer/backend_developer_dashboard.dart';
import '../role/designer/designer_dashboard.dart';
import '../role/developer/developer_dashboard.dart';
import '../role/tester/tester_dashboard.dart';
import 'auth/login_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), checkUser);
  }

  void checkUser() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.isLoggedIn) {
      final role = auth.userRole.toLowerCase();

      if (role == "designer") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DesignerDashboard()));
      }
      else if (role == "developer") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DeveloperDashboard()));
      }
      else if (role == "backend") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BackendDashboard()));
      }
      else if (role == "tester") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TesterDashboard()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apps, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Project Flow Manager",
              style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
