import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';

class ClientCardOngoing extends StatelessWidget {
  const ClientCardOngoing({
    super.key,
    required this.client,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(children: [
        // Background Image
        Container(
          height: height * 0.25,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(client.image),
              fit: BoxFit.cover,
              onError: (error, stackTrace) {},
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          height: height * 0.25,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [transparent, black.withOpacity(0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  client.profile.name,
                  style: buttonText,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
