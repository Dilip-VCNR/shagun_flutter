import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../utils/routes.dart';
import '../../utils/url_constants.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  String? selectedCountryCode = "+91";
  final _formKey = GlobalKey<FormState>();
  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: screenSize.height / 3,
                child: const Center(
                    child: Image(
                        image: AssetImage('assets/images/logo_gold.png')))),
            const Text(
              'Login or Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'We need to verify you. We will send you a one time \nverification code. ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenSize.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CountryCodePicker(
                        showFlag: true,
                        enabled: true,
                        onChanged: (element) {
                          selectedCountryCode = element.dialCode;
                        },
                        initialSelection: 'IN',
                        favorite: const ['+91', 'IN'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          width: screenSize.width / 2,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter valid phone number';
                              }
                              if (authController.isNotValidPhone(value)) {
                                return "Please enter valid phone number";
                              }
                              return null;
                            },
                            controller: phoneNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                counterText: "",
                                isCollapsed: true,
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, Routes.otpScreenRoute,
                      arguments: {
                        'phone': phoneNumberController.text,
                        'selectedCountryCode': selectedCountryCode,
                        'verificationId': ""
                      });
                }
              },
              child: Container(
                width: screenSize.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: AppColors.secondaryColor),
                child: const Center(
                  child: Text(
                    "Proceed with phone",
                    style: TextStyle(
                      color: Color(0xFF42033D),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Or choose to social login',
              style: TextStyle(
                color: Color(0xFFEEF7FC),
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'choose to sign in using social login options',
              style: TextStyle(
                color: Color(0xFFEEF7FC),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Container(
                width: screenSize.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.white),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                        image: AssetImage(
                      'assets/images/google.png',
                    )),
                    Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: Color(0xFF42033D),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: screenSize.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage(
                    'assets/images/facebook.png',
                  )),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: Color(0xFF42033D),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded)
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenSize.width,
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'By clicking on proceed, you agree with our '),
                    TextSpan(
                      text: 'Privacy Policy ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, Routes.webViewRoute,
                              arguments: {
                                'url': UrlConstant.privacyPolicy,
                                'title': "Privacy Policy",
                              });
                        },
                    ),
                    const TextSpan(text: 'and '),
                    TextSpan(
                      text: 'Terms and conditions',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, Routes.webViewRoute,
                              arguments: {
                                'url': UrlConstant.termsOfUse,
                                'title': "Terms and Conditions",
                              });
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
