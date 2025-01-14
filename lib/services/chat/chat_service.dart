import 'dart:convert';
import 'dart:developer';

import 'package:healer_therapist/model/chat/chat_model.dart';
import 'package:healer_therapist/model/chat/message_model.dart';
import 'package:healer_therapist/services/api_helper.dart';
import 'package:healer_therapist/services/endpoints.dart';

Future<List<ChatModel>> fetchChats() async {
  final response = await makeRequest(inboxUrl, 'GET');

  if (response == null || response.statusCode != 200) {
    log('Failed to fetch chats. Status Code: ${response?.statusCode}');
    return [];
  }

  try {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data.containsKey('chats') && data['chats'] is List) {
      final chats = data['chats'] as List;
      return chats
          .map((chat) {
            try {
              return ChatModel.fromJson(chat);
            } catch (e) {
              log('Error parsing chat entry: $chat. Error: $e');
              return null; // Skip invalid entries
            }
          })
          .whereType<ChatModel>()
          .toList(); // Filter out nulls
    } else {
      log('Unexpected JSON structure: $data');
      return [];
    }
  } catch (e) {
    log('Error parsing chats: $e');
    return [];
  }
}

Future<List<ChatMessageModel>> fetchMessages({required String chatId}) async {
  final response = await makeRequest('$inboxUrl/$chatId', 'GET');

  if (response == null || response.statusCode != 200) {
    log('Failed to fetch chats. Status Code: ${response?.statusCode}');
    return [];
  }

  try {
    log('Responseeee: ${response.body}');

    final Map<String, dynamic> data = jsonDecode(response.body);

    // Check for the correct key in the JSON response
    if (data.containsKey('chat') && data['chat'] is List) {
      final chatList = data['chat'] as List;
      return chatList.map((chat) => ChatMessageModel.fromJson(chat)).toList();
    } else {
      log('Unexpected JSON structure: $data');
      return [];
    }
  } catch (e) {
    log('Error parsing messages: $e');
    return [];
  }
}
