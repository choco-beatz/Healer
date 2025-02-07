import 'package:flutter/material.dart';
import 'package:healer_therapist/constants/space.dart';
import 'package:healer_therapist/constants/textstyle.dart';
import 'package:healer_therapist/view/therapist/appointment/widgets/request_button.dart';
import 'package:healer_therapist/widgets/appbar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: const PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: CommonAppBar(title: 'Privacy Policy'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space,
            const Text('Privacy Policy for Healer', style: bigBold),
            space,
            const Text('Last updated: February 04, 2025', style: smallBold),
            space,
            const Text(
              'This Privacy Policy describes Our policies and procedures on the collection, use, and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
              style: smallBold,
            ),
            space,
            const Text(
              'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
              style: smallBold,
            ),
            space,
            const Text('Interpretation and Definitions', style: semiBold),
            space,
            const Text('Interpretation', style: smallBold),
            space,
            const Text(
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
              style: smallBold,
            ),
            space,
            const Text('Definitions', style: semiBold),
            space,
            const Text(
              'For the purposes of this Privacy Policy:',
              style: smallBold,
            ),
            space,
            const Text(
              '''1. Account: A unique account created for You to access our Service.
2. Affiliate: An entity that controls, is controlled by, or is under common control with a party.
3. Application: Refers to Healer, the software program provided by the Company.
4. Company: Referred to as "the Company", "We", "Us", or "Our" in this Agreement, refers to Healer.
5. Country: Refers to Kerala, India.
6. Device: Any device that can access the Service such as a computer, cellphone, or digital tablet.
7. Personal Data: Any information that relates to an identified or identifiable individual.
8. Service: Refers to the Application.
9. Service Provider: Any natural or legal person who processes data on behalf of the Company.
10. Usage Data: Data collected automatically, either generated by the use of the Service or from the Service infrastructure itself.''',
              style: smallBold,
            ),
            space,
            const Text('Collecting and Using Your Personal Data', style: semiBold),
            space,
            const Text('Types of Data Collected', style: smallBold),
            space,
            const Text('Personal Data', style: semiBold),
            space,
            const Text(
              'While using Our Service, We may ask You to provide Us with certain personally identifiable information including:',
              style: smallBold,
            ),
            space,
            const Text(
              '''1. Email address
2. First name and last name
3. Usage Data''',
              style: smallBold,
            ),
            space,
            const Text('Usage Data', style: semiBold),
            space,
            const Text(
              'Usage Data is collected automatically and may include information such as IP address, browser type, pages visited, and time spent on pages.',
              style: smallBold,
            ),
            space,
            const Text('Information Collected while Using the Application', style: semiBold),
            space,
            const Text(
              'While using Our Application, with Your permission, we may collect pictures and other information from Your Device’s camera and photo library.',
              style: smallBold,
            ),
            space,
            const Text('Use of Your Personal Data', style: semiBold),
            space,
            const Text(
              'We may use Your Personal Data to provide and maintain our Service, manage Your Account, perform contracts, contact You, provide updates, manage requests, and for business transfers or analytics.',
              style: smallBold,
            ),
            space,
            const Text('Sharing Your Personal Data', style: semiBold),
            space,
            const Text(
              'We may share Your personal information with Service Providers, business partners, affiliates, or during business transfers with Your consent.',
              style: smallBold,
            ),
            space,
            const Text('Contact Us', style: semiBold),
            space,
            const Text(
             '''If you have any questions or concerns about this Privacy Policy, please contact us:

Email: healer.therapyapp@gmail.com''',
              style: smallBold,
            ),
            space,
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: buildButton(text: 'Done'),
            ),
          ],
        ),
      ),
    ),
  );
}
}