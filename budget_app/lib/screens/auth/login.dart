// login.dart
import 'package:flutter/material.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/shared_preference/shared_pref.dart';
import 'package:budget_app/dashboard/home.dart';
import 'package:budget_app/screens/auth/signup.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    final email = _email.text.trim();
    final pass = _pass.text.trim();

    final resp = await ApiService.loginUser(email: email, password: pass);
    setState(() => _loading = false);

    if (resp['code'] == 200 || resp['data']?['success'] == true) {
      final userId = resp['data']?['user']?['id']?.toString() ?? resp['data']?['user_id']?.toString() ?? '';
      if (userId.isNotEmpty) {
        await Pref.setLoginDone(email, userId);
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home(userId: userId)));
        return;
      }
    }

    final message = resp['message']?.toString() ?? 'Login failed';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
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
        const SizedBox(height: 80, child: Center(child: Text('Login to Budget App', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)))),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]), borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)), validator: (v) => v == null || v.isEmpty ? 'Enter email' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), validator: (v) => v == null || v.length < 6 ? 'Enter valid password' : null),
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _loading ? null : _login, style: ElevatedButton.styleFrom(backgroundColor: AppColors.bottomNavSelected, minimumSize: const Size.fromHeight(50)), child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login')),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: const Text("Don't have an account? Sign up"))
                  ]),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
