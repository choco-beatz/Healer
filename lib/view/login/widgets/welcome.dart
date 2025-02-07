import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(height: 200, 'asset/treatment.png'),
        const Text('Welcome Back', style: bigBold),
        space,
        space
      ],
    );
  }
}
