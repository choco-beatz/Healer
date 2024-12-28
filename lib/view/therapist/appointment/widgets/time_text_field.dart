import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';

InputDecoration timeTextField(String hint, Widget time) {
  return InputDecoration(
      suffixIcon: time,
      fillColor: fieldBG,
      filled: true,
      hintText: hint,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
        color: border,
        width: 2,
      )),
      errorStyle: const TextStyle(
        fontSize: 12.0,
        height: 0.12,
      ),
      hintStyle: textFieldStyle,
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15)));
}
