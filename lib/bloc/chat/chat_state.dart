part of 'chat_bloc.dart';

class ChatState {}

final class ChatInitial extends ChatState {}  


class ChatLoading extends ChatState {}


class ChatsLoaded extends ChatState {
  final List<ChatModel> chats;

  ChatsLoaded(this.chats);

}

class MessagesLoaded extends ChatState {
  final List<ChatMessageModel> messages;

  MessagesLoaded(this.messages);

  
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);

}
