import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/url_constants.dart';
import '../controller/profile_controller.dart';
import '../model/profile_data_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileController profileController = ProfileController();

  late Future<ProfileDataModel>? profileData;

  @override
  void initState() {
    super.initState();
    profileData = profileController.fetchProfileData(context);
  }

  Future<File?> _getImageFromGallery(File? selectedImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
    return selectedImage;
  }

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
    PrefModel prefModel = AppPref.getPref();

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
        body: FutureBuilder<ProfileDataModel>(
            future: profileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/loading.json', height: 150),
                      const Text(
                        "Loading...",
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  UrlConstant.imageBaseUrl +
                                      snapshot.data!.user!.profile!),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${snapshot.data!.user!.name}',
                                  style: const TextStyle(
                                    color: Color(0xFF3E3E3E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '+91 ${snapshot.data!.user!.phone}',
                                  style: const TextStyle(
                                    color: Color(0xFF545454),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    height: 1.53,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width / 1.7,
                                  child: Text(
                                    snapshot.data!.user!.email!,
                                    style: const TextStyle(
                                      color: Color(0xFF545454),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.53,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data!.user!.kyc != 1
                              ? 'Need to create your event and \nstart receiving shagun?'
                              : 'KYC Completed',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: snapshot.data!.user!.kyc != 1
                                    ? "To send and receive gifts! Please complete your KYC by simply clicking on the "
                                    : "Congratulations! Your KYC is successfully completed, Now you can start sending and receiving gifts!\nIf need to update anything? Please press the ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const TextSpan(
                                text: '“Request call back”',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text:
                                ' button.\nSo our backoffice team will reach you through the registered Mobile Number/Email.',
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
                        GestureDetector(
                          onTap: () async {
                            if (snapshot.data!.isActiveKycRequest == false) {
                              AuthController authController = AuthController();
                              showLoaderDialog(context);
                              await authController.requestKycCallBack(context);
                              if (context.mounted) {
                                Navigator.pop(context);
                                showSuccessToast(
                                  context,
                                  "Successfully raised the request\nOur back office team will get in touch with you soon !",
                                );
                                _pullRefresh();
                              }
                            } else {
                              showErrorToast(context,
                                  "You already have an active request !\nOur back office team will contact you soon");
                            }
                          },
                          child: Container(
                            width: screenSize.width / 2,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: !snapshot.data!.isActiveKycRequest!
                                  ? AppColors.secondaryColor
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            child: Center(
                              child: Text(
                                !snapshot.data!.isActiveKycRequest!
                                    ? 'Request callback'
                                    : "Already requested",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        snapshot.data!.kycData!.status == 1
                            ? Container(
                                width: screenSize.width,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("My KYC",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text("Verified",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: AppColors.secondaryColor,
                                              size: 20,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${snapshot.data!.kycData!.docName!} : ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          maskString(
                                              snapshot.data!.kycData!.docNum!,
                                              6),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${snapshot.data!.kycData!.docName1!} : ",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          maskString(
                                              snapshot.data!.kycData!.docNum1!,
                                              4),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            : const SizedBox.shrink(),
                        snapshot.data!.bankData!.isNotEmpty
                            ? Container(
                                width: screenSize.width,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data!.bankData!.length;
                                        i++)
                                      snapshot.data!.bankData![i].status == 1
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("My Active Bank",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Bank Name : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .bankData![i]
                                                          .bankName!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Bank Account Number : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      snapshot.data!
                                                          .bankData![i].accNo!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Bank IFSC : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .bankData![i]
                                                              .ifscCode!,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                    const Row(
                                                      children: [
                                                        Text("Active",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: AppColors
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: AppColors
                                                              .primaryColor,
                                                          size: 20,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink()
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
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
                                  TextEditingController nameController =
                                      TextEditingController();
                                  nameController.text =
                                      prefModel.userData!.user!.name!;
                                  File? selectedImage;
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor:
                                        AppColors.scaffoldBackground,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  right:20,
                                                    top:20,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        icon:
                                                            const Icon(Icons.cancel))),
                                                Container(
                                                  width: screenSize.width,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          File? newImage =
                                                              await _getImageFromGallery(
                                                                  selectedImage);
                                                          if (newImage != null) {
                                                            setState(() {
                                                              selectedImage =
                                                                  newImage;
                                                            });
                                                          }
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 50,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .secondaryColor,
                                                              backgroundImage:
                                                                  selectedImage !=
                                                                          null
                                                                      ? FileImage(
                                                                          selectedImage!)
                                                                      : NetworkImage(
                                                                          UrlConstant.imageBaseUrl +
                                                                              prefModel.userData!.user!.profile!,
                                                                        ) as ImageProvider,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Positioned(
                                                              bottom: 2,
                                                              right: 2,
                                                              child: CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor:
                                                                    Colors.grey
                                                                        .shade400,
                                                                child: IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .file_upload_outlined,
                                                                    size: 15,
                                                                  ),
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Full name *",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                nameController,
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return 'Please enter your name';
                                                              }
                                                              if (AuthController()
                                                                  .isNotValidName(
                                                                      value)) {
                                                                return "Please enter valid name";
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              errorStyle: const TextStyle(
                                                                  color: AppColors
                                                                      .secondaryColor),
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .person_2_outlined),
                                                              hintText:
                                                                  'Full Name',
                                                              counterText: "",
                                                              isCollapsed: true,
                                                              filled: true,
                                                              fillColor: AppColors
                                                                  .inputFieldColor,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          16.0),
                                                            ),
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          if (nameController
                                                                  .text ==
                                                              "") {
                                                            showErrorToast(
                                                                context,
                                                                "Name cannot be empty");
                                                            return;
                                                          }
                                                          if (AuthController()
                                                              .isNotValidName(
                                                                  nameController
                                                                      .text)) {
                                                            showErrorToast(
                                                                context,
                                                                "Please fill in valid name");
                                                          } else {
                                                            showLoaderDialog(
                                                                context);
                                                            await profileController
                                                                .updateProfileData(
                                                                    context,
                                                                    nameController
                                                                        .text,
                                                                    selectedImage);
                                                          }
                                                        },
                                                        child: Container(
                                                          width: double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 13.0),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: AppColors
                                                                .secondaryColor,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          child: const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Update information',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    fontSize: 17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    _pullRefresh();
                                  });
                                  break;
                                case 'about':
                                  Navigator.pushNamed(
                                      context, Routes.webViewRoute,
                                      arguments: {
                                        'url': UrlConstant.about,
                                        'title': "About",
                                      });
                                  break;
                                case 'faq':
                                  Navigator.pushNamed(
                                      context, Routes.webViewRoute,
                                      arguments: {
                                        'url': UrlConstant.faq,
                                        'title': "FAQ'S",
                                      });
                                  break;
                                case 'privacy':
                                  Navigator.pushNamed(
                                      context, Routes.webViewRoute,
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
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                        context, Routes.webViewRoute,
                                        arguments: {
                                          'url': UrlConstant.termsOfUse,
                                          'title': "Terms of use",
                                        });
                                  }
                                  break;
                                case 'logout':
                                  if (context.mounted) {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Confirm To Logout?'),
                                          content: const SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Are you sure?',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'You want to Logout',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Confirm',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onPressed: () {
                                                onLogoutConfirmed(screenSize);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  break;
                                default:
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: screenSize.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${snapshot.error}'),
                      ElevatedButton(
                          onPressed: _pullRefresh, child: const Text("Refresh"))
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Loading..."),
              );
            }));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      profileData = profileController.fetchProfileData(context);
    });
  }

  Future<void> onLogoutConfirmed(Size screenSize) async {
    showLoaderDialog(context);
    try {
      await FirebaseAuth.instance.signOut();
      AppPref.clearPref();
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.loginRoute, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        showErrorToast(context, "Oops ! $e");
      }
    }
  }

  String maskString(String inputString, int visibleChars) {
    if (inputString.isEmpty) {
      return '';
    }

    if (inputString.length <= visibleChars) {
      return inputString;
    }

    final maskedPart = '*' * (inputString.length - visibleChars);
    final visiblePart =
        inputString.substring(inputString.length - visibleChars);

    return '$maskedPart$visiblePart';
  }
}
