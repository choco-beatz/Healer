import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_client_card.dart';
import 'package:intl/intl.dart';

class AppointmentToday extends StatelessWidget {
  const AppointmentToday({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentBloc>().add(SlotStatusEvent(status: 'confirmed'));
    });
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

          final todayAppointments = state.appointments.where((appointment) {
            return appointment.date == today;
          }).toList();

          if (todayAppointments.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Appointments",
                  style: smallXBold,
                ),
                ListView.builder(
                  
                  shrinkWrap: true,
                  itemCount: todayAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = todayAppointments[index];
                    return AppointmentClientCard(
                        appointment: appointment,
                        height: height,
                        width: width);
                  },
                ),
                const Divider(
                  color: fieldBG,
                ),
              ],
            );
          } else {
            return SizedBox(
              height: height * 0.165,
              child: const Center(
                child: Text(
                  "No appointments today",
                  style: textFieldStyle,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
