import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rto_driving_license/Screens/Auth/register.dart';
import 'package:rto_driving_license/Screens/Dashboard/home.dart';
import 'package:rto_driving_license/Widgets/Custom%20Button/custom_button.dart';
import 'package:rto_driving_license/Widgets/Custom%20Textfield/custom_textfield.dart';
import '../../Widgets/App Colors/AppColors.dart';
import '../../SharedPreference/SharePref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTO Login', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Image.asset('assets/logo.png'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: CustomTextfield(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    preFixIcon: Icon(Icons.email),
                    hintText: 'Enter Email Address',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: CustomTextfield(
                    controller: pass,
                    keyboardType: TextInputType.visiblePassword,
                    preFixIcon: Icon(Icons.password),
                    hintText: 'Enter Password',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        String e = email.text.toString();
                        String p = pass.text.toString();
                        if (e.isNotEmpty && p.isNotEmpty) {
                          login(e, p);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: CustomButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));
                    },
                    child: Text("Don't have an account? Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login(var mail, var password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse("https://prakrutitech.xyz/gaurang/gr_login_user.php");
      var resp = await http.post(
        url,
        body: {"email": mail, "password": password},
      );
      var data = jsonDecode(resp.body);
      if (data == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed. Invalid credentials.')),
        );
      } else {
        // Save login status and user email
        await SharedPref.saveLoginStatus(true);
        await SharedPref.saveUserEmail(mail);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}