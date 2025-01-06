import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';
import 'package:healer_therapist/view/therapist/client/widgets/request_button.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({
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
    final requestStatus = context.select<TherapistBloc, String?>(
      (bloc) => bloc.state.requestStatus[client.id],
    );
    if (requestStatus == "Accepted" || requestStatus == "Declined") {
      // Display status message
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 45,
                              width: 215,
                              decoration: BoxDecoration(
                                  gradient: requestStatus == "Accepted"
                                      ? gradient
                                      : redGradient,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  requestStatus!,
                                  style: const TextStyle(
                                      color: white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                context.read<TherapistBloc>().add(
                                    RequestRespondEvent(
                                        requestId: client.id,
                                        status: "Accepted"));
                              },
                              child: buildButton(text: 'Accept')),
                          InkWell(
                              onTap: () {
                                context.read<TherapistBloc>().add(
                                    RequestRespondEvent(
                                        requestId: client.id,
                                        status: "Declined"));
                              },
                              child: buildButton(text: 'Decline', imp: true)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
