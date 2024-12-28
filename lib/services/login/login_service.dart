import 'dart:convert';
import 'dart:developer';

import 'package:healer_therapist/model/login/login_model.dart';
import 'package:healer_therapist/model/login/login_response_model.dart';
import 'package:healer_therapist/services/endpoints.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> login(LoginModel login) async {
  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": login.email,
        "password": login.password,
      }),
    );

    if (response.statusCode == 200) {
      final loginResponse =
          LoginResponseModel.fromJson(jsonDecode(response.body));
      log('User role: ${loginResponse.role}');
      await storeToken(loginResponse.token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', loginResponse.role);
      return loginResponse.role;
    } else {
      log('Login failed with status: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    log('Error during login: $e');
    return '';
  }
}

Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role'); 
}