import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';
import 'package:shagun_mobile/utils/routes.dart';
import 'package:shagun_mobile/utils/url_constants.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../my_events/model/single_event_model.dart';
import '../controller/home_controllers.dart';
import '../model/home_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrefModel prefModel = AppPref.getPref();
  HomeControllers homeControllers = HomeControllers();
  late Future<HomeDataModel>? homeData;

  @override
  void initState() {
    homeData = homeControllers.fetchHomeData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<HomeDataModel>(
            future: homeData,
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
                return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${UrlConstant.imageBaseUrl}${prefModel.userData!.user!.profile}"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: const OvalBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome back !',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '${prefModel.userData!.user!.name}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.notificationsRoute);
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 20,
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //body
                        Container(
                          width: screenSize.width,
                          decoration: ShapeDecoration(
                            color: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.qr_code_scanner,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                      const Text(
                                        'Scan to pay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, Routes.profileSearchRoute);
                                      },
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(
                                              color: AppColors.secondaryColor),
                                          suffixIcon: const Icon(Icons.search),
                                          hintText: 'Search name or phone',
                                          counterText: "",
                                          isCollapsed: true,
                                          filled: true,
                                          fillColor: AppColors.inputFieldColor,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Shagun Received',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '₹${snapshot.data!.totalRecievedAmount}',
                                        style: const TextStyle(
                                          color: Color(0xFFEAB948),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Shagun Sent',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '₹${snapshot.data!.totalSentAmount}',
                                        style: const TextStyle(
                                          color: Color(0xFFEAB948),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data!.kycStatus != 1
                              ? 'Need to create your event and \nstart receiving shagun?'
                              : 'KYC Completed',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: snapshot.data!.kycStatus != 1
                                    ? 'We noticed you have not initiated your KYC process,\nto create your event and start receiving shagun please\n'
                                    : "Congratulations! Your KYC is successfully completed, Now you can start sending and receiving gifts!\nIf need to update anything? ",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const TextSpan(
                                text: '“Request for callback”',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' so our backoffice will contact you\nand guide.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenSize.width / 2,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: AppColors.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                          ),
                          child: const Center(
                            child: Text(
                              'Request callback',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        snapshot.data!.eventsInviteList!.isNotEmpty?
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
                            ]):const SizedBox.shrink(),
                        snapshot.data!.eventsInviteList!.isNotEmpty?
                        Text(
                          '${snapshot.data!.eventsInviteList!.length} People invited you for events',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ):const SizedBox.shrink(),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.eventsInviteList!.length,
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
                                                .eventsInviteList![index]
                                                .eventId!,
                                            snapshot
                                                .data!
                                                .eventsInviteList![index]
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenSize.width / 5,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Text(
                                        DateFormat("d \nMMM").format(
                                            DateTime.parse(snapshot
                                                .data!
                                                .eventsInviteList![index]
                                                .eventDate
                                                .toString())),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
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
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: screenSize.width /
                                                          2.5,
                                                      child: Text(
                                                        'Bharath invited you to his ${snapshot.data!.eventsInviteList![index].eventName}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenSize.width /
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
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
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
            }),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      homeData = homeControllers.fetchHomeData(context);
    });
  }
}
