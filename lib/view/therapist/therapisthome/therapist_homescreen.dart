import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/view/login/login_screen.dart';

class TherapistHome extends StatelessWidget {
  const TherapistHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state.redirectToLogin == true) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            child: ListTile(
              onTap: () {
                context.read<AdminBloc>().add(LogOutEvent());
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Log out"),
            ))),
      body: const Center(
        child:  Text('Therapist Home'),
      ),
    );
  }
}