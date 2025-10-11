import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/api_services.dart';
import '../app_colors/app_colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final response = await ApiService.signupUser(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      setState(() => isLoading = false);

      if (response['status'] == 'success') {
        final userId = int.parse(response['data']['id']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', userId);

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userId: userId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Signup failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Sign Up", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) return 'Enter valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                  ),
                  SizedBox(height: 32),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _signup,
                    child: Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppColors.bottomNavSelected,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text("Already have an account? Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
