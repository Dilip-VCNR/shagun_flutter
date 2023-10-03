import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shagun_mobile/dashboard/home/controller/home_controllers.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/my_events_controller.dart';
import 'package:shagun_mobile/dashboard/my_events/model/all_invites_data_model.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/url_constants.dart';

import '../../../utils/app_widgets.dart';
import '../../../utils/routes.dart';
import '../model/single_event_model.dart';

class AllInvitations extends StatefulWidget {
  const AllInvitations({Key? key}) : super(key: key);

  @override
  State<AllInvitations> createState() => _AllInvitationsState();
}

class _AllInvitationsState extends State<AllInvitations> {
  MyEventsController myEventsController = MyEventsController();

  HomeControllers homeControllers = HomeControllers();
  late Future<AllInvitesDataModel>? invitedEventsData;

  @override
  void initState() {
    super.initState();
    invitedEventsData = myEventsController.fetchAllInvitedEventsData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text("Invited Events"),
      ),
      body: FutureBuilder<AllInvitesDataModel>(
        future: invitedEventsData,
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
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.separated(
                itemCount: snapshot.data!.invitedList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      showLoaderDialog(context);
                      SingleEventDataModel eventData =
                      await homeControllers
                          .getEventDetailsFromHome(
                          context,
                          snapshot
                              .data!
                              .invitedList![index]
                              .eventId!,
                          snapshot
                              .data!
                              .invitedList![index]
                              .invitedBy!);
                      if(context.mounted){
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushNamed(
                            context, Routes.eventDetailsRoute,
                            arguments: {
                              'type': 'invited',
                              'eventData': eventData
                            });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenSize.width / 5,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Text(
                              DateFormat("d \nMMM").format(
                                  DateTime.parse(snapshot
                                      .data!
                                      .invitedList![index]
                                      .eventDate
                                      .toString())),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: AppColors.cardBgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "${UrlConstant.imageBaseUrl}${snapshot.data!.invitedList![index].invitedByProfilePic}",
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: screenSize.width / 2.5,
                                            child: Text(
                                              '${snapshot.data!.invitedList![index].invitedByName} invited you to his ${snapshot.data!.invitedList![index].eventName}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenSize.width / 2.5,
                                            child: const Text(
                                              'Send your greetings with shagun',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          )
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
                    onPressed: _pullRefresh,
                    child: const Text("Refresh"),
                  )
                ],
              ),
            );
          }
          return const Center(
            child: Text("Loading..."),
          );
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      invitedEventsData = myEventsController.fetchAllInvitedEventsData();
    });
  }
}
