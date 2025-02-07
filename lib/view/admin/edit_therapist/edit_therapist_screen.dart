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

class EditTherapist extends StatefulWidget {
  final TherapistModel therapist;
  const EditTherapist({
    super.key,
    required this.therapist,
  });

  @override
  State<EditTherapist> createState() => _EditTherapistState();
}

class _EditTherapistState extends State<EditTherapist> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController specializationController;
  late TextEditingController qualificationController;
  late TextEditingController experienceController;
  late TextEditingController bioController;
  late TextEditingController passwordController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.therapist.name);
    specializationController =
        TextEditingController(text: widget.therapist.specialization);
    qualificationController =
        TextEditingController(text: widget.therapist.qualification);
    experienceController =
        TextEditingController(text: widget.therapist.experience.toString());
    bioController = TextEditingController(text: widget.therapist.bio);
    passwordController = TextEditingController(text: widget.therapist.password);
  }

  @override
  Widget build(BuildContext context) {
    File? image;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CommonAppBar(
            title: 'Edit Therapist',
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
                                  child: InkWell(
                                onTap: () {
                                  context
                                      .read<AdminBloc>()
                                      .add(PickImageEvent());
                                },
                                child: BlocBuilder<AdminBloc, AdminState>(
                                  builder: (context, state) {
                                    if (state.pickedImage != null) {
                                      image = state.pickedImage;
                                      return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              child: ClipOval(
                                                child: Image.file(
                                                  state.pickedImage!,
                                                  fit: BoxFit.cover,
                                                  width: 140,
                                                  height: 140,
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                                top: 90,
                                                left: 100,
                                                child: CircleAvatar(
                                                  backgroundColor: main1,
                                                  radius: 25,
                                                  foregroundColor: white,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    size: 30,
                                                  ),
                                                ))
                                          ]);
                                    } else {
                                      return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              child: ClipOval(
                                                child: Image.network(
                                                  widget.therapist.image!,
                                                  fit: BoxFit.cover,
                                                  width: 140,
                                                  height: 140,
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                                top: 90,
                                                left: 100,
                                                child: CircleAvatar(
                                                  backgroundColor: main1,
                                                  radius: 25,
                                                  foregroundColor: white,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    size: 30,
                                                  ),
                                                ))
                                          ]);
                                    }
                                  },
                                ),
                              )),
                              space,
                              const Text(
                                ' Name',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 55,
                                child: TextFormField(
                                  controller: nameController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter the name'
                                          : null,
                                  decoration: textField('Enter the name'),
                                  cursorColor: textColor,
                                  style: textFieldStyle,
                                ),
                              ),
                              space,
                              const Text(
                                ' Bio',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: bioController,
                                  decoration: textField('Enter the bio'),
                                  cursorColor: textColor,
                                  style: textFieldStyle,
                                ),
                              ),
                              space,
                              const Text(
                                ' Qualification',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: qualificationController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter the qualification'
                                          : null,
                                  decoration:
                                      textField('Enter the qualification'),
                                  cursorColor: textColor,
                                  style: textFieldStyle,
                                ),
                              ),
                              space,
                              const Text(
                                ' Specialization',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: specializationController,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please enter the Specialization'
                                          : null,
                                  decoration:
                                      textField('Enter the specialization'),
                                  cursorColor: textColor,
                                  style: textFieldStyle,
                                ),
                              ),
                              space,
                              const Text(' Experience(Optional)'),
                              SizedBox(
                                height: 55,
                                width: width * 0.9,
                                child: TextFormField(
                                    controller: experienceController,
                                    decoration:
                                        textField('Enter the experience'),
                                    cursorColor: textColor,
                                    style: textFieldStyle),
                              ),
                              space,
                              const Text(' Password'),
                              SizedBox(
                                height: 55,
                                width: width * 0.9,
                                child: TextFormField(
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
                                    cursorColor: textColor,
                                    style: textFieldStyle),
                              ),
                              space,
                            ])))),
            space,
            InkWell(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  final therapist = TherapistModel(
                    name: nameController.text,
                    id: widget.therapist.id,
                    email: widget.therapist.email,
                    experience: int.parse(experienceController.text),
                    bio: bioController.text,
                    qualification: qualificationController.text,
                    specialization: specializationController.text,
                    password: passwordController.text,
                  );
                  context.read<AdminBloc>().add(EditTherapistEvent(
                      therapist: therapist,
                      imageFile: image,
                      id: therapist.id!));
                  ScaffoldMessenger.of(context).showSnackBar(therapistEdited);
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
