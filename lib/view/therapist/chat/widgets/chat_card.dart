import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/services/socket/socket.dart';
import 'package:healer_therapist/view/therapist/chat/screens/message_screen.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.client,
    required this.height,
    required this.width, 
    required this.socketService,
  });

  final double height;
  final double width;
  final SocketService socketService;
  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    log(client.profile.name);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      
        child: Card(
          color: white,
          child: SizedBox(
              height: height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                      backgroundColor: transparent,
                      radius: width * 0.07,
                      child: (client.image.split('.').last == 'png')
                          ? Image.network(
                              fit: BoxFit.fitHeight,
                              client.image,
                              width: 90,
                              height: 90,
                            )
                          : ClipOval(
                              child: Image.network(
                                fit: BoxFit.fitHeight,
                                client.image,
                                width: 90,
                                height: 90,
                              ),
                            )),
                  SizedBox(
                    width: width * 0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(client.profile.name, style: smallBold),
                        smallSpace,
                        Text('Message.....', style: textFieldStyle),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      
    );
  }
}
