import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/client/client_model.dart';


class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.client,
    required this.height,
    required this.width,
    required this.onVideoCall,
    required this.onDetails,
  });

  final double height;
  final double width;
  final VoidCallback onDetails;
  final ClientModel client;
  final VoidCallback onVideoCall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Card(
        elevation: 4, // Adds a shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            children: [
              // **Profile Picture**
              CircleAvatar(
                  backgroundColor: transparent,
                  radius: width * 0.08,
                  backgroundImage: NetworkImage(client.image)),
              const SizedBox(width: 15), // Spacing

              // **Client Name**
              Expanded(
                child: Text(
                  client.profile.name,
                  style: smallBold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              IconButton(
                onPressed: onVideoCall,
                icon: const Icon(Icons.videocam, color: main1, size: 28),
              ),
              IconButton(
                onPressed: onDetails,
                icon: const Icon(Icons.info_outline, color: main1, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
