import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/appoinment_client_card.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/client_detail.dart';
import 'package:healer_therapist/view/therapist/client/widgets/empty.dart';
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
          final appointments = state.appointments;
          if (appointments.isEmpty) {
            return const Center(
              child: EmptyClient(),
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
                                ))),
                    child: AppointmentClientCard(
                      height: height,
                      width: width,
                      appointment: client,
                    ));
              });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AppointmentBloc>().add(SlotStatusEvent(status: status));
        });
        return const Loading();
      }),
    );
  }
}
