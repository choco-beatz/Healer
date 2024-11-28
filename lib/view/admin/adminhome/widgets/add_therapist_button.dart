
import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/view/admin/addtherapist/add_therapist_screen.dart';

class AddTherapistButton extends StatelessWidget {
  const AddTherapistButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: main1,
        foregroundColor: white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddTherapist())));
        },
        label: const Row(
          children: [
            Icon(
              Icons.add,
              color: white,
            ),
            Text(
              ' Add Therapist',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ));
  }
}
