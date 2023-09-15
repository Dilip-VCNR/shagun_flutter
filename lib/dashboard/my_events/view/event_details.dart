import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/my_events_controller.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';
import 'package:shagun_mobile/utils/url_constants.dart';

import '../../../utils/routes.dart';
import '../model/greetings_and_wishes_model.dart';
import '../model/single_event_model.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  SingleEventDataModel? eventData;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String type = arguments['type'];
    eventData = arguments['eventData'];

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          'Event details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenSize.width,
              decoration: const ShapeDecoration(
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenSize.width,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const ShapeDecoration(
                      color: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        type == 'invited'
                            ? '${eventData!.event!.name} invited you '
                            : '${eventData!.event!.eventType}',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          UrlConstant.imageBaseUrl +
                                              eventData!
                                                  .event!.admins![0].profile!),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: const OvalBorder(
                                      side: BorderSide(
                                          width: 5, color: Color(0xFF9F813C)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${eventData!.event!.admins![0].name}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '(${eventData!.event!.admins![0].role})',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    '${eventData!.event!.eventType}',
                                    style: const TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            eventData!.event!.admins!.length > 1
                                ? Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                UrlConstant.imageBaseUrl +
                                                    eventData!.event!.admins![1]
                                                        .profile!),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: const OvalBorder(
                                            side: BorderSide(
                                                width: 5,
                                                color: Color(0xFF9F813C)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${eventData!.event!.admins![1]
                                                  .name}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '(${eventData!.event!.admins![1].role})',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        Container(
                          height: 150,
                          width: 3,
                          color: AppColors.scaffoldBackground,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            color: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                DateFormat("d\nMMM\nEEEE").format(
                                    DateTime.parse(eventData!.event!.eventDate
                                        .toString())),
                                // '13\nOCT\nFriday',
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: ShapeDecoration(
                                  color: AppColors.scaffoldBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  DateFormat("hh:mm a").format(DateTime.parse(
                                      eventData!.event!.eventDate.toString())),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Event venue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${eventData!.event!.addressLine1}\n${eventData!.event!.addressLine2}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                final String coordinates = eventData!.event!.eventLatLng!;
                List<String> parts = coordinates.split(', ');
                String latitudePart = parts[0].split(': ')[1];
                String longitudePart = parts[1].split(': ')[1];

                double latitude = double.parse(latitudePart);
                double longitude = double.parse(longitudePart);
                MapsLauncher.launchCoordinates(latitude, longitude);
              },
              child: Container(
                width: screenSize.width / 2,
                height: 40,
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: const Center(
                  child: Text(
                    'Navigate on maps',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            for (int i = 0; i < eventData!.event!.subEvents!.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    eventData!.event!.subEvents![i].subEventName!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(eventData!.event!.subEvents![i].startTime!))}\nTo\n${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(eventData!.event!.subEvents![i].endTime!))}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            const SizedBox(
              height: 30,
            ),
            eventData!.status!?
            type != 'own'
                ? GestureDetector(
                    onTap: () async {
                      showLoaderDialog(context);
                      GreetingsAndWishesModel greetingsAndWishes =
                      await MyEventsController().getGreetingsAndWishes(
                          context, eventData!.event!.eventId.toString());
                      if(context.mounted){
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, Routes.selectGreetingCardRoute,
                            arguments: {
                              "gift_to": {
                                "uid": eventData!.event!.uid,
                                "name": eventData!.event!.name,
                                "event_id": eventData!.event!.eventId
                              },
                              "data": greetingsAndWishes,
                              "delivery_fee": eventData!.event!.deliveryFee
                            });
                      }
                    },
                    child: Container(
                        decoration: ShapeDecoration(
                          color: const Color(0xFFEAB948),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        width: screenSize.width,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Send shagun to ${eventData!.event!.name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  )
                : const SizedBox.shrink():const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
