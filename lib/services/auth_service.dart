import 'dart:convert';

import 'package:http/http.dart' as http;
const apiBaseUrl = "https://asset-app-backend.vercel.app/api";
class AuthService {
  static Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
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
    required String type,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'token': token, 'type': type}),
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
      Uri.parse('$apiBaseUrl/auth/login'),
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

  static Future<Map<String, dynamic>> forgetpass({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }

  static Future<Map<String, dynamic>> updatePassword({
    required String newPassword,
    required String accessToken,
    required String refreshToken,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/update-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'newPassword': newPassword,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }
    static Future<Map<String, dynamic>> googleSignIn({
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/auth/google/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    final body = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'data': body,
      'statusCode': response.statusCode,
    };
  }
}
