import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/snackbar.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/widgets/button.dart';
import 'package:healer_therapist/widgets/textfield.dart';
import 'package:healer_therapist/widgets/textformfield.dart';

class AddTherapist extends StatelessWidget {
  AddTherapist({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    File? image;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CommonAppBar(
            title: 'Add Therapist',
          )),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            Card(
                child: Form(
                    key: formkey,
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: InkWell(onTap: () {
                                context.read<AdminBloc>().add(PickImageEvent());
                              }, child: BlocBuilder<AdminBloc, AdminState>(
                                      builder: (context, state) {
                                if (state.pickedImage != null) {
                                  image = state.pickedImage;
                                  return CircleAvatar(
                                    radius: 70,
                                    child: ClipOval(
                                      child: Image.file(
                                        state.pickedImage!,
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140,
                                      ),
                                    ),
                                  );
                                }
                                return const CircleAvatar(
                                    backgroundColor: main1,
                                    radius: 70,
                                    foregroundColor: white,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 80,
                                    ));
                              }))),
                              space,
                              buildTextFormField(
                                label: ' Name',
                                controller: nameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter the name'
                                        : null,
                                hint: 'Enter the name',
                              ),
                              space,
                              buildTextFormField(
                                label: ' Email',
                                controller: emailController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter the email'
                                        : null,
                                hint: 'Enter the email',
                              ),
                              space,
                              buildTextFormField(
                                  label: ' Bio',
                                  controller: bioController,
                                  
                                  hint: 'Enter the Bio',
                                  isMultiline: true),
                              space,
                              buildTextFormField(
                                  label: ' Qualification',
                                  controller: qualificationController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter the qualification'
                                          : null,
                                  hint: 'Enter the qualification',
                                  isMultiline: true),
                              space,
                              
                              buildTextFormField(
                                  label: ' Specialization',
                                  controller: specializationController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter the Specialization'
                                          : null,
                                  hint: 'Enter the specialization',
                                  isMultiline: true),
                              space,
                              buildTextFormField(
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Please enter the Experience'
                                        : null,
                                label: ' Experience',
                                controller: experienceController,
                                hint: 'Enter the experience',
                              ),
                              space,
                              const Text(
                                ' Password',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the password';
                                    } else if (value.length < 6) {
                                      return 'Password must be more than 6 letters';
                                    }
                                    return null;
                                  },
                                  decoration: textField('Enter the password'),
                                  cursorColor:textColor,
                                  style: textFieldStyle),
                              space,
                            ])))),
            space,
            InkWell(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  final therapist = TherapistModel(
                    name: nameController.text,
                    email: emailController.text,
                    experience: int.tryParse(experienceController.text),
                    bio: bioController.text,
                    qualification: qualificationController.text,
                    specialization: specializationController.text,
                    password: passwordController.text,
                  );
                  log('from ui : ${therapist.experience}');
                  context.read<AdminBloc>().add(AddTherapistEvent(
                      therapist: therapist, imageFile: image));
                  ScaffoldMessenger.of(context).showSnackBar(therapistCreated);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(somethingWentWrong);
                }
              },
              child: const Button(text: 'Save'),
            ),
            space
          ]))),
    );
  }
}
