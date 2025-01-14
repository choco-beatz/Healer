import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/widgets/greetings.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      width: width,
      decoration: const BoxDecoration(gradient: gradient),
      child: const Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Greeting(),
            Text(
              "Your Therapists",
              style: bigBoldWhite,
            )
          ],
        ),
      ),
    );
  }
}
