import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';

Widget buildButton({required String text, bool imp = false}) {
  return Container(
    height: 45,
    width: 100,
    decoration: BoxDecoration(
        gradient: imp == false ? gradient : redGradient,
        borderRadius: BorderRadius.circular(10)),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            color: white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
