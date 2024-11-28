import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/widgets/textfield.dart';

Widget buildTextFormField({
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator,
  String hint = '',
  bool isMultiline = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(
        height: isMultiline ? 150 : 55,
        child: TextFormField(
          controller: controller,
          validator: validator,
          maxLines: isMultiline ? 5 : 1,
          decoration: textField(hint),
          cursorColor: Colors.black26,
          style: textFieldStyle,
        ),
      ),
    ],
  );
}
