import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

Future<void> storeToken(String token) async {
  await secureStorage.write(key: 'token', value: token);
}

bool isExpired(String token) {
  try {
    final jwt = JWT.decode(token);
    final exp = jwt.payload['exp'];
    if (exp == null || exp is! int) {
      log('Invalid or missing exp field in JWT payload');
      return true;
    }
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    log('Token expiry date: $expiryDate');
    return DateTime.now().isAfter(expiryDate);
  } catch (e) {
    log('Error decoding token: $e');
    return true;
  }
}

Future<String?> getValidToken() async {
  final token = await secureStorage.read(key: 'token');
  if (token == null || isExpired(token)) {
    return null;
  }
  return token;
}

Future<void> clearToken() async {
  await secureStorage.delete(key: 'token');
}
