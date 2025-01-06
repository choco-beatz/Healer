import 'dart:convert';
import 'dart:developer';

import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:healer_therapist/model/appointment/slot_model.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';

Future<bool> updateSlots(Map<String, dynamic> payload) async {
  try {
    log('Payload in service: ${jsonEncode(payload)}');

    final response = await makeRequest(
      slotUrl,
      'POST',
      body: jsonEncode(payload),
    );
    log('Response: ${response!.statusCode.toString()}');
    log('Response: ${response.body.toString()}');
    return true;
  } catch (e) {
    log('Error in updateSlots: $e');
    return false;
  }
}

Future<bool> respondSlots(String appointmentId, String status) async {
  try {
    final response = await makeRequest(
      appointmentRespondUrl,
      'PUT',
      body: jsonEncode({"appointmentId": appointmentId, "status": status}),
    );
    log('Response: ${response!.statusCode.toString()}');
    log('Response: ${response.body.toString()}');
    return true;
  } catch (e) {
    log('Error in updateSlots: $e');
    return false;
  }
}

Future<List<SlotModel>> fetchSlots() async {
  final response = await makeRequest(slotUrl, 'GET');

  if (response == null || response.statusCode != 200) {
    log('Failed to fetch slots. Status Code: ${response?.statusCode}');
    return [];
  }

  try {
    log('Response: ${response.body}');
    final data = jsonDecode(response.body) as List<dynamic>;
    final slots = data.map((json) => SlotModel.fromJson(json)).toList();
    return slots;
  } catch (e) {
    log('Error parsing slots: $e');
    return [];
  }
}

Future<List<AppointmentModel>> slotStatus(String status) async {
  final response = await makeRequest('$slotStatusUrl$status', 'GET');

  if (response == null || response.statusCode != 200) return [];

  try {
    final dynamic decodedData = jsonDecode(response.body);

    if (decodedData is! List) return [];

    return decodedData
        .whereType<Map<String, dynamic>>()
        .map((item) => AppointmentModel.fromJson(item))
        .toList();
  } catch (e) {
    log('Error parsing slots data: $e');
    return [];
  }
}
