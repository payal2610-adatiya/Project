// security.dart
import 'package:flutter/material.dart';

class Security extends StatelessWidget {
  const Security({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pinkAccent, body: Column(children: [
      const SizedBox(height: 60),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)), const SizedBox(width: 10), const Text('Security', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])),
      const SizedBox(height: 20),
      Expanded(child: Container(width: double.infinity, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))), padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildOption(Icons.lock, 'Change Password', () {}),
        _buildOption(Icons.fingerprint, 'Biometric Login', () {}),
        _buildOption(Icons.visibility_off, 'Privacy Settings', () {}),
        _buildOption(Icons.security, 'Two-Factor Authentication', () {}),
      ]))),
    ]));
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: onTap));
  }
}
