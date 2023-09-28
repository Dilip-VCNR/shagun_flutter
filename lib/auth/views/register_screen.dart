import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  bool isLoaded = false;
  String? phone;
  String? countryCode;
  String? uid;
  String? email;
  String? authType;
  File? _selectedImage;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (!isLoaded) {
      phone = arguments['phone'];
      countryCode = arguments['countryCode']??"+91";
      uid = arguments['uid'];
      email = arguments['email'];
      authType = arguments['authType'];

      emailController.text = email == null ? "" : email!;
      phoneController.text = phone == null ? "" : phone!;
      isLoaded = true;
    }
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
                          "Please read the Privacy Policy and Terms and Conditions and apply check to proceed further");
                      return;
                    }
                    if(_selectedImage==null){
                      showErrorToast(context,
                          "Please upload a profile picture");
                      return;
                    }
                    showLoaderDialog(context);
                    final fcmToken =
                        await FirebaseMessaging.instance.getToken();
                    if (context.mounted) {
                      authController.apiCallForRegisterUser(
                          uid,
                          fcmToken,
                          nameController.text,
                          phoneController.text,
                          emailController.text,
                          authType!,
                          context,
                      _selectedImage);
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
                            color: AppColors.primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
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
                    GestureDetector(
                      onTap: _getImageFromGallery,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.scaffoldBackground,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Positioned(
                              bottom: 2,
                              right: 2,
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey.shade400,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.file_upload_outlined,
                                        size: 15,
                                      ),
                                      color: Colors.black)))
                        ],
                      ),
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
                        errorStyle:
                            const TextStyle(color: AppColors.secondaryColor),
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
                      enabled: authType == 'Google' ? false : true,
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
                        errorStyle:
                            const TextStyle(color: AppColors.secondaryColor),
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
                                enabled: authType == 'Phone' ? false : true,
                                onChanged: (element) {
                                  countryCode = element.dialCode;
                                },
                                initialSelection: 'IN',
                                favorite: const ['+91', 'IN'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                              SizedBox(
                                width: screenSize.width / 2,
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  enabled: authType == 'Phone' ? false : true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter valid phone number';
                                    }
                                    if (authController.isNotValidPhone(value)) {
                                      return "Please enter valid phone number";
                                    }
                                    return null;
                                  },
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: const InputDecoration(
                                      hintText: 'Phone Number',
                                      counterText: "",
                                      isCollapsed: true,
                                      border: InputBorder.none),
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
                    // TextFormField(
                    //   enabled: authType == 'Phone' ? false : true,
                    //   controller: phoneController,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter phone number';
                    //     }
                    //     if (authController.isNotValidPhone(value)) {
                    //       return "Please enter valid phone number";
                    //     }
                    //     return null;
                    //   },
                    //   keyboardType: TextInputType.number,
                    //   maxLength: 10,
                    //   decoration: InputDecoration(
                    //     errorStyle:
                    //         const TextStyle(color: AppColors.secondaryColor),
                    //     prefixIcon: const Icon(Icons.phone_outlined),
                    //     hintText: 'Phone number',
                    //     counterText: "",
                    //     isCollapsed: true,
                    //     filled: true,
                    //     fillColor: AppColors.inputFieldColor,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     contentPadding:
                    //         const EdgeInsets.symmetric(vertical: 16.0),
                    //   ),
                    //   textAlignVertical: TextAlignVertical.center,
                    // ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
