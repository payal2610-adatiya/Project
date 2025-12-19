import 'package:flutter/material.dart';
import '../api_services/api_services.dart';
import '../screens/auth/login.dart';
import '../screens/edit_profile.dart';
import '../screens/help.dart';
import '../screens/security.dart';
import '../shared_preference/shared_pref.dart';

class ProfileTab extends StatefulWidget {
  final String userId;
  const ProfileTab({super.key, required this.userId});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() => isLoading = true);
    try {
      final response = await ApiService.viewUser(widget.userId);

      if (response['code'] == 200 &&
          response['users'] != null &&
          response['users'].isNotEmpty) {
        final usersList = response['users'];
        final currentUser = usersList.firstWhere(
              (user) => user['id'].toString() == widget.userId,
          orElse: () => usersList.isNotEmpty ? usersList[0] : null,
        );

        if (currentUser != null) {
          setState(() => userData = currentUser);
        } else {
          setState(() => userData = null);
        }
      } else {
        setState(() => userData = null);
      }
    } catch (e) {
      setState(() => userData = null);
    }
    setState(() => isLoading = false);
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Pref.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Icon(Icons.notifications_none, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 30),
                    _buildProfileOptions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          userData?['name'] ?? 'User',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          userData?['email'] ?? 'No Email',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          "ID: ${userData?['id'] ?? widget.userId}",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildProfileOption(
          Icons.person_outline,
          'Edit Profile',
          Colors.blue,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfile(
                  userId: widget.userId,
                  currentName: userData?['name'] ?? '',
                  currentEmail: userData?['email'] ?? '',
                ),
              ),
            ).then((_) => fetchUser());
          },
        ),

        _buildProfileOption(
          Icons.help_outline,
          'Help & Support',
          Colors.purple,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Help()),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildProfileOption(
          Icons.logout,
          'Logout',
          Colors.red,
          _logout,
        ),
      ],
    );
  }

  Widget _buildProfileOption(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: onTap,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
