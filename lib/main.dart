import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/bloc/agora/agora_bloc.dart';
import 'package:healer_therapist/bloc/appointment/appointment_bloc.dart';
import 'package:healer_therapist/bloc/chat/chat_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AdminBloc()),
        BlocProvider(create: (context) => TherapistBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => AppointmentBloc()),
        BlocProvider(create: (context) => AgoraBloc()),
        BlocProvider(create: (context) => ChatBloc())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(cardColor: white),
          home: SplashScreen()),
    );
  }
}
