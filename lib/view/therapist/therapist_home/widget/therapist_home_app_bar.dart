import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/therapist/therapist_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/therapist_profile/view_therapist_profile.dart';
import 'package:healer_therapist/widgets/greetings.dart';

class TherapistHomeAppBar extends StatelessWidget {
  const TherapistHomeAppBar({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TherapistBloc()..add(GetProfileEvent()),
      child: Container(
        height: height * 0.2,
        width: width,
        decoration: const BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: BlocBuilder<TherapistBloc, TherapistState>(
            builder: (context, state) {
              if (state is TherapistProfileLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: white,
                ));
              } else if (state is TherapistProfileLoaded) {
                final user = state.therapist;
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewTherapistProfile(therapist: user))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Greeting(),
                          Text(
                            'Dr. ${user.profile.name}',
                            style: bigBoldWhite,
                          )
                        ],
                      ),
                      CircleAvatar(
                          backgroundColor: fieldBG,
                          radius: 55,
                          child: (user.image.split('.').last == 'png')
                              ? Image.network(
                                  fit: BoxFit.fitHeight,
                                  user.image,
                                  width: 110,
                                  height: 110,
                                )
                              : ClipOval(
                                  child: Image.network(
                                    fit: BoxFit.fitHeight,
                                    user.image,
                                    width: 110,
                                    height: 110,
                                  ),
                                ))
                    ],
                  ),
                );
              } else if (state is TherapistProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Welcome!'));
            },
          ),
        ),
      ),
    );
  }
}
