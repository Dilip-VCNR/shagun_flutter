import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../../utils/routes.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String orderId = arguments['transaction_id'];
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/order_success.png')),
            const Text(
              'Order Successful\nYour Shagun will be\ndelivered on time',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Your order id is\n$orderId',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: (){
                // Navigator.pushNamed(context, Routes.trackOrderScreen);
              },
              child: Container(
                width: screenSize.width/1.5,
                height: 50,
                decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: const Center(child: Text("Track",style: TextStyle(color: Colors.white,fontSize: 18),)),
              ),
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false);
              },
              child: Container(
                width: screenSize.width/1.5,
                height: 50,
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: const Center(child: Text("Home",style: TextStyle(color: Colors.white,fontSize: 18),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
