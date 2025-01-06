
// import 'dart:convert';
// import 'dart:developer';

// import 'package:healer_therapist/model/profile/profile_model.dart';
// import 'package:healer_therapist/services/api_helper.dart';
// import 'package:healer_therapist/services/endpoints.dart';

// Future<UserModel> getProfile() async {
//   final response = await makeRequest(profileUrl, 'GET');
//   log(response!.body);
//   if (response == null || response.statusCode != 200) {
//      throw Exception('Payment initiation failed');
//   }
//   try {
//     log(response.body);
//   final data = jsonDecode(response.body) as Map<String, dynamic>;
//     return UserModel.fromJson(data);
   
//   } catch (e) {
//     log('Error parsing slots data: $e');
//    throw Exception('Payment data parsing failed');
//   }
// }