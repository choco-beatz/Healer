import 'dart:developer';
import 'dart:io';

import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<String?> _validateToken() async {
  final token = await getValidToken();
  if (token == null) log('Token is null or invalid');
  return token;
}

Future<http.Response?> makeRequest(
  String url,
  String method, {
  Map<String, String>? headers,
  dynamic body,
}) async {
  final token = await _validateToken();
  if (token == null) return null;

  headers = {
    ...?headers,
    'Authorization': 'Bearer $token',
  };

  switch (method) {
    case 'GET':
      return await http.get(Uri.parse(url), headers: headers);
    case 'POST':
      return await http.post(Uri.parse(url), headers: headers, body: body);
    case 'PUT':
      return await http.put(Uri.parse(url), headers: headers, body: body);
    case 'DELETE':
      return await http.delete(Uri.parse(url), headers: headers);
    default:
      log('Unsupported HTTP method: $method');
      return null;
  }
}

Future<bool> makeMultipartRequest({
  required String url,
  required String method,
  required TherapistModel therapist,
  File? imageFile,
}) async {
  final token = await _validateToken();
  if (token == null) return false;

  try {
    final request = http.MultipartRequest(method, Uri.parse(url));
    request.fields.addAll({
      'name': therapist.name,
      'email': therapist.email,
      'password': therapist.password,
      'qualification': therapist.qualification,
      'specialization': therapist.specialization,
      'experience': therapist.experience.toString(),
      'bio': therapist.bio,
    });

    if (imageFile != null) {
      final fileBytes = await imageFile.readAsBytes();
      request.files.add(http.MultipartFile(
        'image',
        Stream.value(fileBytes),
        fileBytes.length,
        filename: imageFile.path.split('/').last,
        contentType: MediaType('image', imageFile.path.split('.').last),
      ));
    }

    request.headers.addAll({'Authorization': 'Bearer $token'});
    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      log('Request successful');
      return true;
    } else {
      log('Request failed with status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    log('Error during request: $e');
    return false;
  }
}