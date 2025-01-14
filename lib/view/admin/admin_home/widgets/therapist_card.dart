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
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        color: white,
        child: SizedBox(
            height: height * 0.165,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                        backgroundColor: transparent,
                        radius: width * 0.125,
                        child:
                            (therapist.image!.split('.').last == 'png')
                                ? Image.network(
                                    fit: BoxFit.fitHeight,
                                    therapist.image!,
                                    width: 90,
                                    height: 90,
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      fit: BoxFit.fitHeight,
                                      therapist.image!,
                                      width: 90,
                                      height: 90,
                                    ),
                                  ))),
                SizedBox(
                  width: width * 0.51,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        therapist.name,
                        style: smallBold
                      ),
                      Text(
                        therapist.qualification,
                        style: const TextStyle(color: main1),
                      ),
                      Text(
                        therapist.specialization,
                        style: const TextStyle(fontSize: 14, color: textColor),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, right: 5, bottom: 100),
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
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
