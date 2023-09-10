import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/url_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List options = [
    {'title': 'Edit Profile', 'icon': Icons.edit, 'clickType': 'edit_profile'},
    {'title': 'About', 'icon': Icons.info_outline, 'clickType': 'about'},
    {'title': 'FAQ’S', 'icon': Icons.question_mark_rounded, 'clickType': 'faq'},
    {
      'title': 'Privacy policy',
      'icon': Icons.fingerprint,
      'clickType': 'privacy'
    },
    {
      'title': 'Mail to us',
      'icon': Icons.mail_lock_outlined,
      'clickType': 'mail'
    },
    {
      'title': 'Terms and conditions',
      'icon': Icons.edit_note_rounded,
      'clickType': 'tc'
    },
    {
      'title': 'Log out',
      'icon': Icons.power_settings_new,
      'clickType': 'logout'
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.fontColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage("https://via.placeholder.com/50x50"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tony stark',
                        style: TextStyle(
                          color: Color(0xFF3E3E3E),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '+91 8660225160',
                        style: TextStyle(
                          color: Color(0xFF545454),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.53,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Need to create your event and \nstart receiving shagun?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'We noticed you have not initiated your KYC process,\nto create your event and start receiving shagun please\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '“Request for callback”',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' so our backoffice will contact you\nand guide.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: screenSize.width / 2,
                height: 40,
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: const Center(
                  child: Text(
                    'Request callback',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              for (int i = 0; i < options.length; i++)
                InkWell(
                  onTap: () async {
                    switch (options[i]['clickType']) {
                      case 'edit_profile':
                        break;
                      case 'about':
                        Navigator.pushNamed(context, Routes.webViewRoute,
                            arguments: {
                              'url': UrlConstant.about,
                              'title': "About",
                            });
                        break;
                      case 'faq':
                        Navigator.pushNamed(context, Routes.webViewRoute,
                            arguments: {
                              'url': UrlConstant.faq,
                              'title': "FAQ'S",
                            });
                        break;
                      case 'privacy':
                        Navigator.pushNamed(context, Routes.webViewRoute,
                            arguments: {
                              'url': UrlConstant.privacyPolicy,
                              'title': "Privacy Policy",
                            });
                        break;
                      case 'mail':
                        if (!await launchUrl(
                          Uri.parse("mailto:support@thebuysapp.com"),
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw Exception('Could not launch');
                        }
                        break;
                      case 'tc':
                        Navigator.pushNamed(context, Routes.webViewRoute,
                            arguments: {
                              'url': UrlConstant.termsOfUse,
                              'title': "Terms of use",
                            });
                        break;
                      case 'logout':
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.loginRoute, (route) => false);
                        break;
                      default:
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: screenSize.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              options[i]['icon'],
                              color: AppColors.fontColor,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              options[i]['title'],
                              style: const TextStyle(
                                color: AppColors.fontColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
