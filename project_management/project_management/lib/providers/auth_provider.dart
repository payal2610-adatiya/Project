import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;

  bool get isLoggedIn => user != null;
  String get userRole => user?.role ?? '';

  Future<bool> login(String email, String password, String role) async {
    final res = await ApiService.login(email, password, role);
    final b = res['body'];
    if (b['status'] == "success") {
      user = UserModel.fromMap(b['data']);
      notifyListeners();
      return true;
    }
    return false;
  }

  logout(BuildContext context) {
    user = null;
    notifyListeners();
  }
}
