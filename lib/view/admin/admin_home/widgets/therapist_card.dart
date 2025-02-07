import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/therapist/therapist_model.dart';
import 'package:healer_therapist/view/admin/admin_home/widgets/more.dart';
import 'package:popover/popover.dart';

class TherapistCard extends StatelessWidget {
  const TherapistCard({
    super.key,
    required this.therapist,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final TherapistModel therapist;

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(children: [
        // Background Image
        Container(
          height: height * 0.3,
          width: width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(therapist.image!),
              fit: BoxFit.cover,
              onError: (error, stackTrace) {},
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          height: height * 0.3,
          width: width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [transparent, black.withOpacity(0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  therapist.name,
                  style: buttonText,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  therapist.specialization,
                  style: xSmallWhite,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 10,
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                showPopover(
                  height: 100,
                  width: 140,
                  context: context,
                  backgroundColor: white,
                  direction: PopoverDirection.bottom,
                  bodyBuilder: (context) => More(
                    therapist: therapist,
                    id: therapist.id!,
                  ),
                );
              },
              child: const Icon(
                Icons.more_vert_rounded,
                color: white,
                size: 26,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
