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
import 'package:healer_therapist/widgets/dialog_button.dart';
import 'package:healer_therapist/widgets/privacy_policy.dart';
import 'package:healer_therapist/widgets/term_and_condition.dart';

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
                height: 150,
                width: width,
                decoration: const BoxDecoration(gradient: gradient),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 50,
                      left: 100,
                      child: Text('Healer',
                          style: GoogleFonts.satisfy(
                            textStyle:
                                const TextStyle(color: white, fontSize: 70),
                          )),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
                },
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: main1,
                ),
                title: const Text('Privacy policy'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AboutUs()));
                },
                leading: const Icon(
                  Icons.info_outlined,
                  color: main1,
                ),
                title: const Text('About Us'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsAndConditions()));
                },
                leading: const Icon(
                  Icons.assignment_outlined,
                  color: main1,
                ),
                title: const Text('Terms and Conditions'),
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Log out?",
                              style: semiBold,
                            ),
                            content: const Text(
                              "Logging out? Stay safe!",
                              style: colorTextStyle,
                            ),
                            actions: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: buildButton(text: 'Cancel')),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<LoginBloc>()
                                        .add(LogOutEvent());
                                  },
                                  child:
                                      buildButton(text: 'Log Out', imp: true)),
                            ],
                          );
                        },
                      );
                    },
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: red,
                    ),
                    title: const Text(
                      "Log out",
                      style: TextStyle(color: red),
                    ),
                  )),
            ],
          ),
        ),
        const Text(
          'Version: 1.0.0+1',
          style: lightText,
        ),
        space
      ],
    ));
  }
}
