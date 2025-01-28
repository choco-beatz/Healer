import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healer_therapist/bloc/admin/admin_bloc.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/view/admin/edit_therapist/edit_therapist_screen.dart';
import 'package:healer_therapist/widgets/dialog_button.dart';

class More extends StatelessWidget {
  final TherapistModel therapist;
  final String id;

  const More({super.key, required this.therapist, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditTherapist(therapist: therapist)));
          },
          child: const SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: main1,
                    size: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Edit',
                      style: smallBold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider(),
        SizedBox(
          height: 37,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: GestureDetector(
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
                              Navigator.of(context).pop();
                            },
                            child: buildButton(text: 'Cancel')),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              context.read<AdminBloc>().add(
                                    DeleteTherapistEvent(id: id),
                                  );
                              Navigator.of(context).pop();
                            },
                            child: buildButton(text: 'Delete', imp: true)),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.delete_outline_outlined,
                    color: red,
                    size: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'Delete',
                      style: smallBold,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
