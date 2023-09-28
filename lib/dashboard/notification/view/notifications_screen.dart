import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shagun_mobile/dashboard/notification/controller/notification_controller.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import '../model/notification_data_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<NotificationDataModel>? notificationData;

  NotificationController notificationController = NotificationController();

  @override
  void initState() {
    super.initState();
    notificationData = notificationController.fetchNotificationsData(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          title: const Text("Notifications"),
        ),
        body: FutureBuilder<NotificationDataModel>(
            future: notificationData,
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
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: snapshot.data!.notificationList!.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.notificationList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: screenSize.width,
                              padding: const EdgeInsets.all(20),
                              decoration: ShapeDecoration(
                                color: AppColors.cardBgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.39),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      // CircleAvatar(
                                      // radius: 30,
                                      //   backgroundColor: AppColors.secondaryColor,
                                      // ),
                                      // SizedBox(
                                      //   width: 20,
                                      // ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenSize.width / 1.5,
                                            child: Text(
                                              snapshot
                                                  .data!
                                                  .notificationList![index]
                                                  .title!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: screenSize.width/1.25,
                                            child: Text(
                                              snapshot
                                                  .data!
                                                  .notificationList![index]
                                                  .message!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            DateFormat("dd MMM yyyy")
                                                .format(DateTime.parse(
                                              snapshot
                                                  .data!
                                                  .notificationList![index]
                                                  .createdOn!
                                                  .toString(),
                                            )),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          })
                      : const Center(
                          child: Text(
                            "No records found",
                            style: TextStyle(fontSize: 18),
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
                          onPressed: _pullRefresh, child: const Text("Refresh"))
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Loading..."),
              );
            }));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      notificationData = notificationController.fetchNotificationsData(context);
    });
  }
}
