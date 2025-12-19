// signup.dart
import 'package:flutter/material.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/shared_preference/shared_pref.dart';
import 'package:budget_app/dashboard/home.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    final resp = await ApiService.signupUser(name: _name.text.trim(), email: _email.text.trim(), password: _pass.text.trim());
    setState(() => _loading = false);

    if (resp['code'] == 200 || resp['data']?['success'] == true) {
      // auto login if available
      final loginResp = await ApiService.loginUser(email: _email.text.trim(), password: _pass.text.trim());
      final userId = loginResp['data']?['user']?['id']?.toString() ?? '';
      if (userId.isNotEmpty) {
        await Pref.setLoginDone(_email.text.trim(), userId);
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home(userId: userId)));
        return;
      }
    }

    final message = resp['message'] ?? 'Signup failed';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomNavSelected,
      body: Column(children: [
        const SizedBox(height: 40),
        const SizedBox(height: 80, child: Center(child: Text('Signup to Budget App', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]), borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(children: [
                  const SizedBox(height: 24),
                  TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)), validator: (v) => v == null || v.isEmpty ? 'Enter name' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)), validator: (v) => v == null || v.isEmpty ? 'Enter email' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 chars' : null),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _loading ? null : _signup, style: ElevatedButton.styleFrom(backgroundColor: AppColors.bottomNavSelected, minimumSize: const Size.fromHeight(50)), child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up')),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Already have an account? Login')),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
