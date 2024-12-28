import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class AppointmentToday extends StatelessWidget {
  const AppointmentToday({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Appointment",
            style: smallXBold,
          ),
          Card(
              color: white,
              child: SizedBox(
                height: height * 0.165,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              )),
          Divider(
            color: fieldBG,
          )
        ],
      ),
    );
  }
}
