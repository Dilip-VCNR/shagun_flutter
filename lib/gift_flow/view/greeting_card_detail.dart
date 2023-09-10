import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/routes.dart';

class GreetingCardDetail extends StatefulWidget {
  const GreetingCardDetail({Key? key}) : super(key: key);

  @override
  State<GreetingCardDetail> createState() => _GreetingCardDetailState();
}

class _GreetingCardDetailState extends State<GreetingCardDetail> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Card details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: screenSize.width,
                child: const Image(
                    image: NetworkImage('https://via.placeholder.com/520x420'))),
            const SizedBox(height: 10,),
            const Text(
              'WED_09_AXMKL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5,),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Dimensions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' : 4x4 (inch)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Quality',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' : Grade A Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' : ₹140',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap:(){
                Navigator.pushNamed(context, Routes.wishInputRoute);
              },
              child: Container(
                width: screenSize.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    'Use this card and continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.scaffoldBackground,
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
    );
  }
}
