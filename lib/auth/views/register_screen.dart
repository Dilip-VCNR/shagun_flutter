import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../utils/app_widgets.dart';
import '../../utils/routes.dart';
import '../../utils/url_constants.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool termsAndConditionsIsChecked = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Your Information",
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
          height: 150,
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
              color: AppColors.primaryColor),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: AppColors.primaryColor,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          margin: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            Icons.newspaper_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width - 150,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text:
                                        'By clicking on proceed, you agree with our '),
                                TextSpan(
                                  text: 'Privacy Policy ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, Routes.webViewRoute,
                                          arguments: {
                                            'url': UrlConstant.privacyPolicy,
                                            'title': "Privacy Policy",
                                          });
                                    },
                                ),
                                const TextSpan(text: 'and '),
                                TextSpan(
                                  text: 'Terms and conditions',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, Routes.webViewRoute,
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
                    Checkbox(
                      side: const BorderSide(
                        color: AppColors.secondaryColor,
                        width: 1.5,
                      ),
                      checkColor: AppColors.primaryColor,
                      activeColor: AppColors.secondaryColor,
                      value: termsAndConditionsIsChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          termsAndConditionsIsChecked = value!;
                        });
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (!termsAndConditionsIsChecked) {
                      showErrorToast(context,
                          "Please read the privacy policy and terms and conditions and apply check to proceed further");
                      return;
                    }
                    showLoaderDialog(context);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.dashboardRoute, (route) => false);
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Finish, Good to go',
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 17,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'It looks like you don’t have account in this number. \nPlease let us know some information \nfor secure service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Positioned(
                            bottom: 2,
                            right: 2,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                    color: Colors.black)))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (authController.isNotValidName(value)) {
                          return "Please enter valid name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: AppColors.secondaryColor),
                        prefixIcon: const Icon(Icons.person_2_outlined),
                        hintText: 'Full Name',
                        counterText: "",
                        isCollapsed: true,
                        filled: true,
                        fillColor: AppColors.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (authController.isNotValidEmail(value)) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: AppColors.secondaryColor),
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: 'Email',
                        counterText: "",
                        isCollapsed: true,
                        filled: true,
                        fillColor: AppColors.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (authController.isNotValidPhone(value)) {
                          return "Please enter valid phone number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: AppColors.secondaryColor),
                        prefixIcon: const Icon(Icons.phone_outlined),
                        hintText: 'Phone number',
                        counterText: "",
                        isCollapsed: true,
                        filled: true,
                        fillColor: AppColors.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
