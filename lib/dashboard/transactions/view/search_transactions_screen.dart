import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shagun_mobile/dashboard/transactions/controller/gifts_controller.dart';
import 'package:shagun_mobile/dashboard/transactions/model/received_gifts_data_model.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_widgets.dart';
import '../../../utils/routes.dart';
import '../../../utils/url_constants.dart';
import '../model/gifts_data_model.dart';

class SearchTransactionsScreen extends StatefulWidget {
  const SearchTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<SearchTransactionsScreen> createState() =>
      _SearchTransactionsScreenState();
}

class _SearchTransactionsScreenState extends State<SearchTransactionsScreen> {
  GiftsController giftsController = GiftsController();
  GiftsDataModel? searchSentGiftsData;
  ReceivedGiftsDataModel? searchReceivedGiftsData;
  bool isLoading = false; // Added isLoading flag to track the loading state.
  PrefModel prefModel = AppPref.getPref();


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
      appBar: AppBar(title: const Text("Search by Name or Phone"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                onChanged: (query) async {
                  if (type == "sent") {
                    setState(() {
                      isLoading = true; // Show loading indicator.
                      searchSentGiftsData = null; // Clear previous search data.
                    });
                    searchSentGiftsData =
                    await giftsController.searchSentGifts(query, context);
                    setState(() {
                      isLoading = false; // Hide loading indicator.
                    });
                  }
                  if (type == "received") {
                    setState(() {
                      isLoading = true; // Show loading indicator.
                      searchReceivedGiftsData =
                      null; // Clear previous search data.
                    });
                    if(context.mounted){
                      searchReceivedGiftsData =
                      await giftsController.searchReceivedGifts(query, context);
                    }
                    setState(() {
                      isLoading = false; // Hide loading indicator.
                    });
                  }
                },
                autofocus: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle:
                  const TextStyle(color: AppColors.secondaryColor),
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: 'Search name or phone',
                  counterText: "",
                  isCollapsed: true,
                  filled: true,
                  fillColor: AppColors.inputFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            if (isLoading)
              const CircularProgressIndicator() // Show loading indicator while data is being fetched.
            else
              if (type == 'sent' && searchSentGiftsData != null)
                searchSentGiftsData!.sentGifts!.isNotEmpty ?
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchSentGiftsData!.sentGifts!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, Routes.trackOrderRoute, arguments: {
                          "orderId": searchSentGiftsData!.sentGifts![index].id
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: screenSize.width,
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 70,
                                      child: Stack(
                                        children: [
                                          for (int i = 0; i < 2; i++)
                                            Positioned(
                                              left: i * 40,
                                              child: ClipOval(
                                                child: CircleAvatar(
                                                  backgroundImage: i == 0
                                                      ? NetworkImage(
                                                      UrlConstant
                                                          .imageBaseUrl +
                                                          prefModel.userData!
                                                              .user!.profile!)
                                                      : NetworkImage(
                                                      UrlConstant
                                                          .imageBaseUrl +
                                                          searchSentGiftsData!
                                                              .sentGifts![index]
                                                              .profilePic!),
                                                  backgroundColor: i == 1
                                                      ? AppColors
                                                      .secondaryColor
                                                      : AppColors
                                                      .primaryColor,
                                                  radius: 30,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: screenSize.width / 2.25,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Sent shagun to ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${searchSentGiftsData!
                                                      .sentGifts![index]
                                                      .name}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'On his ${searchSentGiftsData!
                                              .sentGifts![index]
                                              .eventTypeName}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '₹${searchSentGiftsData!
                                              .sentGifts![index]
                                              .shagunAmount}',
                                          style: const TextStyle(
                                            color: Color(0xFFBE9535),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          DateFormat("dd MMM yyyy hh:mm aa")
                                              .format(
                                              DateTime.parse(
                                                  searchSentGiftsData!
                                                      .sentGifts![index]
                                                      .createdOn
                                                      .toString())),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        searchSentGiftsData!.sentGifts![index]
                                            .settlementStatus == 1 ?
                                        const Text(
                                          'Settled to recipient bank',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ) : const SizedBox.shrink(),
                                        const SizedBox(height: 5,),
                                        GestureDetector(
                                          onTap: (){
                                            showWishDialog(context,searchSentGiftsData!.sentGifts![index].wish,searchSentGiftsData!.sentGifts![index].onBehalfOf!);
                                          },
                                          child: Container(
                                            decoration:
                                            ShapeDecoration(
                                              color: AppColors
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      7)),
                                            ),
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                vertical:
                                                7,horizontal: 15),
                                            child:
                                            const Center(
                                              child: Text(
                                                "View Wish",
                                                style:
                                                TextStyle(
                                                  color: AppColors
                                                      .scaffoldBackground,
                                                  fontSize:
                                                  13,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Icon(Icons.navigate_next)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },):const Center(child: Text("No records found"),)

              else
                if ( type == 'received' && searchReceivedGiftsData != null)
                  searchReceivedGiftsData!.receivedGifts!.isNotEmpty?
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchReceivedGiftsData!.receivedGifts!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: screenSize.width,
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 70,
                                        child: Stack(
                                          children: [
                                            for (int i = 0; i < 2; i++)
                                              Positioned(
                                                left: i * 40,
                                                child: ClipOval(
                                                  child: CircleAvatar(
                                                    backgroundImage: i == 0
                                                        ? NetworkImage(
                                                        UrlConstant
                                                            .imageBaseUrl +
                                                            prefModel.userData!
                                                                .user!.profile!)
                                                        : NetworkImage(
                                                        UrlConstant
                                                            .imageBaseUrl +
                                                            searchReceivedGiftsData!
                                                                .receivedGifts![index]
                                                                .profilePic!),
                                                    backgroundColor: i == 1
                                                        ? AppColors
                                                        .secondaryColor
                                                        : AppColors
                                                        .primaryColor,
                                                    radius: 30,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenSize.width / 2.25,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${searchReceivedGiftsData!
                                                        .receivedGifts![index]
                                                        .name}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ' sent you shagun',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'On your ${searchReceivedGiftsData!
                                                .receivedGifts![index]
                                                .eventTypeName}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '₹${searchReceivedGiftsData!
                                                .receivedGifts![index]
                                                .shagunAmount}',
                                            style: const TextStyle(
                                              color: Color(0xFFBE9535),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("dd MMM yyyy hh:mm aa")
                                                .format(
                                                DateTime.parse(
                                                    searchReceivedGiftsData!
                                                        .receivedGifts![index]
                                                        .createdOn
                                                        .toString())),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          searchReceivedGiftsData!
                                              .receivedGifts![index]
                                              .settlementStatus == 1 ?
                                          const Text(
                                            'Settled to bank',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ) : const SizedBox.shrink(),
                                          const SizedBox(height: 5,),
                                          GestureDetector(
                                            onTap: (){
                                              showWishDialog(context,searchReceivedGiftsData!.receivedGifts![index].wish,searchReceivedGiftsData!.receivedGifts![index].onBehalfOf!);
                                            },
                                            child: Container(
                                              decoration:
                                              ShapeDecoration(
                                                color: AppColors
                                                    .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        7)),
                                              ),
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  vertical:
                                                  7,horizontal: 15),
                                              child:
                                              const Center(
                                                child: Text(
                                                  "View Wish",
                                                  style:
                                                  TextStyle(
                                                    color: AppColors
                                                        .scaffoldBackground,
                                                    fontSize:
                                                    13,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  ):const Center(child: Text("No records found"),)
          ],
        ),
      ),
    );
  }
}
