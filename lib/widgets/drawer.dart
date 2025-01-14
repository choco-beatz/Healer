import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/login/login_screen.dart';
import 'package:healer_therapist/widgets/about_us.dart';
import 'package:healer_therapist/widgets/drawer_dialog.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Drawer(
        child: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 170,
                width: width,
                decoration: const BoxDecoration(gradient: gradient),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        top: -120,
                        left: -80,
                        child: Opacity(
                            opacity: 0.45,
                            child: Image.asset(
                                height: 350, 'asset/treatment.png'))),
                    Positioned(
                      top: 100,
                      left: 145,
                      child: Text('Healer',
                          style: GoogleFonts.satisfy(
                            textStyle:
                                const TextStyle(color: white, fontSize: 50),
                          )),
                    )
                  ],
                ),
              ),
              BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state.redirect == true) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    }
                  },
                  child: ListTile(
                    onTap: () {
                      context.read<LoginBloc>().add(LogOutEvent());
                    },
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text("Log out"),
                  )),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DrawerDialoge(mdFileName: 'privacypolicy.md');
                      });
                },
                leading: const Icon(Icons.lock_outline_rounded),
                title: const Text('Privacy policy'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                },
                leading: const Icon(Icons.info_outlined),
                title: const Text('About Us'),
              ),
            ],
          ),
        ),
        Text(
          'Version: 1.0.0+1',
          style: lightText,
        ),
        space
      ],
    ));
  }
}
