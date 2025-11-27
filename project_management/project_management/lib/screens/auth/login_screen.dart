import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../role/backend_developer/backend_developer_dashboard.dart';
import '../../role/designer/designer_dashboard.dart';
import '../../role/developer/developer_dashboard.dart';
import '../../role/tester/tester_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String role = "designer";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Project Flow Login", style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
            SizedBox(height: 30),

            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: pass, decoration: InputDecoration(labelText: "Password"), obscureText: true),

            DropdownButton<String>(
              value: role,
              items: ["designer","developer","backend","tester"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                  .toList(),
              onChanged: (v) => setState(() => role = v!),
            ),

            SizedBox(height:25),
            ElevatedButton(
              child: loading ? CircularProgressIndicator(color: Colors.white) : Text("Login"),
              onPressed: () async {
                setState(()=>loading=true);
                bool ok = await auth.login(email.text,pass.text,role);
                setState(()=>loading=false);

                if(ok){
                  if(role=="designer") Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>DesignerDashboard()));
                  else if(role=="developer") Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>DeveloperDashboard()));
                  else if(role=="backend") Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>BackendDashboard()));
                  else Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>TesterDashboard()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension Cap on String {
  String capitalize()=> this[0].toUpperCase()+this.substring(1);
}
