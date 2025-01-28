import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/view/therapist/chat/screens/message_screen.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override 
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: fieldBG,
                blurRadius: 7,
                spreadRadius: 2,
              ),
            ],
            gradient: message.isSentByMe ? gradient : nullGradient,
            borderRadius: message.isSentByMe
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))
                : const BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.mediaUrl != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.mediaUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: message.isSentByMe ? white : black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
               DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isSentByMe ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
