// api_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://prakrutitech.xyz/payal';
  static const Duration timeout = Duration(seconds: 10);

  // Normalize responses into a consistent map: { code, message, data }
  static Map<String, dynamic> _normalizeResponse(int statusCode, String body) {
    try {
      final json = jsonDecode(body);
      final code = json['code'] ??
          (json['status'] == 'success' ? 200 : (statusCode == 200 ? 200 : statusCode));
      final message = json['message'] ?? json['msg'] ?? json['error'] ?? '';
      final data = json;
      return {'code': code, 'message': message, 'data': data};
    } catch (e) {
      return {
        'code': statusCode >= 200 && statusCode < 300 ? 200 : statusCode,
        'message': 'Invalid server response',
        'data': {}
      };
    }
  }

  static Future<Map<String, dynamic>> _get(Uri url) async {
    try {
      final res = await http.get(url).timeout(timeout);
      return _normalizeResponse(res.statusCode, res.body);
    } catch (e) {
      return {'code': 500, 'message': 'Network error: $e', 'data': {}};
    }
  }

  static Future<Map<String, dynamic>> _post(Uri url, Map<String, String> body) async {
    try {
      final res = await http.post(url, body: body).timeout(timeout);
      return _normalizeResponse(res.statusCode, res.body);
    } catch (e) {
      return {'code': 500, 'message': 'Network error: $e', 'data': {}};
    }
  }

  // Auth
  static Future<Map<String, dynamic>> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/add_user.php');
    final resp = await _post(url, {'name': name, 'email': email, 'password': password});
    return resp;
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login_user.php');
    final resp = await _post(url, {'email': email, 'password': password});
    return resp;
  }

  // User
  static Future<Map<String, dynamic>> viewUser(String userId) async {
    final url = Uri.parse('$baseUrl/view_user.php?user_id=$userId');
    final resp = await _get(url);
    return resp;
  }

  static Future<Map<String, dynamic>> updateUser({
    required String id,
    required String name,
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/update.php');
    final resp = await _post(url, {'action': 'update_user', 'id': id, 'name': name, 'email': email});
    return resp;
  }

  // Categories
  static Future<Map<String, dynamic>> addCategory({
    required String userId,
    required String name,
    required String type,
  }) async {
    final url = Uri.parse('$baseUrl/add_category.php');
    final resp = await _post(url, {'user_id': userId, 'name': name, 'type': type});
    return resp;
  }

  static Future<Map<String, dynamic>> viewCategories(String userId) async {
    final url = Uri.parse('$baseUrl/view_category.php?user_id=$userId');
    final resp = await _get(url);
    // map data.categories to top-level 'categories' for convenience
    final data = resp['data'] ?? {};
    final categories = data['categories'] ?? data['data'] ?? data['category'] ?? [];
    return {'code': resp['code'], 'message': resp['message'], 'categories': categories};
  }

  static Future<Map<String, dynamic>> updateCategory({
    required String id,
    required String name,
    required String type,
  }) async {
    final url = Uri.parse('$baseUrl/update.php');
    final resp = await _post(url, {'action': 'update_category', 'id': id, 'name': name, 'type': type});
    return resp;
  }

  static Future<Map<String, dynamic>> deleteCategory(String id) async {
    final url = Uri.parse('$baseUrl/delete_category.php?id=$id');
    final resp = await _get(url);
    return resp;
  }

  // Transactions
  static Future<Map<String, dynamic>> addTransaction({
    required String userId,
    required String categoryId,
    required String amount,
    required String date,
    required String note,
  }) async {
    final url = Uri.parse('$baseUrl/add_transactions.php');
    final resp = await _post(url, {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'date': date,
      'note': note,
    });

    // Backend might return {code:200} or {success:true}. Normalize to code/message
    final code = resp['code'] ?? (resp['data']?['success'] == true ? 200 : 400);
    final message = resp['message'] ?? resp['data']?['message'] ?? '';
    return {'code': code, 'message': message, 'data': resp['data'] ?? {}};
  }

  static Future<Map<String, dynamic>> viewTransactions(String userId) async {
    final url = Uri.parse('$baseUrl/view_transaction.php?user_id=$userId');
    final resp = await _get(url);
    final transactions = resp['data']?['transactions'] ?? resp['data']?['data'] ?? resp['data']?['transactions_list'] ?? [];
    return {'code': resp['code'], 'message': resp['message'], 'transactions': transactions};
  }

  static Future<Map<String, dynamic>> deleteTransaction(String transactionId) async {
    final url = Uri.parse('$baseUrl/delete_transaction.php');
    final resp = await _post(url, {'transaction_id': transactionId});
    return resp;
  }

  // Reports / Overview
  static Future<Map<String, dynamic>> getReports(String userId) async {
    final url = Uri.parse('$baseUrl/reports.php');
    final resp = await _post(url, {'user_id': userId});
    return {'code': resp['code'], 'message': resp['message'], 'reports': resp['data'] ?? resp['data']};
  }

  static Future<Map<String, dynamic>> getOverview(String userId) async {
    final url = Uri.parse('$baseUrl/overview.php');
    final resp = await _post(url, {'user_id': userId});
    return {'code': resp['code'], 'message': resp['message'], 'overview': resp['data'] ?? resp['data']};
  }
}
