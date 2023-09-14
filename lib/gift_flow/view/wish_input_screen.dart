import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../dashboard/my_events/model/greetings_and_wishes_model.dart';
import '../../utils/routes.dart';

class WishInputScreen extends StatefulWidget {
  const WishInputScreen({Key? key}) : super(key: key);

  @override
  State<WishInputScreen> createState() => _WishInputScreenState();
}

class _WishInputScreenState extends State<WishInputScreen> {
  String? giftToUid;
  String? giftToName;
  int? giftToEventId;
  GreetingsAndWishesModel? greetingsAndWishes;
  ActiveGreetingCard? selectedGreetingCard;

  TextEditingController wishController = TextEditingController();
  int? selectedWishIndex;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    giftToUid = arguments['gift_to']['uid'];
    giftToName = arguments['gift_to']['name'];
    giftToEventId = arguments['gift_to']['event_id'];
    greetingsAndWishes = arguments['data'];
    selectedGreetingCard = arguments['selected_card_details'];

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
              'Choose from below',
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
              itemCount: greetingsAndWishes!.wishes!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    if(selectedWishIndex==index){
                      setState(() {
                        selectedWishIndex=null;
                        wishController.clear();
                      });
                    }else{
                      setState(() {
                        selectedWishIndex=index;
                        wishController.text = greetingsAndWishes!.wishes![index];
                      });
                    }
                  },
                  child: Container(
                    width: screenSize.width,
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: index==selectedWishIndex?const BorderSide(width: 1.50, color: Color(0xFF42033D)):BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 342,
                      child: Text(
                        '${greetingsAndWishes!.wishes![index]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
              height: 10,
            ),
            const Text(
              'Or write your wishes',
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
                  controller: wishController,
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
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                if(wishController.text.isNotEmpty){
                  Map orderParams = {
                    "delivery_fee":arguments['delivery_fee'],
                    "receiver_uid":giftToUid,
                    "gift_to_name":giftToName,
                    "event_id":giftToEventId,
                    "wish": wishController.text,
                    "greeting_card_id": selectedGreetingCard!=null?selectedGreetingCard!.cardId:null,
                    "greeting_card_price": selectedGreetingCard!=null?selectedGreetingCard!.cardPrice:null
                  };
                  Navigator.pushNamed(context, Routes.checkOutRoute,
                      arguments: orderParams);
                }else{
                  showErrorToast(context, "Please select or input your wishes");
                }
              },
              child: Container(
                width: screenSize.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Center(child: Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
