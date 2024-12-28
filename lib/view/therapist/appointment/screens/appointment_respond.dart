import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_respond_card.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';

class AppointmentRespond extends StatelessWidget {
  final String status;
  const AppointmentRespond({super.key, required this.status});

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
          final appointments = state.appointments;
          
          if (appointments.isEmpty) {
            return const Center(
              child: EmptyClient(),
            );
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return BlocListener<AppointmentBloc, AppointmentState>(
                listenWhen: (previous, current) {
                  return previous.responseStatus != current.responseStatus;
                },
                listener: (context, state) {
                  if (state.responseStatus == 'success') {
                    context.read<AppointmentBloc>().add(
                          SlotStatusEvent(status: status)
                        );
                  }
                },
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetails(
                        client: appointment.client
                      )
                    )
                  ),
                  child: AppointmentRespondCard(
                    key: ValueKey(appointment.id), 
                    height: height,
                    width: width,
                    appointment: appointment,
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }
}