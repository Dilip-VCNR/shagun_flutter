import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:intl/intl.dart';
import 'package:shagun_mobile/auth/controller/auth_controller.dart';
import 'package:shagun_mobile/gift_flow/controller/orderController.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../database/app_pref.dart';
import '../../database/models/pref_model.dart';
import '../../utils/routes.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  double transactionFee = 0.0;
  double serviceCharge = 0.0;
  double? deliveryFee;
  double? totalAmount;
  double greetingCardPrice = 0.0;

  OrderController orderController = OrderController();

  List<String> onBehalf = ["Me", "Others"];
  String? selectedOnBehalf;
  PrefModel prefModel = AppPref.getPref();

  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 30)), // Limit to 30 days from now
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        selectedDateController.text=DateFormat("dd/MM/yyyy").format(
            DateTime.parse(selectedDate
                .toString()));
      });
    }
  }


  TextEditingController selectedOnBehalfOfController = TextEditingController();
  TextEditingController shagunAmountController = TextEditingController();
  TextEditingController selectedDateController = TextEditingController();
  bool isLoaded= false;
  String? wish;
  int? greetingCardId;
  var cfPaymentGatewayService = CFPaymentGatewayService();
  CFEnvironment environment = CFEnvironment.SANDBOX;

  String? giftToName;
  @override
  void initState() {
    super.initState();
    shagunAmountController.text = "";
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  late final arguments;


  Future<void> verifyPayment(String orderId) async {
    showLoaderDialog(context);
    await orderController.createOrder(arguments, context);
    if (context.mounted) {
      Navigator.pushNamed(context, Routes.orderSuccessRoute,
          arguments: {"transaction_id": orderId});
    }
  }


  void onError(CFErrorResponse errorResponse, String orderId) {
    showErrorToast(context, errorResponse.getMessage()!);
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoaded){
      arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      wish = arguments['wish'];
      greetingCardId = arguments['greeting_card_id'];
      greetingCardPrice = arguments['greeting_card_price'] ?? 0.0;
      deliveryFee = arguments['delivery_fee'];
      giftToName = arguments['gift_to_name'];
      totalAmount = arguments['delivery_fee']+greetingCardPrice;
    }

    isLoaded = true;
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              Text(
                'You are sending shagun to $giftToName\nfor his ${arguments['event_type']}',
                style: const TextStyle(
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
                              enableInteractiveSelection : false,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'-')), // Deny the '-' sign
                            ],
                            keyboardType: TextInputType.number,
                            controller: shagunAmountController,
                            onChanged: (val) {
                              setState(() {
                                // Parse the value and ensure it's not negative
                                double parsedValue = double.tryParse(val) ?? 0.0;
                                if (parsedValue < 0.0) {
                                  shagunAmountController.text = ''; // Set the text to '0.0' for negative values
                                  parsedValue = 0.0; // Set parsedValue to 0.0 for negative values
                                }
                                transactionFee = 0.05 * parsedValue;
                                serviceCharge = 0.03 * parsedValue;
                                totalAmount = parsedValue + transactionFee + serviceCharge + greetingCardPrice + (deliveryFee ?? 0.0);

                                transactionFee = double.parse(transactionFee.toStringAsFixed(2));
                                serviceCharge = double.parse(serviceCharge.toStringAsFixed(2));
                                totalAmount = double.parse(totalAmount!.toStringAsFixed(2));
                              });
                            },
                            maxLength: 7,
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
                            onTap: () {
                              setState(() {
                                selectedOnBehalf = onBehalf[i];
                                if (selectedOnBehalf == "Me") {
                                  selectedOnBehalfOfController.text =
                                      prefModel.userData!.user!.name!;
                                } else {
                                  selectedOnBehalfOfController.clear();
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: screenSize.width / 4,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: ShapeDecoration(
                                color: selectedOnBehalf != onBehalf[i]
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 0.50),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  onBehalf[i],
                                  style: TextStyle(
                                    color: selectedOnBehalf == onBehalf[i]
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLength: 250,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter name';
                        }
                        if (AuthController().isNotValidName(value)) {
                          return "Please enter valid name";
                        }
                        return null;
                      },
                      controller: selectedOnBehalfOfController,
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => selectDate(context),
                      child: TextFormField(
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
                        controller: selectedDateController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryColor,
                          ),
                          hintText: 'Select delivery date',
                          counterText: "",
                          isCollapsed: true,
                          filled: true,
                          fillColor: AppColors.inputFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Greeting card',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '₹$greetingCardPrice',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery fee',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '₹$deliveryFee',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Shagun amount',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              shagunAmountController.text.isNotEmpty
                                  ? '₹${shagunAmountController.text}'
                                  : '₹0.0',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Transaction fee',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '₹$transactionFee',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Service charge',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '₹$serviceCharge',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹$totalAmount',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (shagunAmountController.text.isEmpty ||
                            shagunAmountController.text == "0") {
                          showErrorToast(
                            context,
                            "Please provide a valid shagun amount",
                          );
                        } else if (double.parse(shagunAmountController.text)<1) {
                          showErrorToast(
                            context,
                            "Shagun amount should be greater than 1 rupee",
                          );
                        }else if (selectedDate == null) {
                          showErrorToast(
                            context,
                            "Please select a delivery date",
                          );
                        } else if (selectedOnBehalfOfController.text.isEmpty) {
                          showErrorToast(
                              context, "Please provide the gifter's name");
                        } else if (containsDigits(
                            selectedOnBehalfOfController.text)) {
                          showErrorToast(
                            context,
                            "Gifter's name should not contain integers",
                          );
                        } else if (containsSpecialCharacters(
                            selectedOnBehalfOfController.text)) {
                          showErrorToast(
                            context,
                            "Gifter's name should not contain special characters",
                          );
                        }
                        // else if (containsBlankSpaces(
                        //     selectedOnBehalfOfController.text)) {
                        //   showErrorToast(
                        //     context,
                        //     "Gifter's name should not contain blank spaces",
                        //   );
                        // }
                        else {
                          arguments['transaction_id'] = prefModel.userData!.user!.userId! +
                              DateTime.now().millisecondsSinceEpoch.toString();
                          arguments['payment_status'] = "Success";
                          arguments['greeting_card_price'] = greetingCardPrice;
                          arguments['delivery_fee'] = deliveryFee;
                          arguments['transaction_fee'] = transactionFee;
                          arguments['service_charge'] = serviceCharge;
                          arguments['shagun_amount'] =
                              double.parse(shagunAmountController.text);
                          arguments['status'] = true;
                          arguments['gifter_name'] = selectedOnBehalfOfController.text;
                          arguments['transaction_amount'] = totalAmount;
                          arguments['payment_session_id'] = await orderController
                              .getPaymentSessionId(arguments, context);
                          cashFreePay(arguments['payment_session_id'],
                              arguments['transaction_id']);
                      }},
                      child: Container(
                        width: screenSize.width,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: ShapeDecoration(
                          color: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
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
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void cashFreePay(String paymentSessionId, String orderId) {
    try {
      var session = createSession(paymentSessionId,orderId);
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      components.add(CFPaymentModes.CARD);
      components.add(CFPaymentModes.NETBANKING);
      components.add(CFPaymentModes.WALLET);
      components.add(CFPaymentModes.PAYLATER);
      components.add(CFPaymentModes.EMI);
      var paymentComponent =
      CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#5E015A")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      showErrorToast(context, e.message);
    }
  }


  CFSession? createSession(String paymentSessionId, String orderId) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();
      return session;
    } on CFException catch (e) {
      showErrorToast(context, e.message);
    }
    return null;
  }

  bool containsBlankSpaces(String text) {
    return text.contains(RegExp(r'\s'));
  }
  bool containsSpecialCharacters(String text) {
    return text.contains(RegExp(r'[!@#%^&*()_+{}\[\]:;<>,.?~\\|/=_-]'));
  }
  bool containsDigits(String text) {
    return text.contains(RegExp(r'\d'));
  }

}
