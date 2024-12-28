import 'dart:convert';
import 'dart:developer';

import 'package:healer_therapist/model/user/user_model.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';

Future<List<ClientModel>> fetchRequest() async {
  log('${requestStatusUrl}Pending');
  final response = await makeRequest('${requestStatusUrl}Pending', 'GET');

  if (response == null || response.statusCode != 200) return [];

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final requests = data['requests'] as List;
    // log(requests.toString());
    return requests
        .map((item) => ClientModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    log('Error parsing client list: $e');
    return [];
  }
}

Future<List<ClientModel>> onGoingClient() async {
  log('${requestStatusUrl}Accepted');
  final response = await makeRequest('${requestStatusUrl}Accepted', 'GET');
 
  if (response == null || response.statusCode != 200) return [];

  try {
    log(response.body);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final requests = data['requests'] as List;

    return requests
        .map((item) {
          final clientData = item['requests'];
          return clientData != null ? ClientModel.fromJson(clientData) : null;
        })
        .whereType<ClientModel>()
        .toList();
  } catch (e) {
    log('Error parsing client list: $e');
    return [];
  }
}

Future<bool> requestRespond(String requestId, String status) async {
  log('client : $requestId therapist : $status');
  try {
    final response = await makeRequest(requestRespondUrl, 'POST',
        body: jsonEncode({"requestId": requestId, "status": status}));
    log(response!.body);
    return true;
  } catch (e) {
    log('Error responding to request: $e');

    return false;
  }
}
