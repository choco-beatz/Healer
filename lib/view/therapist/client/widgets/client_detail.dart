import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/utils/string_extension.dart';

class ClientDetails extends StatelessWidget {
  final ClientModel client;
  const ClientDetails({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
              gradient: gradient,
            ),
          ),
          Positioned(
              top: 50,
              left: 5,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: white,
                        size: 35,
                      )),
                  hSpace,
                  const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 18,
                        color: white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          Positioned(
            top: 200,
            child: Container(
              width: width,
              height: height * 0.8,
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.125),
                child: Column(
                  children: [
                    Text(
                      client.profile.gender == 'male'
                          ? 'Mr. ${client.profile.name}'
                          : 'Ms. ${client.profile.name}',
                      style: semiBold,
                    ),
                    space,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender: ${client.profile.gender?.capitalize() ?? "N/A"}',
                          style: smallTextBold,
                        ),
                        Text(
                          'Age : ${client.profile.age}',
                          style: smallTextBold,
                        ),
                      ],
                    ),
                    space,
                    space,
                    space,
                    Text(
                      'Contact info : ${client.email}',
                      style: smallTextBold,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            left: width * 0.3,
            child: CircleAvatar(
              backgroundColor: main1,
              radius: 80,
              child: ClipOval(
                child: Image.network(
                  client.image,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
