import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/services/socket/socket.dart';
import 'package:healer_therapist/services/token.dart';
import 'package:healer_therapist/view/admin/adminhome/widgets/home_app_bar.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/therapist/appointment/appointment.dart';
import 'package:healer_therapist/view/therapist/call/screens/call.dart';
import 'package:healer_therapist/view/therapist/chat/screens/inbox.dart';
import 'package:healer_therapist/view/therapist/client/view_client.dart';
import 'package:healer_therapist/view/therapist/therapisthome/widget/appointment.dart';
import 'package:healer_therapist/view/therapist/therapisthome/widget/menu_card.dart';
import 'package:healer_therapist/widgets/drawer.dart';

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
    super.initState();
  }

  Future<void> _initializeSocket() async {
    userId = await getUserId();

    print(userId!);
    if (userId != null) {
      socketService.initialize(userId : userId!);
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
              log('redirect: ${state.redirect.toString()}');
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
                  HomeAppBar(height: height, width: width),
                  AppointmentToday(height: height, width: width),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewClient()));
                              },
                              child: MenuCard(
                                width: width,
                                image: 'asset/business.png',
                                title: 'Clients',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Appointment()));
                              },
                              child: MenuCard(
                                width: width,
                                image: 'asset/appointment.png',
                                title: 'Appointment',
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => TherapistBloc()
                                            ..add(OnGoingClientEvent()),
                                          child: Inbox(socketService: socketService,),
                                        )),
                              ),
                              child: MenuCard(
                                width: width,
                                image: 'asset/chat1.png',
                                title: 'Chat',
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => TherapistBloc()
                                            ..add(OnGoingClientEvent()),
                                          child: Contacts(),
                                        )),
                              ),
                              child: MenuCard(
                                width: width,
                                image: 'asset/call.png',
                                title: 'Calls',
                              ),
                            )
                          ],
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
