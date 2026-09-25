import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'token': token}),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }
}
