import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';

Widget buildViewButton({required String text, bool imp = false, required double width}) {
  return Container(
    height: 50,
    width: width,
    decoration: BoxDecoration(
        gradient: imp == false ? gradient : redGradient,
        borderRadius: BorderRadius.circular(15)),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            color: white, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
