import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../../utils/routes.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute
        .of(context)
        ?.settings
        .arguments ??
        <String, dynamic>{}) as Map;
    String type = arguments['type'];
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Event details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenSize.width,
              decoration: const ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.width,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const ShapeDecoration(
                      color: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Bharath invited you ',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://via.placeholder.com/80x80"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: OvalBorder(
                                      side: BorderSide(
                                          width: 5, color: Color(0xFF9F813C)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Bharath\nKumar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'WEDS',
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://via.placeholder.com/80x80"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: OvalBorder(
                                      side: BorderSide(
                                          width: 5, color: Color(0xFF9F813C)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Smitha\nRao',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 150,
                          width: 3,
                          color: AppColors.scaffoldBackground,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            color: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                '13\nOCT\nFriday',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: ShapeDecoration(
                                  color: AppColors.scaffoldBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  '12 PM',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Event venue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Agarwal Bhavan\nNo. 81, NH 4, Tumkur Road, Dasanpura, \nBengaluru, Karnataka 560123',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10,),
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
                  'Navigate on maps',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Reception',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              '12 October 2023\n8 : 00 PM to 10 : 00 PM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              'Muhurtham',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              '12 October 2023\n8 : 00 PM to 10 : 00 PM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 30,),
            type != 'own' ? GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, Routes.selectGreetingCardRoute);
              },
              child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEAB948),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  width: screenSize.width,
                padding: const EdgeInsets.symmetric(vertical: 15),child: const Center(child: Text(
                    'Send shagun to Bharath',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),)),
            ):const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
