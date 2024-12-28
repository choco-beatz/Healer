import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/textstyle.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  late String greeting;

  @override
  void initState() {
    super.initState();
    updateGreeting();
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    log(hour.toString());
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      greeting,
      style: lightWhite,
    );
  }
}
