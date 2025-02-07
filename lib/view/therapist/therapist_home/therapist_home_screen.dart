import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/agora/agora_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/bloc/chat/chat_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/services/chat/socket.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/therapist/appointment/appointment.dart';
import 'package:healer_therapist/view/therapist/call/screens/call.dart';
import 'package:healer_therapist/view/therapist/chat/screens/inbox.dart';
import 'package:healer_therapist/view/therapist/client/view_client.dart';
import 'package:healer_therapist/view/therapist/therapist_home/widget/todays_appointment.dart';
import 'package:healer_therapist/view/therapist/therapist_home/widget/menu_card.dart';
import 'package:healer_therapist/view/therapist/therapist_home/widget/therapist_home_app_bar.dart';
import 'package:healer_therapist/widgets/drawer.dart';
import 'package:healer_therapist/widgets/loading.dart';
import 'package:intl/intl.dart';

class TherapistHome extends StatefulWidget {
  const TherapistHome({super.key});

  @override
  State<TherapistHome> createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  SocketService socketService = SocketService();
  String? userId;

  @override
  void initState() {
    context.read<LoginBloc>().add(CheckTokenEvent());
    _initializeSocket();
    context.read<AgoraBloc>().add(GetToken());
    super.initState();
  }

  Future<void> _initializeSocket() async {
    userId = await getUserId();

    if (userId != null) {
      socketService.initialize(userId: userId!);
    } else {
      log('UserId is null. Socket initialization skipped.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          drawer: const DrawerWidget(),
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.redirect == true || !state.tokenValid) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
              if (state.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(somethingWentWrong);
              }
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TherapistHomeAppBar(height: height, width: width),
                  BlocBuilder<AppointmentBloc, AppointmentState>(
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
                        final String today =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        final todayAppointments =
                            state.appointments.where((appointment) {
                          return appointment.date == today &&
                              appointment.status == 'confirmed';
                        }).toList();

                        if (todayAppointments.isNotEmpty) {
                          return AppointmentToday(
                              height: height,
                              width: width,
                              appointments: todayAppointments);
                        } else {
                          return SizedBox.shrink();
                        }
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ViewClient()));
                          },
                          child: MenuCard(
                            width: width,
                            image: 'asset/business.png',
                            title: 'Clients',
                            subtitle: "Manage your client flow with ease.",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Appointment()));
                          },
                          child: MenuCard(
                            width: width,
                            image: 'asset/appointment.png',
                            title: 'Appointment',
                            subtitle: 'Easily manage your appointments.',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) =>
                                              ChatBloc()..add(LoadChatsEvent()),
                                        ),
                                      ],
                                      child: Inbox(
                                        socketService: socketService,
                                      ),
                                    )),
                          ),
                          child: MenuCard(
                            width: width,
                            image: 'asset/chat1.png',
                            title: 'Chat',
                            subtitle: 'Private and secure chats.',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => TherapistBloc()
                                        ..add(OnGoingClientEvent()),
                                      child: Contacts(
                                        userId: userId!,
                                        socketService: socketService,
                                      ),
                                    )),
                          ),
                          child: MenuCard(
                            width: width,
                            image: 'asset/call.png',
                            title: 'Calls',
                            subtitle: "Virtual therapy made easy.",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
