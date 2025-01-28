import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key, required this.title, required this.image});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 170,
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
              radius: 30,
              child: (image.split('.').last == 'png')
                  ? Image.network(
                      fit: BoxFit.cover,
                      image,
                      width: 65,
                      height: 65,
                    )
                  : ClipOval(
                      child: Image.network(
                        fit: BoxFit.cover,
                        image,
                        width: 65,
                        height: 65,
                      ),
                    )),
          hSpace,
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.chevron_left,
            size: 30,
          )),
      backgroundColor: white,
    );
  }
}
