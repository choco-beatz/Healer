import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';

class AppointmentClientCard extends StatelessWidget {
  const AppointmentClientCard({
    super.key,
    required this.appointment,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      child: SizedBox(
        height: height * 0.17,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                    backgroundColor: transparent,
                    radius: width * 0.14,
                    child: (appointment.client.image.split('.').last == 'png')
                        ? Image.network(
                            fit: BoxFit.fitHeight,
                            appointment.client.image,
                            width: 80,
                            height: 80,
                          )
                        : ClipOval(
                            child: Image.network(
                              fit: BoxFit.fitHeight,
                              appointment.client.image,
                              width: 80,
                              height: 80,
                            ),
                          ))),
            SizedBox(
              width: width * 0.62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  smallSpace,
                  Row(
                    children: [
                      Text(appointment.client.profile.name, style: smallBold),
                      if (appointment.status == 'accepted')
                        const SizedBox(width: 8),
                      if (appointment.status == 'accepted')
                        const Text('(Waiting for payment)',
                            style: colorTextFieldStyle),
                    ],
                  ),
                  smallSpace,
                  Text(appointment.date, style: textFieldStyle),
                  smallSpace,
                  Chip(
                    side: BorderSide.none,
                    backgroundColor: main1trans,
                    label: Text(
                        '${appointment.startTime} - ${appointment.endTime}',
                        style: colorTextStyle),
                  ),
                  smallSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
