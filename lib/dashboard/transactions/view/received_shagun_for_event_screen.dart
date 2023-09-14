import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/url_constants.dart';
import '../controller/gifts_controller.dart';
import '../model/received_gifts_data_model.dart';

class ReceivedShagunForEventScreen extends StatefulWidget {
  const ReceivedShagunForEventScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedShagunForEventScreen> createState() =>
      _ReceivedShagunForEventScreenState();
}

class _ReceivedShagunForEventScreenState
    extends State<ReceivedShagunForEventScreen> {
  GiftsController giftsController = GiftsController();
  PrefModel prefModel = AppPref.getPref();

  late Future<ReceivedGiftsDataModel>? receivedGiftsData;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String eventId = arguments['eventId'].toString();
    Size screenSize = MediaQuery.of(context).size;
    receivedGiftsData = giftsController.fetchReceivedGiftsDataForEvent(context,prefModel.userData!.user!.userId,eventId);
    return Scaffold(
      body: FutureBuilder<ReceivedGiftsDataModel>(
          future: receivedGiftsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/loading.json', height: 150),
                    const Text(
                      "Loading...",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.scaffoldBackground,
                  title: const Text(
                    'Shagun received (₹4500)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        snapshot.data!.receivedGifts!.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.receivedGifts!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      width: screenSize.width,
                                      padding: const EdgeInsets.all(20),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                        for (int i = 0;
                                                            i < 2;
                                                            i++)
                                                          Positioned(
                                                            left: i * 40,
                                                            child: ClipOval(
                                                              child: CircleAvatar(
                                                                backgroundImage: i ==
                                                                        0
                                                                    ? NetworkImage(UrlConstant
                                                                            .imageBaseUrl +
                                                                        prefModel
                                                                            .userData!
                                                                            .user!
                                                                            .profile!)
                                                                    : NetworkImage(UrlConstant
                                                                            .imageBaseUrl +
                                                                        prefModel
                                                                            .userData!
                                                                            .user!
                                                                            .profile!),
                                                                backgroundColor: i ==
                                                                        1
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
                                                        width: screenSize.width /
                                                            2.25,
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '${snapshot.data!.receivedGifts![index].name}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    ' sent you shagun',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'On your ${snapshot.data!.receivedGifts![index].eventTypeName}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₹${snapshot.data!.receivedGifts![index].shagunAmount}',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFBE9535),
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                "dd MMM yyyy hh:mm aa")
                                                            .format(DateTime
                                                                .parse(snapshot
                                                                    .data!
                                                                    .receivedGifts![
                                                                        index]
                                                                    .createdOn
                                                                    .toString())),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
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
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 15,
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No records found !",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${snapshot.error}'),
                    ElevatedButton(
                        onPressed: ()=>_pullRefresh(eventId), child: const Text("Refresh"))
                  ],
                ),
              );
            }
            return const Center(
              child: Text("Loading..."),
            );
          }),
    );
  }

  Future<void> _pullRefresh(String eventId) async {
    setState(() {
      receivedGiftsData = giftsController.fetchReceivedGiftsDataForEvent(context,prefModel.userData!.user!.userId,eventId);
    });
  }
}
