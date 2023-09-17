import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shagun_mobile/dashboard/home/controller/home_controllers.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/my_events_controller.dart';
import 'package:shagun_mobile/utils/url_constants.dart';
import 'package:share/share.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
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
  PrefModel prefModel = AppPref.getPref();

  var eventTypes;

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
          GestureDetector(
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  int selectedRadio = 0;
                  return AlertDialog(
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(eventTypes.length,
                              (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRadio = index;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: selectedRadio,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRadio = value!;
                                      });
                                    },
                                  ),
                                  Text(eventTypes[index].eventTypeName!)
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Cancel button action here (discard changes)
                          Navigator.pop(
                              context); // Close the dialog without saving
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Submit button action here (save the selected event type)
                          showLoaderDialog(context);
                          await myEventsController.requestEvent(
                              eventTypes[selectedRadio].eventTypeName, context);
                          if (context.mounted) {
                            Navigator.pop(
                                context); // Close the dialog after submitting
                            Navigator.pop(
                                context); // Close the dialog after submitting
                            showSuccessToast(
                              context,
                              "Request for event is successfull\nOur Back office will contact you soon !",
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                )),
          )
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
                eventTypes = snapshot.data!.eventTypeList;
                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data!.invitedEvents!.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          Navigator.pushNamed(context,
                                              Routes.allInvitationsRoute);
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
                                    ])
                              : const SizedBox.shrink(),
                          snapshot.data!.invitedEvents!.isNotEmpty
                              ? Text(
                                  '${snapshot.data!.invitedEvents!.length} People invited you for events',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          snapshot.data!.invitedEvents!.isNotEmpty
                              ? const SizedBox(
                                  height: 20,
                                )
                              : const SizedBox.shrink(),
                          snapshot.data!.invitedEvents!.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      snapshot.data!.invitedEvents!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                        if (context.mounted) {
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: screenSize.width / 5,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              child: Text(
                                                DateFormat("d \nMMM").format(
                                                    DateTime.parse(snapshot
                                                        .data!
                                                        .invitedEvents![index]
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: ShapeDecoration(
                                                  color: AppColors.cardBgColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              ShapeDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  "${UrlConstant.imageBaseUrl}${snapshot.data!.invitedEvents![index].invitedByProfilePic}"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            shape:
                                                                const OvalBorder(),
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
                                                              width: screenSize
                                                                      .width /
                                                                  2.5,
                                                              child: Text(
                                                                '${snapshot.data!.invitedEvents![index].invitedByName} invited you to his ${snapshot.data!.invitedEvents![index].eventName}',
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
                                                            ),
                                                            SizedBox(
                                                              width: screenSize
                                                                      .width /
                                                                  2.5,
                                                              child: const Text(
                                                                'Send your greetings with shagun',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const Icon(
                                                        Icons.navigate_next)
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
                                )
                              : const SizedBox.shrink(),
                          snapshot.data!.invitedEvents!.isNotEmpty
                              ? const SizedBox(
                                  height: 20,
                                )
                              : const SizedBox.shrink(),
                          snapshot.data!.myEvents!.isNotEmpty
                              ? const Text(
                                  'My Events',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          ),
                          snapshot.data!.myEvents!.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.myEvents!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        showLoaderDialog(context);
                                        SingleEventDataModel eventData =
                                            await homeControllers
                                                .getEventDetailsFromHome(
                                                    context,
                                                    snapshot
                                                        .data!
                                                        .myEvents![index]
                                                        .eventId!,
                                                    prefModel.userData!.user!
                                                        .userId!);
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, Routes.eventDetailsRoute,
                                              arguments: {
                                                'type': 'own',
                                                'eventData': eventData
                                              });
                                        }
                                      },
                                      child: Container(
                                        width: screenSize.width,
                                        padding: const EdgeInsets.all(20),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: snapshot
                                                                    .data!
                                                                    .myEvents![
                                                                        index]
                                                                    .admins!
                                                                    .length >
                                                                1
                                                            ? 100
                                                            : 60,
                                                        height: 70,
                                                        child: Stack(
                                                          children: [
                                                            for (int i = 0;
                                                                i <
                                                                    snapshot
                                                                        .data!
                                                                        .myEvents![
                                                                            index]
                                                                        .admins!
                                                                        .length;
                                                                i++)
                                                              Positioned(
                                                                left: i * 40,
                                                                child: ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundImage: NetworkImage(UrlConstant
                                                                            .imageBaseUrl +
                                                                        snapshot
                                                                            .data!
                                                                            .myEvents![index]
                                                                            .admins![i]
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
                                                        )),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(context, Routes.giftsForEventRoute,arguments: {
                                                          "eventId":snapshot.data!.myEvents![index].eventId
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: AppColors
                                                              .secondaryColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 7),
                                                        child: const Center(
                                                          child: Text(
                                                            "View Gifts",
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    snapshot.data!.myEvents![index].status==1?
                                                    GestureDetector(
                                                      onTap: () {
                                                        showLoaderDialog(
                                                            context);
                                                        for (int i = 0;
                                                            i <
                                                                snapshot
                                                                    .data!
                                                                    .myEvents![
                                                                        index]
                                                                    .admins!
                                                                    .length;
                                                            i++) {
                                                          if (snapshot
                                                                  .data!
                                                                  .myEvents![
                                                                      index]
                                                                  .admins![i]
                                                                  .uid ==
                                                              prefModel
                                                                  .userData!
                                                                  .user!
                                                                  .userId) {
                                                            String imageurl = UrlConstant
                                                                    .imageBaseUrl +
                                                                snapshot
                                                                    .data!
                                                                    .myEvents![
                                                                        index]
                                                                    .admins![i]
                                                                    .qrCode!;
                                                            downloadAndShareImage(
                                                                imageurl,
                                                                snapshot
                                                                    .data!
                                                                    .myEvents![
                                                                        index]
                                                                    .eventName!,snapshot
                                                                .data!
                                                                .myEvents![
                                                            index]
                                                                .eventId!,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: AppColors
                                                              .primaryColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 7),
                                                        child: const Center(
                                                          child: Text(
                                                            "Share",
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .scaffoldBackground,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ):const SizedBox.shrink()
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
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .myEvents![index]
                                                          .eventName!,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    snapshot.data!.myEvents![index].admins!.length==1?
                                                    Text(
                                                      '${snapshot.data!.myEvents![index].admins![0].name}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ):
                                                    Text(
                                                      '${snapshot.data!.myEvents![index].admins![0].name} and ${snapshot.data!.myEvents![index].admins![1].name}',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width/2,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            '₹${snapshot.data!.myEvents![index].totalRecievedAmount}',
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFFBE9535),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                            'Received',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenSize.width / 2,
                                                      child: Text(
                                                        '${snapshot.data!.myEvents![index].totalSendersCount} people have sent you shagun',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Event on : ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  "dd MMM yyyy")
                                                              .format(DateTime
                                                                  .parse(snapshot
                                                                      .data!
                                                                      .myEvents![
                                                                          index]
                                                                      .eventDate
                                                                      .toString())),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenSize.width / 2,
                                                      child: Text(
                                                        snapshot
                                                                    .data!
                                                                    .myEvents![
                                                                        index]
                                                                    .status ==
                                                                1
                                                            ? 'Active'
                                                            : "Closed",
                                                        style: TextStyle(
                                                          color: snapshot
                                                              .data!
                                                              .myEvents![
                                                          index]
                                                              .status ==
                                                              1?Colors.green: Colors.red,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                              : const Center(
                                  child: Text(
                                    "You have not created any events yet !\nYou can create on by clicking on Create event (+) icon at the top.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
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

  Future<void> downloadAndShareImage(String imageUrl, String eventName, int eventId) async {
    try {
      // Download the image using http package
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;

      // Get the app's cache directory to save the image
      final appDir = await getTemporaryDirectory();
      final imagePath = '${appDir.path}/share_image.png';

      // Save the image to the cache directory
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(bytes);

      // Share the saved image using the share package
      if (context.mounted) {
        Navigator.pop(context);
      }
      await Share.shareFiles([imagePath], text: "$eventName\n${UrlConstant.deeplinkBaseUrl}?eventId=$eventId&invitedBy=${prefModel.userData!.user!.phone}",subject: "You are invited to $eventName");
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context,'Error downloading and sharing image: $e');
      }
    }
  }
}
