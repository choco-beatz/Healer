import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const FloatingButton({
    super.key,
    required this.text, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: main1,
        foregroundColor: white,
        onPressed: onPressed,
        label: Row(
          children: [
            const Icon(
              Icons.add,
              color: white,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ));
  }
}
