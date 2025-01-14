part of 'chat_bloc.dart';

class ChatEvent {}
// Event to load all chats
class LoadChatsEvent extends ChatEvent {}

// Event to load messages for a specific chat
class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  LoadMessagesEvent(this.chatId);

}
