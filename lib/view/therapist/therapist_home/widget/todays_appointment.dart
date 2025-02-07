import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentToday extends StatelessWidget {
  const AppointmentToday({
    super.key,
    required this.height,
    required this.width,
    required this.appointments,
  });

  final double height;
  final double width;
  final List<AppointmentModel> appointments;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appointments.isEmpty) {
        context
            .read<AppointmentBloc>()
            .add(SlotStatusEvent(status: 'confirmed'));
      }
    });

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Appointments",
            style: smallXBold,
          ),
          smallSpace,
          ListView.builder(
            shrinkWrap: true,
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                child: Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                appointment.client.image
                              ),
                            ),
                            hSpace,
                            Text(
                              appointment.client.profile.name,
                              style: boldWhite,
                            )
                          ],
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: whitetrans,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: white,
                                ),
                                Text(
                                  DateFormat('EEE, MMMM d')
                                      .format(DateTime.parse(appointment.date)),
                                  style: const TextStyle(color: white),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: VerticalDivider(
                                    color: white,
                                    thickness: 0.5,
                                  ),
                                ),
                                const Icon(
                                  Icons.alarm_outlined,
                                  color: white,
                                ),
                                Text(
                                  '${appointment.startTime} - ${appointment.endTime}',
                                  style: const TextStyle(color: white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          smallSpace,
          const Divider(
            color: fieldBG,
          ),
        ],
      ),
    );
  }
}
