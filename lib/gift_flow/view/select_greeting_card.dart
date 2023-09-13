import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../utils/routes.dart';

class SelectGreetingCard extends StatefulWidget {
  const SelectGreetingCard({Key? key}) : super(key: key);

  @override
  State<SelectGreetingCard> createState() => _SelectGreetingCardState();
}

class _SelectGreetingCardState extends State<SelectGreetingCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Select greeting card',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, Routes.wishInputRoute);
        },
        child: Container(
          width: screenSize.width / 2,
          decoration: ShapeDecoration(
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Skip this step ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.scaffoldBackground,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              width: screenSize.width,
              child: const Text(
                'You can choose a greeting card,  we print it with your wishes and deliver them with intense care and love on your behalf.\nOr you can choose to skip, a standard greeting card will be delivered with your wishes.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, Routes.greetingCardDetailRoute);
                  },
                  child: SizedBox(
                    width: screenSize.width / 3,
                    height: screenSize.width / 3,
                      child: Image.network("https://via.placeholder.com/120x120",fit: BoxFit.fill,)
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
