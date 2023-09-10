import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../utils/routes.dart';

class WishInputScreen extends StatefulWidget {
  const WishInputScreen({Key? key}) : super(key: key);

  @override
  State<WishInputScreen> createState() => _WishInputScreenState();
}

class _WishInputScreenState extends State<WishInputScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Write a wish to print on card',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenSize.width,
              child: const Text(
                'We print your wishes on greeting card and deliver them with intense care and love on your behalf.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Write your wishes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                child: TextFormField(
              // controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your greeting';
                }
                return null;
              },
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'write your wishes here',
                counterText: "",
                isCollapsed: true,
                filled: true,
                fillColor: AppColors.inputFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              ),
              textAlignVertical: TextAlignVertical.center,
            )),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Or choose from below',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: index==1?const BorderSide(width: 1.50, color: Color(0xFF42033D)):BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const SizedBox(
                    width: 342,
                    child: Text(
                      'Congratulations to both of you on your special day! Your greatest adventure has just begun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 15,
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, Routes.checkOutRoute);
              },
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
