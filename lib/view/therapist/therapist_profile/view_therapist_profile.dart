import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/gradient.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/profile/profile_model.dart';

class ViewTherapistProfile extends StatelessWidget {
  final UserModel therapist;
  const ViewTherapistProfile({
    super.key,
    required this.therapist,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
              gradient: gradient,
            ),
          ),
          Positioned(
              top: 50,
              left: 5,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: white,
                        size: 35,
                      )),
                  hSpace,
                  const Text(
                    'Therapist Profile',
                    style: TextStyle(
                        fontSize: 18,
                        color: white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )),
          Positioned(
            top: 200,
            child: Container(
              width: width,
              height: height * 0.75,
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.125),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Dr. ${therapist.profile.name}',
                        style: semiBold,
                      ),
                      Text(
                        'Contact info : ${therapist.email}',
                        style: smallTextBold,
                      ),
                      space,
                      therapist.profile.bio == ""
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '"${therapist.profile.bio}"',
                                style: smallTextBoldI,
                                textAlign: TextAlign.center,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Specialization',
                              style: medBold,
                            ),
                            Text(
                              softWrap: true,
                              therapist.profile.specialization,
                              style: smallTextBold,
                            ),
                            space,
                            const Divider(),
                            space,
                            const Text(
                              'Qualification',
                              style: medBold,
                            ),
                            Text(
                              softWrap: true,
                              therapist.profile.qualification,
                              style: smallTextBold,
                            ),
                            space,
                            Row(
                              children: [
                                const Text(
                                  'Experience : ',
                                  style: medBold,
                                ),
                                Text(
                                  '${therapist.profile.experience.toString()}yrs',
                                  style: smallTextBold,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            left: width * 0.3,
            child: CircleAvatar(
              radius: 80,
              child: ClipOval(
                child: Image.network(
                  therapist.image,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
