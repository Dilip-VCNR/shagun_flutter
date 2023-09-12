import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shagun_mobile/dashboard/home/controller/home_controllers.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/my_events_controller.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_widgets.dart';
import '../../../utils/routes.dart';
import '../model/events_screen_model.dart';
import '../model/single_event_model.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({Key? key}) : super(key: key);

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  MyEventsController myEventsController = MyEventsController();
  late Future<EventsScreenModel>? eventsData;

  HomeControllers homeControllers = HomeControllers();
  @override
  void initState() {
    super.initState();
    eventsData = myEventsController.fetchEventsData(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Events',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create event",
                    style: TextStyle(
                        fontSize: 16, color: AppColors.scaffoldBackground),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.add,
                    color: AppColors.scaffoldBackground,
                  ),
                ],
              ))
        ],
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: pullRefresh,
        child: FutureBuilder<EventsScreenModel>(
            future: eventsData,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Invitations',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.allInvitationsRoute);
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'View All',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.navigate_next)
                                    ],
                                  ),
                                )
                              ]),
                          Text(
                            '${snapshot.data!.invitedEvents!.length} People invited you for events',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
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
                                          .invitedEvents![index]
                                          .eventId!,
                                      snapshot
                                          .data!
                                          .invitedEvents![index]
                                          .invitedBy!);
                                  if(context.mounted){
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, Routes.eventDetailsRoute,
                                        arguments: {
                                          'type': 'invited',
                                          'eventData': eventData
                                        });
                                  }
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: screenSize.width / 5,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Text(
                                          DateFormat("d \nMMM").format(
                                              DateTime.parse(snapshot
                                                  .data!
                                                  .invitedEvents![index]
                                                  .eventDate
                                                  .toString())),                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "https://via.placeholder.com/40x40"),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            screenSize.width /
                                                                2.5,
                                                        child: Text(
                                                          'Bharath invited you to his ${snapshot.data!.invitedEvents![index].eventName}',
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenSize.width /
                                                                2.5,
                                                        child: const Text(
                                                          'Send your greetings with shagun',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 15,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'My Events',
                            style: TextStyle(
                              color: Colors.black,
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
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.eventDetailsRoute,
                                      arguments: {'type': 'own'});
                                },
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
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
                                              Container(
                                                width: 100,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                child: const Center(
                                                  child: Text(
                                                    "View Gifts",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: 100,
                                                decoration: ShapeDecoration(
                                                  color: AppColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7),
                                                child: const Center(
                                                  child: Text(
                                                    "Show QR",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .scaffoldBackground,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Wedding',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const Text(
                                                'Bharath and Priya',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const Row(
                                                children: [
                                                  Text(
                                                    '₹1100',
                                                    style: TextStyle(
                                                      color: Color(0xFFBE9535),
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Shagun received',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: screenSize.width / 2,
                                                child: const Text(
                                                  '160 people have sent you shagun',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const Row(
                                                children: [
                                                  Text(
                                                    'Event on : ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '09 - October - 2023',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: screenSize.width / 2,
                                                child: const Text(
                                                  'Active',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
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
                        ]));
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${snapshot.error}'),
                      ElevatedButton(
                          onPressed: pullRefresh, child: const Text("Refresh"))
                    ],
                  ),
                );
              }
              return const Center(
                child: Text("Loading..."),
              );
            }),
      )),
    );
  }

  Future<void> pullRefresh() async {
    setState(() {
      eventsData = myEventsController.fetchEventsData(context);
    });
  }
}
