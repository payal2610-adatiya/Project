// import 'package:flutter/material.dart';
// import 'package:artist_hub/Constants/api_urls.dart';
// import 'package:artist_hub/Constants/app_colors.dart';
// import 'package:artist_hub/Screen/Auth/Register.dart';
// import 'package:artist_hub/Services/api_services.dart';
// import 'package:artist_hub/Widgets/Common%20Textfields/common_textfields.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Models/register_model.dart';
// import '../Dashboard/Artist Dashboard/artist_dashboard.dart';
// import '../Dashboard/Customer Dashboard/customer dashboard.dart';
// import '../Shared Preference/shared_pref.dart';
//
// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//   bool _isGoogleLoading = false;
//   String? _selectedRole;
//   final List<String> _roles = ['artist', 'customer'];
//   late final GoogleSignIn _googleSignIn;
//
//   // Track if Google account was selected
//   String? _selectedGoogleEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
//     _loadSavedUserData();
//   }
//
//   Future<void> _loadSavedUserData() async {
//     try {
//       String savedEmail = SharedPreferencesService.getUserEmail();
//       String savedRole = SharedPreferencesService.getUserRole();
//       print("=== LOADING SAVED USER DATA ===");
//       print("Saved Email: $savedEmail");
//       print("Saved Role: $savedRole");
//       print("================================");
//
//       if (mounted) {
//         setState(() {
//           email.text = savedEmail;
//           if (savedRole.isNotEmpty && _roles.contains(savedRole)) {
//             _selectedRole = savedRole;
//           }
//         });
//       }
//     } catch (e) {
//       print("Error loading saved user data: $e");
//     }
//   }
//
//   void showAlert(String msg) {
//     print("Alert Dialog: $msg");
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(
//           "Alert",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.primaryColor,
//           ),
//         ),
//         content: Text(msg, textAlign: TextAlign.center),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK", style: TextStyle(color: AppColors.primaryColor)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ============================================
//   // GOOGLE SIGN-IN WITH ROLE RESTRICTION ONLY
//   // (No keyword requirement - any email allowed)
//   // ============================================
//   Future<void> signInWithGoogle() async {
//     print("=== GOOGLE SIGN IN STARTED ===");
//
//     // User must select role first
//     if (_selectedRole == null) {
//       showAlert("Please select Artist or Customer role first");
//       return;
//     }
//
//     setState(() {
//       _isGoogleLoading = true;
//     });
//
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         print("Google sign in cancelled by user");
//         setState(() {
//           _isGoogleLoading = false;
//           _selectedGoogleEmail = null;
//         });
//         showAlert("Google sign in cancelled");
//         return;
//       }
//
//       print("=== GOOGLE USER DATA ===");
//       print("User ID: ${googleUser.id}");
//       print("Display Name: ${googleUser.displayName}");
//       print("Email: ${googleUser.email}");
//       print("Selected Role: $_selectedRole");
//       print("=========================");
//
//       // Convert email to lowercase
//       String userEmail = googleUser.email?.toLowerCase() ?? "";
//
//       // Store the selected email for UI display
//       setState(() {
//         _selectedGoogleEmail = userEmail;
//       });
//
//       // ============================================
//       // ONLY CHECK: Same email cannot be used for both roles
//       // (NO keyword requirement - any email allowed)
//       // ============================================
//       String? previousRole = await _getSavedGoogleRole(userEmail);
//       if (previousRole != null && previousRole.isNotEmpty && previousRole != _selectedRole) {
//         setState(() {
//           _isGoogleLoading = false;
//           _selectedGoogleEmail = null;
//         });
//         showAlert("🚫 Email Already Registered\n\n"
//             "This email '$userEmail' is already registered as '$previousRole'.\n\n"
//             "📌 **IMPORTANT RULE:**\n"
//             "• One email can be used for ONLY ONE role\n"
//             "• Same email cannot be used for both Artist and Customer\n\n"
//             "Please:\n"
//             "1. Use a different Google account for ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role\n"
//             "2. Or login with '$previousRole' role using this email");
//         await _googleSignIn.signOut();
//         return;
//       }
//
//       // ============================================
//       // SHOW EMAIL CONFIRMATION DIALOG
//       // ============================================
//       bool confirmLogin = await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           title: Row(
//             children: [
//               Icon(
//                 _selectedRole == 'artist' ? Icons.palette : Icons.person,
//                 color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//               ),
//               SizedBox(width: 10),
//               Text("Confirm ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} Login"),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundImage: googleUser.photoUrl != null
//                     ? NetworkImage(googleUser.photoUrl!)
//                     : null,
//                 child: googleUser.photoUrl == null
//                     ? Icon(Icons.account_circle, size: 40)
//                     : null,
//               ),
//               SizedBox(height: 15),
//               Text(
//                 "You are signing in as:",
//                 style: TextStyle(color: Colors.grey),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: _selectedRole == 'artist'
//                       ? Colors.purple.withOpacity(0.1)
//                       : Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           _selectedRole == 'artist' ? Icons.palette : Icons.person,
//                           color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           _selectedRole == 'artist' ? '🎨 ARTIST' : '👤 CUSTOMER',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Divider(),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(Icons.email, size: 16, color: Colors.grey),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             userEmail,
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "This email will be permanently linked to ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role",
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.orange[700],
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 "Is this correct?",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           actions: [
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.pop(context, false);
//                     },
//                     child: Text("No, Cancel"),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context, true);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                     ),
//                     child: Text("Yes, Login", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ) ?? false;
//
//       if (!confirmLogin) {
//         setState(() {
//           _isGoogleLoading = false;
//           _selectedGoogleEmail = null;
//         });
//         await _googleSignIn.signOut();
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       Map<String, dynamic> userData = {
//         'id': googleUser.id,
//         'name': googleUser.displayName ?? 'Google User',
//         'email': userEmail,
//         'role': _selectedRole,
//         'profile_pic': googleUser.photoUrl ?? '',
//         'provider': 'google',
//         'phone': '',
//         'address': '',
//         'is_google_user': true,
//       };
//
//       print("=== SAVING GOOGLE USER DATA ===");
//       print("Role: $_selectedRole");
//       print("Email: $userEmail");
//
//       // Save user data to SharedPreferences
//       await SharedPreferencesService.saveUserData(userData);
//
//       // Save Google email-role mapping for future validation
//       await _saveGoogleRole(userEmail, _selectedRole!);
//
//       print("=== AFTER SAVING DATA ===");
//       SharedPreferencesService.printAllData();
//
//       setState(() {
//         _isGoogleLoading = false;
//       });
//
//       // Show success message
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           title: Text("✅ Login Successful!", textAlign: TextAlign.center),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 _selectedRole == 'artist' ? Icons.palette : Icons.person,
//                 size: 50,
//                 color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Welcome ${googleUser.displayName ?? 'User'}!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: _selectedRole == 'artist' ? Colors.purple.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Registered as: ${_selectedRole!.toUpperCase()}",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       "Email: $userEmail",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                     SizedBox(height: 10),
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.green[50],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.green[200]!),
//                       ),
//                       child: Text(
//                         "✅ This email is now permanently linked to ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.green[800],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _navigateAfterGoogleLogin();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _selectedRole == 'artist' ? Colors.purple : Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                 ),
//                 child: Text("Continue to Dashboard", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       );
//
//     } catch (e) {
//       setState(() {
//         _isGoogleLoading = false;
//         _selectedGoogleEmail = null;
//       });
//       print("=== GOOGLE SIGN IN ERROR ===");
//       print("Error Type: ${e.runtimeType}");
//       print("Error Message: ${e.toString()}");
//       print("============================");
//
//       String errorMessage = "Google login failed";
//       if (e.toString().contains('sign_in_failed')) {
//         errorMessage = "Google Sign-In failed. Please check your Google Play Services.";
//       } else if (e.toString().contains('network_error')) {
//         errorMessage = "Network error. Please check your internet connection.";
//       }
//       showAlert("$errorMessage\n\nError details: ${e.toString()}");
//     }
//   }
//
//   // Helper methods to save/get Google user roles by email
//   Future<void> _saveGoogleRole(String email, String role) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('google_role_$email', role);
//     print("✅ Saved role '$role' for email: $email");
//   }
//
//   Future<String?> _getSavedGoogleRole(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('google_role_$email');
//   }
//
//   void _navigateAfterGoogleLogin() {
//     if (_selectedRole == 'artist') {
//       print("Navigating to Artist Dashboard");
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const ArtistDashboard()),
//             (route) => false,
//       );
//     } else {
//       print("Navigating to Customer Dashboard");
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const CustomerDashboard()),
//             (route) => false,
//       );
//     }
//   }
//
//   // ============================================
//   // EMAIL/PASSWORD LOGIN (UNCHANGED)
//   // ============================================
//   void validateLogin() async {
//     print("=== VALIDATE LOGIN ===");
//     print("Email: ${email.text}");
//     print("Password: ${password.text}");
//     print("Selected Role: $_selectedRole");
//
//     if (_selectedRole == null) {
//       showAlert("Please select a role");
//       return;
//     }
//     if (email.text.isEmpty) {
//       showAlert("Please enter email");
//     } else if (password.text.isEmpty) {
//       showAlert("Please enter password");
//     } else {
//       await loginUser();
//     }
//   }
//
//   Future<void> loginUser() async {
//     print("=== LOGIN USER STARTED ===");
//     print("API URL: ${ApiUrls.loginUrl}");
//     print("Login Data:");
//     print("- Email: ${email.text}");
//     print("- Password: [HIDDEN]");
//     print("- Role: ${_selectedRole ?? ''}");
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     Map<String, dynamic> data = {
//       "email": email.text,
//       "password": password.text,
//       "role": _selectedRole ?? '',
//     };
//
//     try {
//       print("Sending API request...");
//       var response = await ApiServices.postApi(ApiUrls.loginUrl, data);
//
//       print("=== API RESPONSE ===");
//       print("Full Response: $response");
//       print("Status: ${response["status"]}");
//       print("Code: ${response["code"]}");
//       print("Message: ${response["message"]}");
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       if (response["status"] == true || response["code"] == 200) {
//         var registerModel = RegisterModel.fromJson(response);
//
//         if (registerModel.user != null) {
//           print("=== USER DATA FROM API ===");
//           print("User ID: ${registerModel.user!.userId}");
//           print("Name: ${registerModel.user!.name}");
//           print("Email: ${registerModel.user!.email}");
//           print("Role: ${registerModel.user!.role}");
//           print("Phone: ${registerModel.user!.phone}");
//           print("Address: ${registerModel.user!.address}");
//           print("Profile Pic: ${registerModel.user!.profilePic}");
//           print("Artist ID: ${registerModel.user!.artistId}");
//           print("===========================");
//
//           Map<String, dynamic> userData = {
//             'id': registerModel.user!.userId?.toString() ?? '',
//             'name': registerModel.user!.name ?? '',
//             'email': registerModel.user!.email ?? '',
//             'role': registerModel.user!.role?.toLowerCase() ?? 'customer',
//             'phone': registerModel.user!.phone ?? '',
//             'address': registerModel.user!.address ?? '',
//             'profile_pic': registerModel.user!.profilePic ?? '',
//             'artist_id': registerModel.user!.artistId?.toString() ?? '',
//           };
//
//           print("=== SAVING TO SHARED PREFERENCES ===");
//           await SharedPreferencesService.saveUserData(userData);
//
//           print("=== AFTER SAVING DATA ===");
//           SharedPreferencesService.printAllData();
//
//           String userRole = registerModel.user!.role?.toLowerCase() ?? 'customer';
//
//           print("Login Successful! Role: $userRole");
//           showAlert("Login Successful");
//
//           await Future.delayed(const Duration(milliseconds: 1500));
//           Navigator.of(context, rootNavigator: true).pop();
//
//           if (userRole == 'artist') {
//             print("Navigating to Artist Dashboard");
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const ArtistDashboard()),
//                   (route) => false,
//             );
//           } else {
//             print("Navigating to Customer Dashboard");
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const CustomerDashboard()),
//                   (route) => false,
//             );
//           }
//         } else {
//           print("ERROR: User data not found in response");
//           showAlert("User data not found in response");
//         }
//       } else {
//         print("Login failed: ${response["message"] ?? "No message"}");
//         showAlert(response["message"] ?? "Login failed");
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//
//       print("=== LOGIN ERROR ===");
//       print("Error Type: ${e.runtimeType}");
//       print("Error Message: ${e.toString()}");
//       print("====================");
//
//       showAlert("Connection error: Please check your internet and server connection");
//       print("Login Error Details: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.appBarGradient.colors[0].withOpacity(0.9),
//                 AppColors.appBarGradient.colors[1].withOpacity(0.7),
//               ],
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       Text(
//                         "Welcome Back",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "Sign in to your account",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white.withOpacity(0.9),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         Container(
//                           width: 100,
//                           height: 100,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey[100],
//                             border: GradientBoxBorder(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   AppColors.appBarGradient.colors[0].withOpacity(0.9),
//                                   AppColors.appBarGradient.colors[1].withOpacity(0.7),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           child: Icon(
//                             Icons.person,
//                             size: 50,
//                             color: AppColors.grey600,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           "Login",
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[50]!,
//                             borderRadius: BorderRadius.circular(15),
//                             border: Border.all(
//                               color: Colors.grey[200]!,
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       color: Colors.grey[300]!,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                                     child: DropdownButtonFormField<String>(
//                                       value: _selectedRole,
//                                       onChanged: (String? newValue) {
//                                         setState(() {
//                                           _selectedRole = newValue;
//                                           _selectedGoogleEmail = null; // Clear selected email when role changes
//                                           print("Role changed to: $newValue");
//                                         });
//                                       },
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         prefixIcon: Icon(
//                                           Icons.person_outline,
//                                           color: AppColors.grey600,
//                                         ),
//                                         hintText: 'Select Role',
//                                         hintStyle: TextStyle(color: Colors.grey[500]),
//                                       ),
//                                       items: _roles.map((String role) {
//                                         return DropdownMenuItem<String>(
//                                           value: role,
//                                           child: Text(
//                                             role == 'artist' ? '🎨 Artist' : '👤 Customer',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.grey[700],
//                                             ),
//                                           ),
//                                         );
//                                       }).toList(),
//                                       icon: Icon(
//                                         Icons.arrow_drop_down,
//                                         color: AppColors.grey600,
//                                       ),
//                                       isExpanded: true,
//                                       dropdownColor: Colors.white,
//                                       style: TextStyle(
//                                         color: Colors.grey[700],
//                                         fontSize: 16,
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Please select a role';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 15),
//                                 CommonTextfields(
//                                   keyboardType: TextInputType.emailAddress,
//                                   controller: email,
//                                   hintText: 'Email Address',
//                                   inputAction: TextInputAction.next,
//                                   preFixIcon: Icon(
//                                     Icons.email_outlined,
//                                     color: AppColors.grey600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 15),
//                                 CommonTextfields(
//                                   keyboardType: TextInputType.visiblePassword,
//                                   controller: password,
//                                   hintText: 'Password',
//                                   obsureText: _obscurePassword,
//                                   inputAction: TextInputAction.done,
//                                   preFixIcon: Icon(
//                                     Icons.lock_outline,
//                                     color: AppColors.grey600,
//                                   ),
//                                   sufFixIcon: IconButton(
//                                     icon: Icon(
//                                       _obscurePassword
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: Colors.grey[600],
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _obscurePassword = !_obscurePassword;
//                                         print("Password visibility toggled: $_obscurePassword");
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: TextButton(
//                                     onPressed: () {
//                                       print("Forgot Password clicked");
//                                       showAlert("Forgot Password feature coming soon!");
//                                     },
//                                     child: Text(
//                                       "Forgot Password?",
//                                       style: TextStyle(
//                                         color: AppColors.primaryColor,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         Container(
//                           height: 50,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.appBarGradient.colors[0].withOpacity(0.9),
//                                 AppColors.appBarGradient.colors[1].withOpacity(0.7),
//                               ],
//                             ),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: _isLoading ? null : validateLogin,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: _isLoading
//                                 ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: const AlwaysStoppedAnimation<Color>(
//                                     Colors.white),
//                               ),
//                             )
//                                 : Text(
//                               'Sign In',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         Row(
//                           children: [
//                             Expanded(child: Divider(color: Colors.grey[300])),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               child: Text(
//                                 'Or continue with',
//                                 style: TextStyle(color: Colors.grey[600]),
//                               ),
//                             ),
//                             Expanded(child: Divider(color: Colors.grey[300])),
//                           ],
//                         ),
//                         const SizedBox(height: 25),
//                         // ============================================
//                         // GOOGLE SIGN-IN BUTTON WITH EMAIL DISPLAY
//                         // ============================================
//                         Container(
//                           height: _selectedGoogleEmail != null ? 70 : 50,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             border: Border.all(
//                               color: _selectedRole == 'artist'
//                                   ? Colors.purple
//                                   : _selectedRole == 'customer'
//                                   ? Colors.blue
//                                   : Colors.grey[300]!,
//                               width: 2,
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: ElevatedButton(
//                             onPressed: _isGoogleLoading ? null : signInWithGoogle,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Colors.black,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: _isGoogleLoading
//                                 ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//                               ),
//                             )
//                                 : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.g_mobiledata,
//                                       size: 24,
//                                       color: _selectedRole == 'artist'
//                                           ? Colors.purple
//                                           : _selectedRole == 'customer'
//                                           ? Colors.blue
//                                           : Colors.red,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Text(
//                                       _selectedRole == null
//                                           ? 'Continue with Google'
//                                           : 'Google Sign-In as ${_selectedRole == 'artist' ? '🎨 Artist' : '👤 Customer'}',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                         color: _selectedRole == 'artist'
//                                             ? Colors.purple
//                                             : _selectedRole == 'customer'
//                                             ? Colors.blue
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 if (_selectedGoogleEmail != null)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 4.0),
//                                     child: Text(
//                                       _selectedGoogleEmail!,
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey[600],
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Don't have an account? ",
//                               style: TextStyle(color: Colors.grey[600]),
//                             ),
//                             ShaderMask(
//                               blendMode: BlendMode.srcIn,
//                               shaderCallback: (bounds) {
//                                 return LinearGradient(
//                                   colors: [
//                                     AppColors.appBarGradient.colors[0].withOpacity(0.9),
//                                     AppColors.appBarGradient.colors[1].withOpacity(0.7),
//                                   ],
//                                 ).createShader(
//                                   Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                                 );
//                               },
//                               child: GestureDetector(
//                                 onTap: () {
//                                   print("Navigate to Register screen");
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => Register()),
//                                   );
//                                 },
//                                 child: const Text(
//                                   'Register',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Column(
//                             children: [
//                               Text(
//                                 "Note: Your email will be remembered for next login.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: _selectedRole == 'artist'
//                                       ? Colors.purple.withOpacity(0.1)
//                                       : _selectedRole == 'customer'
//                                       ? Colors.blue.withOpacity(0.1)
//                                       : Colors.grey[100],
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     color: _selectedRole == 'artist'
//                                         ? Colors.purple
//                                         : _selectedRole == 'customer'
//                                         ? Colors.blue
//                                         : Colors.grey[300]!,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       "🔐 Google Sign-In Rules:",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: _selectedRole == 'artist'
//                                             ? Colors.purple
//                                             : _selectedRole == 'customer'
//                                             ? Colors.blue
//                                             : Colors.grey[700],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       _selectedRole == null
//                                           ? "• Select Artist or Customer role\n• One email = One role only"
//                                           : "• Use any Gmail for ${_selectedRole == 'artist' ? 'Artist' : 'Customer'}\n• Email permanently linked to role\n• Same email cannot be used for both roles",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: _selectedRole == 'artist'
//                                             ? Colors.purple
//                                             : _selectedRole == 'customer'
//                                             ? Colors.blue
//                                             : Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
  // GOOGLE SIGN-IN MANAGEMENT
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
      await _processGoogleUser(googleUser, userEmail);
    } catch (e) {
      _handleGoogleSignInError(e);
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  void _handleGoogleSignInCancelled() {
    print("Google sign in cancelled by user");
    setState(() => _selectedGoogleEmail = null);
    _showAlert("Google sign in cancelled");
  }

  Future<void> _processGoogleUser(GoogleSignInAccount googleUser, String userEmail) async {
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

    // Show confirmation dialog
    final confirmLogin = await _showGoogleConfirmationDialog(googleUser, userEmail);
    if (!confirmLogin) {
      await _cleanupGoogleSignIn();
      return;
    }

    await _completeGoogleSignIn(googleUser, userEmail);
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

  Future<bool> _showGoogleConfirmationDialog(GoogleSignInAccount googleUser, String userEmail) async {
    final roleColor = _roleConfig[_selectedRole]!['color'] as Color;
    final roleIcon = _roleConfig[_selectedRole]!['icon'] as IconData;
    final roleLabel = _roleConfig[_selectedRole]!['label'] as String;

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(roleIcon, color: roleColor),
            const SizedBox(width: 10),
            Text("Confirm ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} Login"),
          ],
        ),
        content: _buildGoogleConfirmationContent(googleUser, userEmail, roleColor, roleIcon, roleLabel),
        actions: _buildGoogleConfirmationActions(roleColor),
      ),
    ) ?? false;
  }

  Widget _buildGoogleConfirmationContent(
      GoogleSignInAccount googleUser,
      String userEmail,
      Color roleColor,
      IconData roleIcon,
      String roleLabel,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: googleUser.photoUrl != null ? NetworkImage(googleUser.photoUrl!) : null,
          child: googleUser.photoUrl == null ? const Icon(Icons.account_circle, size: 40) : null,
        ),
        const SizedBox(height: 15),
        const Text("You are signing in as:", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: roleColor, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(roleIcon, color: roleColor),
                  const SizedBox(width: 8),
                  Text(
                    roleLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: roleColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(userEmail, style: const TextStyle(fontSize: 14))),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "This email will be permanently linked to ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Text("Is this correct?", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<Widget> _buildGoogleConfirmationActions(Color roleColor) {
    return [
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No, Cancel"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: roleColor),
              child: const Text("Yes, Login", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _completeGoogleSignIn(GoogleSignInAccount googleUser, String userEmail) async {
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
    await _showGoogleLoginSuccessDialog(googleUser, userEmail);
  }

  Future<void> _showGoogleLoginSuccessDialog(GoogleSignInAccount googleUser, String userEmail) async {
    final roleColor = _roleConfig[_selectedRole]!['color'] as Color;
    final roleIcon = _roleConfig[_selectedRole]!['icon'] as IconData;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("✅ Login Successful!", textAlign: TextAlign.center),
        content: _buildSuccessContent(googleUser, userEmail, roleColor, roleIcon),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateAfterGoogleLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: roleColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text("Continue to Dashboard", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(
      GoogleSignInAccount googleUser,
      String userEmail,
      Color roleColor,
      IconData roleIcon,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(roleIcon, size: 50, color: roleColor),
        const SizedBox(height: 10),
        Text("Welcome ${googleUser.displayName ?? 'User'}!", textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                "Registered as: ${_selectedRole!.toUpperCase()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: roleColor,
                ),
              ),
              const SizedBox(height: 5),
              Text("Email: $userEmail", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  "✅ This email is now permanently linked to ${_selectedRole == 'artist' ? 'Artist' : 'Customer'} role",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _cleanupGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = false;
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

    _showAlert("Login Successful");
    await Future.delayed(const Duration(milliseconds: 1500));

    Navigator.of(context, rootNavigator: true).pop();
    _navigateBasedOnRole(userRole);
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