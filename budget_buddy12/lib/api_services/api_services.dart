import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://prakrutitech.xyz/payal/';

  // Generic POST Request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, String> data) async {
    try {
      final response = await http
          .post(Uri.parse(baseUrl + endpoint), body: data)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Something went wrong: $e'};
    }
  }

  // ---------------- USER APIs ----------------
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    return await post('login_user.php', {'email': email, 'password': password});
  }

  static Future<Map<String, dynamic>> signupUser(String name, String email, String password) async {
    return await post('add_user.php', {'name': name, 'email': email, 'password': password});
  }

  static Future<Map<String, dynamic>> updateUser(int id, String name, String email) async {
    return await post('update_user.php', {'id': id.toString(), 'name': name, 'email': email});
  }

  static Future<Map<String, dynamic>> deleteUser(int id) async {
    return await post('delete_user.php', {'id': id.toString()});
  }

  static Future<List<dynamic>> viewUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'view_users.php'));
      final jsonData = json.decode(response.body);
      return jsonData['data'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // ---------------- CATEGORY APIs ----------------
  static Future<Map<String, dynamic>> addCategory(int userId, String name, String type) async {
    return await post('add_category.php', {'user_id': userId.toString(), 'name': name, 'type': type});
  }

  static Future<Map<String, dynamic>> updateCategory(int id, String name, String type) async {
    return await post('update_category.php', {'id': id.toString(), 'name': name, 'type': type});
  }

  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    return await post('delete_category.php', {'id': id.toString()});
  }

  static Future<List<dynamic>> viewCategories(int userId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'view_categories.php?user_id=$userId'));
      final jsonData = json.decode(response.body);
      return jsonData['data'] ?? [];
    } catch (e) {
      return [];
    }
  }

  // ---------------- TRANSACTION APIs ----------------
  static Future<Map<String, dynamic>> addTransaction(
      int userId, int categoryId, double amount, String note, String date) async {
    return await post('add_transaction.php', {
      'user_id': userId.toString(),
      'category_id': categoryId.toString(),
      'amount': amount.toString(),
      'note': note,
      'date': date
    });
  }

  static Future<Map<String, dynamic>> updateTransaction(int id, double amount, String note, String date) async {
    return await post('update_transaction.php', {
      'id': id.toString(),
      'amount': amount.toString(),
      'note': note,
      'date': date
    });
  }

  static Future<Map<String, dynamic>> deleteTransaction(int id) async {
    return await post('delete_transaction.php', {'id': id.toString()});
  }

  static Future<List<dynamic>> viewTransactions(int userId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + 'view_transactions.php?user_id=$userId'));
      final jsonData = json.decode(response.body);
      return jsonData['data'] ?? [];
    } catch (e) {
      return [];
    }
  }
}
