import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';

InputDecoration textField(String hint) {
  return InputDecoration(
      fillColor: fieldBG,
      filled: true,
      hintText: hint,
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
