import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/request_button.dart';
import 'package:healer_therapist/widgets/appbar.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppBar(title: 'Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              space,
              const Text('Terms and Conditions', style: bigBold,),
              space,
              
              space,
              const Text(
                '''Welcome to Healer! By using our app, you agree to comply with the following terms and conditions. These terms govern your access to and use of Healer's services, including therapy booking, online therapy sessions, and payment transactions.''',
style: smallBold,
              ),
              
              space,
              const Text('User Responsibilities',
              style: semiBold),
              space,
              const Text(style: smallBold,
                '''1. You must be at least 18 years old to use Healer.
2. All information provided during registration must be accurate and up-to-date.
3. Users are responsible for maintaining the confidentiality of their login credentials.
4. Therapy sessions and communications must remain respectful and professional at all times.''',
              ),
              const Divider(),
              space,
              const Text('Service Terms',
              style: semiBold),
              space,
              const Text(style: smallBold,
                '''1. Healer acts as a platform to connect clients with therapists. We do not provide therapy services directly.
2. The availability of therapists and session timings are subject to their schedules.
3. Payments for therapy sessions must be completed through Razorpay, and refunds are subject to our refund policy.
4. Healer is not responsible for the content or outcomes of therapy sessions. Responsibility lies solely with the therapist and client.''',
              ),
              
              space,
              const Text('Prohibited Activities',
              style: semiBold),
              space,
              const Text(style: smallBold,
                '''1. Misusing the platform to harass or harm therapists or other users.
2. Sharing or distributing content that violates privacy or is offensive.
3. Engaging in unauthorized access, hacking, or other malicious activities.''',
              ),
              
              space,
              const Text('Privacy Policy',
              style: semiBold),
              space,
              const Text(style: smallBold,
                "Your privacy is important to us. Healer collects and uses user data in accordance with our Privacy Policy. By using the app, you consent to this data usage. For details, refer to the Privacy Policy section in the app.",
              ),
              
              space,
              const Text('Limitation of Liability',
              style: semiBold),
              space,
              const Text(style: smallBold,
                '''Healer is not liable for:
1. Any professional advice or therapy outcomes provided by therapists.
2. Technical issues or interruptions in the app's functionality.
3. Loss of data or unauthorized access due to user negligence.''',
              ),
              
              space,
              const Text('Amendments',
              style: semiBold),
              space,
              const Text(style: smallBold,
                "Healer reserves the right to update or modify these terms at any time. Users will be notified of any significant changes through the app. Continued use of the app after changes indicates acceptance of the updated terms.",
              ),
              
              space,
              const Text('Contact Us',
              style: semiBold),
              space,
              const Text(style: smallBold,
                '''If you have any questions or concerns regarding these terms, please contact us:
                
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
