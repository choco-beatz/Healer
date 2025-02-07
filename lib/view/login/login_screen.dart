import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/login/login_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/model/login/login_model.dart';
import 'package:healer_therapist/view/admin/admin_home/admin_homescreen.dart';
import 'package:healer_therapist/view/login/widgets/welcome.dart';
import 'package:healer_therapist/view/therapist/therapist_home/therapist_home_screen.dart';
import 'package:healer_therapist/widgets/button.dart';
import 'package:healer_therapist/widgets/textfield.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.role == 'admin') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AdminHome()));
            } else if (state.role == 'therapist') {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TherapistHome()));
            } else if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(loginErrorSnackBar);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Welcome(),
                    SizedBox(
                      height: 55,
                      width: width * 0.9,
                      child: TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email';
                            }
                            return null;
                          },
                          decoration: textField('Email'),
                          cursorColor: textColor,
                          style: textFieldStyle),
                    ),
                    space,
                    SizedBox(
                      height: 55,
                      width: width * 0.9,
                      child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the password';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: textField('Password'),
                          cursorColor: textColor,
                          style: textFieldStyle),
                    ),
                    space,
                    space,
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          final data = LoginModel(
                              email: emailController.text,
                              password: passwordController.text);
                          context
                              .read<LoginBloc>()
                              .add(LoginActionEvent(data: data));
                        }
                      },
                      child: const Button(text: 'Login'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
