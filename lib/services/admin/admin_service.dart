import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';

Future<List<TherapistModel>> fetchTherapist() async {
  final response = await makeRequest(listTherapistUrl, 'GET');
  if (response == null || response.statusCode != 200) return [];

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['therapists'] as List;
    return list
        .map((item) => TherapistModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    log('Error parsing therapist list: $e');
    return [];
  }
}

Future<bool> addTherapist(TherapistModel therapist, File? imageFile) async {
  log('from service : ${therapist.experience}');
  return makeMultipartRequest(
    url: addTherapistUrl,
    method: 'POST',
    therapist: therapist,
    imageFile: imageFile,
  );
}

Future<bool> editTherapist(
    TherapistModel therapist, File? imageFile, String id) async {
  return makeMultipartRequest(
    url: '$editTherapistUrl$id',
    method: 'PUT',
    therapist: therapist,
    imageFile: imageFile,
  );
}

Future<bool> deleteTherapist(String id) async {
  final response = await makeRequest('$deleteTherapistUrl$id', 'DELETE');
  return response != null && response.statusCode == 200;
}

Future<List<TherapistModel>> searchTherapist(String searchText) async {
  final response = await makeRequest('$searchTherapistUrl$searchText', 'GET');
  if (response == null || response.statusCode != 200) return [];

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['users'] as List;
    return list
        .map((item) => TherapistModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    log('Error parsing search results: $e');
    return [];
  }
}
