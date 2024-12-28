import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/view/admin/adminhome/widgets/home_app_bar.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/therapist/appointment/appointment.dart';
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
  @override
  void initState() {
    context.read<LoginBloc>().add(CheckTokenEvent());
    log('message');
    super.initState();
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
                  AppointmentToday(height: height),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewClient()));
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
                                        builder: (context) => Appointment()));
                              },
                              child: MenuCard(
                              width: width,
                              image: 'asset/appointment.png',
                              title: 'Appointment',
                            ),)
                          ],
                        ),
                        Row(
                          children: [
                            MenuCard(
                              width: width,
                              image: 'asset/chat1.png',
                              title: 'Chat',
                            ),
                            MenuCard(
                              width: width,
                              image: 'asset/call.png',
                              title: 'Calls',
                            ),
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
