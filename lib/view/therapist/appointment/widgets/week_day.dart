import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';

Widget weekDays({required String text, bool imp = false}) {
  return Container(
    height: 40,
    width: 126,
    decoration: BoxDecoration(
        gradient: imp == false ? gradient : redGradient,
        borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            color: white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
