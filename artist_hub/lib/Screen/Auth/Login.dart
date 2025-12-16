import 'package:flutter/material.dart';
import 'package:artist_hub/Constants/api_urls.dart';
import 'package:artist_hub/Constants/app_colors.dart';
import 'package:artist_hub/Screen/Auth/Register.dart';
import 'package:artist_hub/Services/api_services.dart';
import 'package:artist_hub/Widgets/Common%20Textfields/common_textfields.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/register_model.dart';
import '../Dashboard/Artist Dashboard/artist_dashboard.dart';
import '../Dashboard/Customer Dashboard/customer dashboard.dart';
import '../Shared Preference/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _selectedRole;
  String? _selectedGoogleEmail;

  // Constants
  static const List<String> _roles = ['artist', 'customer'];
  static const Map<String, Map<String, dynamic>> _roleConfig = {
    'artist': {
      'color': Colors.purple,
      'icon': Icons.palette,
      'label': '🎨 Artist',
      'title': 'Artist',
    },
    'customer': {
      'color': Colors.blue,
      'icon': Icons.person,
      'label': '👤 Customer',
      'title': 'Customer',
    },
  };

  // Google Sign-In
  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
    _loadSavedUserData();
  }

  void _initializeGoogleSignIn() {
    _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  }

  Future<void> _loadSavedUserData() async {
    try {
      final savedEmail = SharedPreferencesService.getUserEmail();
      final savedRole = SharedPreferencesService.getUserRole();

      _logData("LOADING SAVED USER DATA", {
        'Saved Email': savedEmail,
        'Saved Role': savedRole,
      });

      if (mounted) {
        setState(() {
          _emailController.text = savedEmail;
          if (savedRole.isNotEmpty && _roles.contains(savedRole)) {
            _selectedRole = savedRole;
          }
        });
      }
    } catch (e) {
      _logError("Error loading saved user data", e);
    }
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  void _logData(String title, Map<String, dynamic> data) {
    print("=== $title ===");
    data.forEach((key, value) => print("$key: $value"));
    print("=" * (title.length + 8));
  }

  void _logError(String message, dynamic error) {
    print("=== ERROR ===");
    print("Message: $message");
    print("Error Type: ${error.runtimeType}");
    print("Error Details: $error");
    print("=============");
  }

  void _showAlert(String message) {
    print("Alert Dialog: $message");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Alert",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }

  // ============================================
  // GOOGLE SIGN-IN - DIRECT LOGIN WITHOUT CONFIRMATION
  // ============================================

  Future<void> _handleGoogleSignIn() async {
    _logData("GOOGLE SIGN IN STARTED", {'Role': _selectedRole});

    if (_selectedRole == null) {
      _showAlert("Please select Artist or Customer role first");
      return;
    }

    setState(() => _isGoogleLoading = true);

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _handleGoogleSignInCancelled();
        return;
      }

      final userEmail = googleUser.email?.toLowerCase() ?? "";
      await _processGoogleUserDirect(googleUser, userEmail);
    } catch (e) {
      _handleGoogleSignInError(e);
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  void _handleGoogleSignInCancelled() {
    print("Google sign in cancelled by user");
    setState(() => _selectedGoogleEmail = null);
  }

  Future<void> _processGoogleUserDirect(GoogleSignInAccount googleUser, String userEmail) async {
    _logData("GOOGLE USER DATA", {
      'User ID': googleUser.id,
      'Display Name': googleUser.displayName,
      'Email': userEmail,
      'Selected Role': _selectedRole,
    });

    setState(() => _selectedGoogleEmail = userEmail);

    // Check if email already registered with different role
    final previousRole = await _getSavedGoogleRole(userEmail);
    if (previousRole != null && previousRole != _selectedRole) {
      await _handleDuplicateGoogleEmail(userEmail, previousRole);
      return;
    }

    // NO CONFIRMATION DIALOG - DIRECT LOGIN
    await _completeGoogleSignInDirect(googleUser, userEmail);
  }

  Future<void> _handleDuplicateGoogleEmail(String userEmail, String previousRole) async {
    _showAlert(
      "🚫 Email Already Registered\n\n"
          "This email '$userEmail' is already registered as '$previousRole'.\n\n"
          "📌 **IMPORTANT RULE:**\n"
          "• One email can be used for ONLY ONE role\n"
          "• Same email cannot be used for both Artist and Customer\n\n"
          "Please:\n"
          "1. Use a different Google account for ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role\n"
          "2. Or login with '$previousRole' role using this email",
    );
    await _cleanupGoogleSignIn();
  }

  Future<void> _completeGoogleSignInDirect(GoogleSignInAccount googleUser, String userEmail) async {
    final googleAuth = await googleUser.authentication;

    final userData = {
      'id': googleUser.id,
      'name': googleUser.displayName ?? 'Google User',
      'email': userEmail,
      'role': _selectedRole,
      'profile_pic': googleUser.photoUrl ?? '',
      'provider': 'google',
      'phone': '',
      'address': '',
      'is_google_user': true,
    };

    _logData("SAVING GOOGLE USER DATA", {
      'Role': _selectedRole,
      'Email': userEmail,
    });

    await SharedPreferencesService.saveUserData(userData);
    await _saveGoogleRole(userEmail, _selectedRole!);

    SharedPreferencesService.printAllData();

    // Show success message briefly
    _showQuickSuccessMessage(googleUser, userEmail);

    // Navigate directly after short delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      _navigateAfterGoogleLogin();
    }
  }

  void _showQuickSuccessMessage(GoogleSignInAccount googleUser, String userEmail) {
    final roleColor = _roleConfig[_selectedRole]!['color'] as Color;
    final roleIcon = _roleConfig[_selectedRole]!['icon'] as IconData;

    // Show a quick snackbar instead of dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: roleColor,
        duration: const Duration(milliseconds: 1500),
        content: Row(
          children: [
            Icon(roleIcon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "✅ Welcome ${googleUser.displayName ?? 'User'}!",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Logged in as ${_selectedRole == 'artist' ? 'Artist' : 'Customer'}",
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cleanupGoogleSignIn() async {
    setState(() {
      _selectedGoogleEmail = null;
    });
    await _googleSignIn.signOut();
  }

  void _handleGoogleSignInError(dynamic error) {
    _logError("GOOGLE SIGN IN ERROR", error);

    String errorMessage = "Google login failed";
    if (error.toString().contains('sign_in_failed')) {
      errorMessage = "Google Sign-In failed. Please check your Google Play Services.";
    } else if (error.toString().contains('network_error')) {
      errorMessage = "Network error. Please check your internet connection.";
    }

    _showAlert("$errorMessage\n\nError details: ${error.toString()}");
  }

  // ============================================
  // EMAIL/PASSWORD LOGIN
  // ============================================

  void _validateLogin() async {
    _logData("VALIDATE LOGIN", {
      'Email': _emailController.text,
      'Password': '[HIDDEN]',
      'Selected Role': _selectedRole,
    });

    if (_selectedRole == null) {
      _showAlert("Please select a role");
      return;
    }
    if (_emailController.text.isEmpty) {
      _showAlert("Please enter email");
    } else if (_passwordController.text.isEmpty) {
      _showAlert("Please enter password");
    } else {
      await _loginUser();
    }
  }

  Future<void> _loginUser() async {
    _logData("LOGIN USER STARTED", {
      'API URL': ApiUrls.loginUrl,
      'Email': _emailController.text,
      'Role': _selectedRole ?? '',
    });

    setState(() => _isLoading = true);

    final data = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "role": _selectedRole ?? '',
    };

    try {
      print("Sending API request...");
      final response = await ApiServices.postApi(ApiUrls.loginUrl, data);

      _logData("API RESPONSE", {
        'Status': response["status"],
        'Code': response["code"],
        'Message': response["message"],
      });

      setState(() => _isLoading = false);

      if (response["status"] == true || response["code"] == 200) {
        await _handleSuccessfulLogin(response);
      } else {
        _handleFailedLogin(response);
      }
    } catch (e) {
      _handleLoginError(e);
    }
  }

  Future<void> _handleSuccessfulLogin(Map<String, dynamic> response) async {
    final registerModel = RegisterModel.fromJson(response);

    if (registerModel.user == null) {
      _showAlert("User data not found in response");
      return;
    }

    final user = registerModel.user!;
    _logData("USER DATA FROM API", {
      'User ID': user.userId,
      'Name': user.name,
      'Email': user.email,
      'Role': user.role,
      'Phone': user.phone,
      'Address': user.address,
      'Profile Pic': user.profilePic,
      'Artist ID': user.artistId,
    });

    final userData = {
      'id': user.userId?.toString() ?? '',
      'name': user.name ?? '',
      'email': user.email ?? '',
      'role': user.role?.toLowerCase() ?? 'customer',
      'phone': user.phone ?? '',
      'address': user.address ?? '',
      'profile_pic': user.profilePic ?? '',
      'artist_id': user.artistId?.toString() ?? '',
    };

    print("=== SAVING TO SHARED PREFERENCES ===");
    await SharedPreferencesService.saveUserData(userData);

    SharedPreferencesService.printAllData();

    final userRole = user.role?.toLowerCase() ?? 'customer';
    print("Login Successful! Role: $userRole");

    // Show quick success message
    _showQuickEmailLoginSuccess(userRole);

    // Navigate directly
    _navigateBasedOnRole(userRole);
  }

  void _showQuickEmailLoginSuccess(String userRole) {
    final roleColor = userRole == 'artist' ? Colors.purple : Colors.blue;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: roleColor,
        duration: const Duration(milliseconds: 1000),
        content: Text(
          "✅ Login Successful as ${userRole == 'artist' ? 'Artist' : 'Customer'}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _handleFailedLogin(Map<String, dynamic> response) {
    print("Login failed: ${response["message"] ?? "No message"}");
    _showAlert(response["message"] ?? "Login failed");
  }

  void _handleLoginError(dynamic error) {
    setState(() => _isLoading = false);
    _logError("LOGIN ERROR", error);

    _showAlert("Connection error: Please check your internet and server connection");
  }

  // ============================================
  // NAVIGATION
  // ============================================

  void _navigateAfterGoogleLogin() {
    if (_selectedRole == 'artist') {
      _navigateToArtistDashboard();
    } else {
      _navigateToCustomerDashboard();
    }
  }

  void _navigateBasedOnRole(String role) {
    if (role == 'artist') {
      _navigateToArtistDashboard();
    } else {
      _navigateToCustomerDashboard();
    }
  }

  void _navigateToArtistDashboard() {
    print("Navigating to Artist Dashboard");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ArtistDashboard()),
          (route) => false,
    );
  }

  void _navigateToCustomerDashboard() {
    print("Navigating to Customer Dashboard");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomerDashboard()),
          (route) => false,
    );
  }

  // ============================================
  // SHARED PREFERENCES HELPERS
  // ============================================

  Future<void> _saveGoogleRole(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('google_role_$email', role);
    print("✅ Saved role '$role' for email: $email");
  }

  Future<String?> _getSavedGoogleRole(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('google_role_$email');
  }

  // ============================================
  // UI BUILDING
  // ============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appBarGradient.colors[0].withOpacity(0.9),
                AppColors.appBarGradient.colors[1].withOpacity(0.7),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileIcon(),
            const SizedBox(height: 5),
            const Text("Login", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),
            _buildLoginCard(),
            const SizedBox(height: 30),
            _buildSignInButton(),
            const SizedBox(height: 25),
            _buildDividerWithText(),
            const SizedBox(height: 25),
            _buildGoogleSignInButton(),
            const SizedBox(height: 25),
            _buildRegisterLink(),
            const SizedBox(height: 20),
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              AppColors.appBarGradient.colors[0].withOpacity(0.9),
              AppColors.appBarGradient.colors[1].withOpacity(0.7),
            ],
          ),
        ),
      ),
      child: Icon(Icons.person, size: 50, color: AppColors.grey600),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRoleDropdown(),
            const SizedBox(height: 15),
            _buildEmailField(),
            const SizedBox(height: 15),
            _buildPasswordField(),
            _buildForgotPasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          value: _selectedRole,
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue;
              _selectedGoogleEmail = null;
              print("Role changed to: $newValue");
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person_outline, color: AppColors.grey600),
            hintText: 'Select Role',
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          items: _roles.map((role) {
            return DropdownMenuItem<String>(
              value: role,
              child: Text(
                _roleConfig[role]!['label'] as String,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }).toList(),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.grey600),
          isExpanded: true,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
          validator: (value) => value == null || value.isEmpty ? 'Please select a role' : null,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CommonTextfields(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      hintText: 'Email Address',
      inputAction: TextInputAction.next,
      preFixIcon: Icon(Icons.email_outlined, color: AppColors.grey600),
    );
  }

  Widget _buildPasswordField() {
    return CommonTextfields(
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      hintText: 'Password',
      obsureText: _obscurePassword,
      inputAction: TextInputAction.done,
      preFixIcon: Icon(Icons.lock_outline, color: AppColors.grey600),
      sufFixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[600],
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _showAlert("Forgot Password feature coming soon!"),
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: AppColors.primaryColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            AppColors.appBarGradient.colors[0].withOpacity(0.9),
            AppColors.appBarGradient.colors[1].withOpacity(0.7),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _validateLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Sign In',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('Or continue with', style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    final buttonColor = _getGoogleButtonColor();
    final buttonText = _getGoogleButtonText();
    final borderColor = buttonColor;

    return Container(
      height: _selectedGoogleEmail != null ? 70 : 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 2),
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: _isGoogleLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.g_mobiledata, size: 24, color: buttonColor),
                const SizedBox(width: 10),
                Text(
                  buttonText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: buttonColor),
                ),
              ],
            ),
            if (_selectedGoogleEmail != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _selectedGoogleEmail!,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getGoogleButtonColor() {
    if (_selectedRole == 'artist') return Colors.purple;
    if (_selectedRole == 'customer') return Colors.blue;
    return Colors.red;
  }

  String _getGoogleButtonText() {
    if (_selectedRole == null) return 'Continue with Google';
    return 'Google Sign-In as ${_roleConfig[_selectedRole]!['label'] as String}';
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppColors.appBarGradient.colors[0].withOpacity(0.9),
                AppColors.appBarGradient.colors[1].withOpacity(0.7),
              ],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
          },
          child: GestureDetector(
            onTap: () {
              print("Navigate to Register screen");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    final roleColor = _getRoleColor();
    final notes = _getRoleNotes();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Note: Your email will be remembered for next login.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: roleColor),
            ),
            child: Column(
              children: [
                Text(
                  "🔐 Google Sign-In Rules:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: roleColor),
                ),
                const SizedBox(height: 5),
                Text(
                  notes,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: roleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor() {
    if (_selectedRole == 'artist') return Colors.purple;
    if (_selectedRole == 'customer') return Colors.blue;
    return Colors.grey[700]!;
  }

  String _getRoleNotes() {
    if (_selectedRole == null) {
      return "• Select Artist or Customer role\n• One email = One role only";
    }
    return "• Use any Gmail for ${_selectedRole == 'artist' ? 'Artist' : 'Customer'}\n"
        "• Email permanently linked to role\n"
        "• Same email cannot be used for both roles";
  }
}