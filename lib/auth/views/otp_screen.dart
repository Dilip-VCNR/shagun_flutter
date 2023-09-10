import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_widgets.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final CountdownController controller = CountdownController(autoStart: true);
  final int seconds = 30;
  bool firstStateEnabled = false;
  String? verificationId;
  String otpCode = "";

  AuthController authController = AuthController();
  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    verificationId = arguments['verificationId'];
    String phone = arguments['phone'];
    String countryCode = arguments['selectedCountryCode'];
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Image(
                            image: AssetImage('assets/images/otp_bg.png'))),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Enter the Verification code',
                      style: TextStyle(
                        color: AppColors.fontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'We have sent a verification code to \n$countryCode $phone',
                      style: const TextStyle(
                        color: AppColors.fontColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PinFieldAutoFill(
                      enabled: true,
                      currentCode: otpCode,
                      decoration: BoxLooseDecoration(
                          radius: const Radius.circular(12),
                          strokeColorBuilder:
                              const FixedColorBuilder(AppColors.fontColor)),
                      codeLength: 6,
                      onCodeChanged: (code) {
                        otpCode = code.toString();
                      },
                      onCodeSubmitted: (val) {},
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (firstStateEnabled) {
                              showLoaderDialog(context);
                              await authController.resendOtp(
                                  context, phone, countryCode, screenSize);
                              setState(() {
                                firstStateEnabled = false;
                                controller.restart(); // Restart the countdown
                              });
                            }
                          },
                          child: Countdown(
                            controller: controller,
                            seconds: seconds,
                            build: (context, time) => Text(
                              firstStateEnabled
                                  ? 'Resend'
                                  : 'Resend OTP in ${time.round()}',
                              style: TextStyle(
                                color: firstStateEnabled
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: () {
                              setState(() {
                                firstStateEnabled = !firstStateEnabled;
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Change Phone Number',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xB737474F),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        showLoaderDialog(context);
                        await authController.verifyOTPCode(context, otpCode,
                            verificationId, phone, countryCode);
                      },
                      child: Container(
                        width: screenSize.width,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: ShapeDecoration(
                          color: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Center(
                          child: Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
