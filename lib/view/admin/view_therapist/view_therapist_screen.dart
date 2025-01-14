import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';

import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/view/admin/edit_therapist/edit_therapist_screen.dart';
import 'package:healer_therapist/view/admin/view_therapist/widgets/buttons.dart';
import 'package:healer_therapist/widgets/dialog_button.dart';

class ViewTherapist extends StatelessWidget {
  final TherapistModel therapist;
  const ViewTherapist({
    super.key,
    required this.therapist,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                  fit: BoxFit.fitWidth,
                  width: width,
                  height: height * 0.3,
                  therapist.image!),
              Positioned(
                  top: 30,
                  left: 25,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: black,
                        size: 35,
                      )))
            ],
          ),
          SizedBox(
            height: height * 0.62,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${therapist.name}',
                      style: semiBold,
                    ),
                    space,
                    const Text(
                      'Qualification',
                      style: smallBold,
                    ),
                    smallSpace,
                    Text(
                      therapist.qualification,
                      style: textFieldStyle,
                    ),
                    space,
                    const Text(
                      'Specialization',
                      style: smallBold,
                    ),
                    smallSpace,
                    Text(
                      therapist.specialization,
                      style: textFieldStyle,
                    ),
                    space,
                    const Text(
                      'Contact',
                      style: smallBold,
                    ),
                    smallSpace,
                    Text(
                      therapist.email,
                      style: textFieldStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditTherapist(therapist: therapist)));
                },
                child: buildViewButton(text: 'Edit', width: width * 0.43),
              ),
              hSpace,
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Confirm Deletion",
                          style: semiBold,
                        ),
                        content: const Text(
                          "Are you sure you want to delete this therapist?",
                          style: textFieldStyle,
                        ),
                        actions: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: buildButton(text: 'Cancel')),
                          GestureDetector(
                              onTap: () {
                                context.read<AdminBloc>().add(
                                      DeleteTherapistEvent(id: therapist.id!),
                                    );
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: buildButton(text: 'Delete', imp: true)),
                        ],
                      );
                    },
                  );
                },
                child: buildViewButton(
                    text: 'Delete', imp: true, width: width * 0.43),
              )
            ],
          ),
        ],
      ),
    );
  }
}
