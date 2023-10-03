import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/my_events_controller.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../../utils/routes.dart';
import '../../../utils/url_constants.dart';
import '../controller/user_events_model.dart';
import '../model/single_event_model.dart';

class UserEventsScreen extends StatefulWidget {
  const UserEventsScreen({Key? key}) : super(key: key);

  @override
  State<UserEventsScreen> createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  UserEventsDataModel? userEvents;

  MyEventsController eventController = MyEventsController();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    userEvents = arguments['userEvents'];
    String userName = arguments['userName'];
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text(
          "Events by $userName",
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userEvents!.upcomingEvents!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    showLoaderDialog(context);
                    SingleEventDataModel eventData =
                        await eventController.getEventDetails(
                            context, userEvents!.upcomingEvents![index]);
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pushNamed(context, Routes.eventDetailsRoute,
                          arguments: {
                            'eventData': eventData,
                            'type': 'searched'
                          });
                    }
                  },
                  child: Container(
                    width: screenSize.width / 1.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          offset: const Offset(0.0, 0.5), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            // Adjust the width according to your layout
                            height: 50,
                            child: Stack(
                              children: [
                                for (int i = 0;
                                    i <
                                        userEvents!.upcomingEvents![index]
                                            .admins!.length;
                                    i++)
                                  Positioned(
                                    left: i * 20,
                                    // Adjust this offset to control the overlapping distance
                                    child: ClipOval(
                                      child: CircleAvatar(
                                        // backgroundColor:
                                        //     AppColors.secondaryColor,
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            UrlConstant.imageBaseUrl +
                                                userEvents!
                                                    .upcomingEvents![index]
                                                    .admins![i]
                                                    .profile!),
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
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userEvents!.upcomingEvents![index].eventName!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                DateFormat("dd MMM yyyy hh:mm aa").format(DateTime.parse(
                                    userEvents!
                                        .upcomingEvents![index].eventDate!
                                        .toString())),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 15,);
          },)),
    );
  }
}
