import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/chat/chat_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/services/chat/socket.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/chat_screen_app_bar.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/message_bubble.dart';
import 'package:healer_therapist/widgets/empty.dart';

class Message {
  final String text;
  final bool isSentByMe;
  final String? mediaUrl;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isSentByMe,
    this.mediaUrl,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  final String image;
  final String name;
  final SocketService socketService;
  final String id;

  const ChatScreen({
    super.key,
    required this.socketService,
    required this.id,
    required this.image,
    required this.name,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  String? userId;
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.id));
    _joinChat();
    _listenToIncomingMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _joinChat() async {
    userId = await getUserId();
    widget.socketService.emitJoinEvent(userId!);
  }

  void _listenToIncomingMessages() {
    widget.socketService.listenToEvent('new-message', (data) {
      log(data.toString());
      setState(() {
        _messages.add(Message(
          text: data['text'],
          isSentByMe: data['from'] == userId,
          timestamp: DateTime.parse(data['timestamp']),
        ));
      });
      log(_messages.toString());
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();

      // Emit message to the server
      widget.socketService.emitEvent('send-message', {
        'from': userId,
        'to': widget.id,
        'text': messageText,
      });
      _messageController.clear();
      setState(() {
        _messages.add(Message(
          text: messageText,
          isSentByMe: true,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded) {
          // Add loaded messages to the list
          setState(() {
            _messages.addAll(state.messages.map((msg) => Message(
                  text: msg.text,
                  isSentByMe: msg.from == userId,
                  // mediaUrl: msg.mediaUrl,
                  timestamp: msg.createdAt,
                )));
          });
          _scrollToBottom();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: ChatAppBar(
            title: widget.name,
            image: widget.image,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const Empty(
                      title: 'No Messages Yet',
                      subtitle:
                          'Say hello and start the conversation with your client. Your messages will appear here!',
                      image: "asset/emptyConvo.jpg",
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return MessageBubble(message: message);
                      },
                    ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 2,
            color: fieldBG,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
