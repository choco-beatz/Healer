import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_client_card.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';

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
          final appointment = state.appointments;
          if (appointment.isEmpty) {
            return const Center(
              child: EmptyClient(),
            );
          }
          return ListView.builder(
              itemCount: appointment.length,
              itemBuilder: (context, index) {
                final client = appointment[index];

                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientDetails(
                                client: client.client,))),
                    child: AppointmentClientCard(
                      height: height,
                      
                      width: width,
                      appointment: client,
                    ));
              });
        },
      ),
    );
  }
}
