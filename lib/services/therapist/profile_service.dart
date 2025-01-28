import 'dart:convert';
import 'dart:developer';

import 'package:healer_therapist/model/profile/profile_model.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';

Future<UserModel?> getProfile() async {
  final response = await makeRequest(profileUrl, 'GET');
  if (response == null || response.statusCode != 200) return null;

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final userResponse = UserResponse.fromJson(data);
    return userResponse.user;
  } catch (e) {
    log('Error parsing user profile: $e');
    return null;
  }
}
