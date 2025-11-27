import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class ApiService {
  static String _u(String file) => '${Constants.apiBase}/$file';

  static Map<String, dynamic> _decode(http.Response r) {
    try {
      return {'statusCode': r.statusCode, 'body': jsonDecode(r.body)};
    } catch (e) {
      return {'statusCode': r.statusCode, 'body': {'raw': r.body, 'error': e.toString()}};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password, String role) =>
      http.post(Uri.parse(_u('login.php')), body: {'email': email, 'password': password, 'role': role}).then(_decode);

  static Future<Map<String, dynamic>> viewProjects({int? id, String? status}) {
    Uri uri;
    if (id != null) uri = Uri.parse(_u('view_project.php') + '?id=$id');
    else if (status != null) uri = Uri.parse(_u('view_project.php') + '?status=$status');
    else uri = Uri.parse(_u('view_project.php'));
    return http.get(uri).then(_decode);
  }

  static Future<Map<String, dynamic>> updateProjectStatus(Map<String, String> body) =>
      http.post(Uri.parse(_u('update_project_status.php')), body: body).then(_decode);

  static Future<Map<String, dynamic>> updateProject(Map<String, String> body) =>
      http.post(Uri.parse(_u('update_project.php')), body: body).then(_decode);

  static Future<Map<String, dynamic>> viewUsers({int? id}) {
    Uri uri = id != null ? Uri.parse(_u('view_user.php') + '?id=$id') : Uri.parse(_u('view_user.php'));
    return http.get(uri).then(_decode);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) =>
      http.post(Uri.parse(_u('forgot_password.php')), body: {'email': email}).then(_decode);

  static Future<Map<String, dynamic>> getForgotRequests() =>
      http.get(Uri.parse(_u('get_forgot_requests.php'))).then(_decode);
}
