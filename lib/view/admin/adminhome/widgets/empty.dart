import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class EmptyTherapist extends StatelessWidget {
  const EmptyTherapist({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(height: 150, 'asset/empty.png'),
        space,
        space,
        const Text(
          'No one is here',
          style: semiBold,
        ),
        const Text(
          'Add someone',
          style: textFieldStyle,
        ),
        space,
        space,
      ],
    );
  }
}
