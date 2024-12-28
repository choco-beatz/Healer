import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/model/user/user_model.dart';

class ClientDetails extends StatelessWidget {
  final ClientModel client;
  const ClientDetails({
    super.key,
    required this.client,
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
                  client.image),
              Positioned(
                  top: 30,
                  left: 25,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: black,
                        size: 35,
                      )))]),
          SizedBox(
            height: height * 0.62,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: semiBold,
                    ),
                    space,
                    const Text(
                      'Contact',
                      style: smallBold,
                    ),
                    smallSpace,
                    Text(
                      client.email,
                      style: textFieldStyle,
                    )]))))]));
  }
}
