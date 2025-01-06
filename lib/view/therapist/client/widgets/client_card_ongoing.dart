import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
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
    log(client.profile.name);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        color: white,
        child: SizedBox(
            height: height * 0.16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                        backgroundColor: transparent,
                        radius: width * 0.125,
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
                              ))),
                SizedBox(
                  width: width * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(client.profile.name, style: smallBold),
                      smallSpace,
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
