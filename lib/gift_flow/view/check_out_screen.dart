import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<String> onBehalf = ["Me", "Others"];
  String? selectedOnBehalf;

  List<Map> charges = [
    {
      "name":'Greeting card',
      "price":'120'
    },
    {
      "name":'Delivery fee',
      "price":'50'
    },
    {
      "name":'Shagun amount',
      "price":'1100'
    },
    {
      "name":'Transaction charges',
      "price":'30'
    },
    {
      "name":'Service charges',
      "price":'40'
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Review and checkout',
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
                "Shagun amount will be settled to recipient's bank and the greeting card will be delivered to recipient on the selected delivery slot.",
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
              'You are sending shagun to Bharath\nfor his wedding',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "₹",
                        style: TextStyle(fontSize: 40, color: Colors.black),
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLength: 5,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: '0.0',
                            counterText: "",
                            isCollapsed: true,
                            filled: true,
                            fillColor: AppColors.scaffoldBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Sending on behalf of',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width,
                    child: const Text(
                      'Will be printed on greeting card',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < onBehalf.length; i++)
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedOnBehalf = onBehalf[i];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: screenSize.width / 4,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: ShapeDecoration(
                              color: selectedOnBehalf!=onBehalf[i]?Colors.white:AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 0.50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                onBehalf[i],
                                style: TextStyle(
                                  color: selectedOnBehalf==onBehalf[i]?Colors.white:AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      // if (authController.isNotValidName(value)) {
                      //   return "Please enter valid name";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      counterText: "",
                      isCollapsed: true,
                      filled: true,
                      fillColor: AppColors.inputFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: screenSize.width,
                    child: const Text(
                      'Select delivery slot',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width,
                    child: const Text(
                      'choose ideal date for delivery of the card',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select delivery date';
                      }
                      // if (authController.isNotValidName(value)) {
                      //   return "Please enter valid name";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.calendar_month_outlined,color: AppColors.primaryColor,),
                      hintText: 'Select delivery date',
                      counterText: "",
                      isCollapsed: true,
                      filled: true,
                      fillColor: AppColors.inputFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: screenSize.width,
                    child: const Text(
                      'Review payment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  for(int i=0;i<charges.length;i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          charges[i]['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '₹${charges[i]['price']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '₹1,320',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: screenSize.width,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: ShapeDecoration(
                        color: AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'Proceed to pay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
