import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_client_card.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/client_detail.dart';
import 'package:healer_therapist/widgets/empty.dart';
import 'package:healer_therapist/widgets/loading.dart';

class AppointmentRespond extends StatelessWidget {
  final String status;
  const AppointmentRespond({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    context.read<AppointmentBloc>().add(SlotStatusEvent(status: status));

    return Scaffold(
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listenWhen: (previous, current) =>
            previous.responseStatus != current.responseStatus,
        listener: (context, state) {
          if (state.responseStatus == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred. Please try again.'),
                backgroundColor: red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Loading();
          } else if (state is AppointmentError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: red),
              ),
            );
          } else if (state is AppointmentSuccessState) {
            final appointments = state.appointments;

            if (appointments.isEmpty) {
              return const Empty(
                title: 'No Appointment Requests',
                subtitle:
                    "You haven't received any appointment requests yet. Stay tuned for new bookings from clients.",
                image: "asset/emptyAppointment.jpg",
              );
            }

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetails(
                        client: appointment.client,
                      ),
                    ),
                  ),
                  child: AppointmentClientCard(
                    key: ValueKey(appointment.id),
                    height: height,
                    width: width,
                    appointment: appointment,
                  ),
                );
              },
            );
          }

          // Fallback for unexpected states
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
