// edit_profile.dart
import 'package:flutter/material.dart';
import 'package:budget_app/api_services/api_services.dart';
import 'package:budget_app/app_colors/app_colors.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  final String currentName;
  final String currentEmail;
  const EditProfile({super.key, required this.userId, required this.currentName, required this.currentEmail});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _name;
  late TextEditingController _email;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.currentName);
    _email = TextEditingController(text: widget.currentEmail);
  }

  Future<void> _update() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final resp = await ApiService.updateUser(id: widget.userId, name: _name.text.trim(), email: _email.text.trim());
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Updated')));
    if (resp['code'] == 200 || resp['data']?['success'] == true) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.bottomNavSelected, body: Column(children: [
      const SizedBox(height: 40),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)), const SizedBox(width: 10), const Text('Edit My Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const Spacer(), const Icon(Icons.notifications_none, color: Colors.white)])),
      const SizedBox(height: 20),
      Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30), decoration: const BoxDecoration(color: Color(0xFFF3FFF8), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))), child: Column(children: [
        Stack(children: [const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)), Positioned(bottom: 0, right: 4, child: Container(decoration: const BoxDecoration(color: Color(0xFF00DFA2), shape: BoxShape.circle), padding: const EdgeInsets.all(6), child: const Icon(Icons.camera_alt, size: 18, color: Colors.white)))]),
        const SizedBox(height: 10),
        Text(_name.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('ID: ${widget.userId}', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        const Align(alignment: Alignment.centerLeft, child: Text('Account Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        const SizedBox(height: 12),
        TextField(controller: _name, decoration: InputDecoration(labelText: 'Username', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 12),
        TextField(controller: _email, decoration: InputDecoration(labelText: 'Email Address', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _loading ? null : _update, style: ElevatedButton.styleFrom(backgroundColor: AppColors.bottomNavSelected, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: _loading ? const CircularProgressIndicator() : const Text('Update Profile', style: TextStyle(color: Colors.white)))),
      ])))
    ]));
  }
}
