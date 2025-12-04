import 'dart:convert';
import 'package:budget_app/login_signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/summary_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final passRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,}$');

  bool _loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/budget_app/login.php"), // 👈 use 10.0.2.2 for emulator
        body: {
          "email": emailController.text.trim(),
          "password": passController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        // Save user ID locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("logged_user_id", int.parse(data["id"].toString()));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Dashboard(userId: int.parse(data["id"].toString())),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Invalid credentials")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_circle,
                          size: 80, color: Colors.black54),
                      SizedBox(height: 12),
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Login to continue",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 25),

                      // Email
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.black54),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter email";
                          } else if (!emailRegex.hasMatch(val)) {
                            return "Enter valid email (e.g. user@gmail.com)";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 18),

                      // Password
                      TextFormField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.black54),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter password";
                          } else if (!passRegex.hasMatch(val)) {
                            return "Password must be 4+ chars with letters & numbers";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.black54,
                          ),
                          child: _loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Go to Signup
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );
                        },
                        child: Text(
                          "Don’t have an account? Sign up",
                          style: TextStyle(color: Colors.pink.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
