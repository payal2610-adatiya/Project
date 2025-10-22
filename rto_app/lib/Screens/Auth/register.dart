import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Widgets/Custom Textfield/custom_textfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTO Registration', style: TextStyle(color: Colors.black)),
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
                    controller: name,
                    keyboardType: TextInputType.text,
                    preFixIcon: Icon(Icons.person),
                    hintText: 'Enter Full Name',
                  ),
                ),
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
                    controller: password,
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
                        String reg_name = name.text.toString();
                        String reg_email = email.text.toString();
                        String reg_password = password.text.toString();
                        if (reg_name.isNotEmpty && reg_email.isNotEmpty && reg_password.isNotEmpty) {
                          register(reg_name, reg_email, reg_password);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                        }
                      }
                    },
                    child: Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  register(String reg_name, String reg_email, String reg_password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse("https://prakrutitech.xyz/gaurang/gr_add_user.php");
      var resp = await http.post(url, body: {
        "name": reg_name,
        "email": reg_email,
        "password": reg_password
      });

      var data = jsonDecode(resp.body);
      if (data == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed. Email may already exist.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful!')),
        );
        Navigator.pop(context);
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