import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(String correo, String password) async {
    final url = Uri.parse(ApiRoutes.login);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
