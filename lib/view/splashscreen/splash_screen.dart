import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/view/admin/adminhome/admin_homescreen.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/view/therapist/therapisthome/therapist_homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.read<LoginBloc>().add(CheckTokenEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.tokenValid && state.role == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminHome()),
                );
              } else if (state.tokenValid && state.role == 'therapist') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TherapistHome()),
                );
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.role == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminHome()),
                );
              } else if (state.role == 'therapist') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TherapistHome()),
                );
              }
            },
          ),
        ],
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(gradient: gradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(height: 150, 'asset/treatment.png'),
              Text('Healer',
                  style: GoogleFonts.satisfy(
                    textStyle: const TextStyle(color: white, fontSize: 50),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
