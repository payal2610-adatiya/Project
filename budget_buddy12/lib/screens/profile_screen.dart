import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/api_services.dart';
import '../app_colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final VoidCallback onProfileUpdated;
  final VoidCallback logoutCallback;

  const ProfileScreen({required this.userId, required this.onProfileUpdated, required this.logoutCallback});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final response = await ApiService.viewUsers();
    final user = response.firstWhere((u) => int.parse(u['id']) == widget.userId);
    setState(() {
      nameController.text = user['name'];
      emailController.text = user['email'];
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final response = await ApiService.updateUser(widget.userId, nameController.text, emailController.text);
      setState(() => isLoading = false);
      if (response['status'] == 'success') {
        widget.onProfileUpdated();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Update failed')));
      }
    }
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
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
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.bottomNavSelected,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dark Theme"),
              Switch(
                  value: isDark,
                  onChanged: (val) {
                    setState(() {
                      isDark = val;
                      // Implement theme toggle logic here (optional)
                    });
                  }),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.logoutCallback,
            child: Text("Logout"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: AppColors.deleteIcon,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
