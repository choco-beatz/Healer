import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/model/appointment/appointment_model.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_client_card.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/client_detail.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/loading.dart';

class AppointmentStatus extends StatelessWidget {
  final String status;
  const AppointmentStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentBloc>().add(SlotStatusEvent(status: status));
    });

    return Scaffold(
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Loading();
          } else if (state is AppointmentError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: red),
              ),
            );
          } else if (state is AppointmentSuccessState) {
            List<AppointmentModel> appointments = state.appointments;

            // Filter only if status is 'confirmed'
            if (status == 'confirmed') {
              appointments = appointments.where((appointment) {
                DateTime appointmentDate = DateTime.parse(appointment.date);
                return appointmentDate.isAfter(DateTime.now());
              }).toList();
            }

            if (appointments.isEmpty) {
              return Empty(
                title: status == 'confirmed'
                    ? "No Upcoming Appointments"
                    : "No Pending Requests",
                subtitle: status == 'confirmed'
                    ? "You have no scheduled appointments at the moment. Check back later for your next session."
                    : "You're all caught up! Waiting for clients to complete their payments before confirming appointments.",
                image: status == 'confirmed'
                    ? "asset/emptyUpcoming.jpg"
                    : "asset/emptyPending.jpg",
              );
            }

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final client = appointments[index];

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetails(
                        client: client.client,
                      ),
                    ),
                  ),
                  child: AppointmentClientCard(
                    height: height,
                    width: width,
                    appointment: client,
                  ),
                );
              },
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppointmentBloc>().add(SlotStatusEvent(status: status));
          });
          return const Loading();
        },
      ),
    );
  }
}
