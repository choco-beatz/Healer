import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/widgets/textfield.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome', style: bigBold),
              space,
              Image.asset(height: 100, 'asset/welcome.png'),
              space,
              SizedBox(
                height: 55,
                width: 350,
                child: TextFormField(
                    decoration: textField('Email'),
                    cursorColor: Colors.black12,
                    style: textFieldStyle),
              ),
              space,
              SizedBox(
                height: 55,
                width: 350,
                child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: textField('Password'),
                    cursorColor: Colors.black12,
                    style: textFieldStyle),
              ),
              space,
            ],
          ),
        ),
      ),
    );
  }
}
