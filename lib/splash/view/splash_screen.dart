import 'package:flutter/material.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = SplashController();

  @override
  Widget build(BuildContext context) {
    splashController.moveToCorrespondingScreen(context);
    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage('assets/images/splash_logo.png')),
      ),
    );
  }
}
