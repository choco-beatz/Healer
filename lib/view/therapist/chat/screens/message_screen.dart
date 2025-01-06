import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';

import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/services/socket/socket.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:healer_therapist/view/therapist/chat/widgets/message_bubble.dart';
import 'package:healer_therapist/widgets/appbar.dart';

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
  final ClientModel client;
  final SocketService socketService;

  const ChatScreen({
    super.key,
    required this.client,
    required this.socketService,
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
  void initState(){
    
    super.initState();
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
      setState(() {
        _messages.add(Message(
          text: data['text'],
          isSentByMe: data['from'] == userId,
          timestamp: DateTime.parse(data['timestamp']),
        ));
      });
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      setState(() {
        _messages.add(Message(
          text: messageText,
          isSentByMe: true,
          timestamp: DateTime.now(),
        ));
        _messageController.clear();
      });
      _scrollToBottom();

      // Emit message to the server
      widget.socketService.emitEvent('send-message', {
        'from': userId,
        'to': widget.client.profile.id, // Add recipient ID here
        'text': messageText,
      });
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CommonAppBar(
          title: widget.client.profile.name,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
            color: textColor,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // Implement media upload functionality
              // You can use image_picker package for this
            },
          ),
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
