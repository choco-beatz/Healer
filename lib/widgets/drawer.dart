
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/view/login/login_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.redirect == true) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }
          },
          child: ListTile(
            onTap: () {
              context.read<LoginBloc>().add(LogOutEvent());
            },
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Log out"),
          )));
  }
}