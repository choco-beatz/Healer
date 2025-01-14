import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/widgets/appbar.dart';
import 'package:healer_therapist/widgets/dialog_button.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(title: 'About us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              space,
              const Text(
                'About Us',
                style: bigBold,
              ),
              space,
              space,
              const Text(
                style: smallBold,
                "Welcome to Healer! We are dedicated to making mental health support accessible and effective for everyone. Our app is designed to connect clients with professional therapists and facilitate seamless online therapy sessions.",
              ),
              const Divider(),
              space,
              const Text(style: semiBold, 'Our Story'),
              space,
              const Text(
                style: smallBold,
                "The idea for Healer was born from my personal mental health journey. I realized the challenges many face in accessing therapy and decided to create a platform that bridges the gap between clients and therapists. Using Flutter for the frontend, BLoC state management, and a robust backend built by my friend using Node.js and MongoDB, Healer was crafted to offer a comprehensive therapy booking solution.",
              ),
              const Divider(),
              space,
              const Text(style: semiBold, 'Features'),
              space,
              const Text(
                style: smallBold,
                '''1. Browse Therapists: Clients can explore a wide range of therapists based on their preferences.
2. Online Therapy Sessions: Chat and call features are available for conducting therapy sessions.
3. Therapist Availability: Check real-time availability of therapists and book sessions accordingly.
4. Secure Payments: Easily book sessions by making payments through Razorpay.
5. Client-Therapist Connection: Build strong connections by becoming a client of your chosen therapist.''',
              ),
              const Divider(),
              space,
              const Text(style: semiBold, 'Our Goal'),
              space,
              const Text(
                style: smallBold,
                "At Healer, our mission is to make therapy and mental health professionals more accessible to everyone. We believe in the power of mental health support and aim to simplify the process of seeking help.",
              ),
              const Divider(),
              space,
              const Text(style: semiBold, 'Get in Touch'),
              space,
              const Text(
                style: smallBold,
                '''We would love to hear from you! Whether you have feedback, questions, or need support, feel free to reach out:
                
Email: healer.therapyapp@gmail.com''',
              ),
              space,
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: buildButton(text: 'Done'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
