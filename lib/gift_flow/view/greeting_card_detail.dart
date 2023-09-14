import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/routes.dart';
import 'package:shagun_mobile/utils/url_constants.dart';

import '../../dashboard/my_events/model/greetings_and_wishes_model.dart';

class GreetingCardDetail extends StatefulWidget {
  const GreetingCardDetail({Key? key}) : super(key: key);

  @override
  State<GreetingCardDetail> createState() => _GreetingCardDetailState();
}

class _GreetingCardDetailState extends State<GreetingCardDetail> {
  String? giftToUid;
  String? giftToName;
  int? giftToEventId;
  GreetingsAndWishesModel? greetingsAndWishes;
  ActiveGreetingCard? selectedGreetingCard;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    giftToUid = arguments['gift_to']['uid'];
    giftToName = arguments['gift_to']['name'];
    giftToEventId = arguments['gift_to']['event_id'];
    greetingsAndWishes = arguments['data'];
    selectedGreetingCard = arguments['selected_card_details'];
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
                child: Image(
                    image: NetworkImage(
                  '${UrlConstant.imageBaseUrl}${selectedGreetingCard!.cardImageUrl}',
                ))),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${selectedGreetingCard!.cardName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
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
            const SizedBox(
              height: 5,
            ),
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
            const SizedBox(
              height: 5,
            ),
            Text.rich(
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
                    text: ' : ₹${selectedGreetingCard!.cardPrice.toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.wishInputRoute,arguments: arguments);
              },
              child: Container(
                width: screenSize.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
