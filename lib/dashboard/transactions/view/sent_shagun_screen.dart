import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/url_constants.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../../utils/app_widgets.dart';
import '../../../utils/routes.dart';
import '../controller/gifts_controller.dart';
import '../model/gifts_data_model.dart';

class SentShagunScreen extends StatefulWidget {
  const SentShagunScreen({Key? key}) : super(key: key);

  @override
  State<SentShagunScreen> createState() => _SentShagunScreenState();
}

class _SentShagunScreenState extends State<SentShagunScreen> {
  late Future<GiftsDataModel>? sentGiftsData;
  GiftsController giftsController = GiftsController();

  List<EventsList> events = [EventsList(id: null, eventTypeName: "All Events")];
  EventsList? dropDownValue;
  PrefModel prefModel = AppPref.getPref();

  @override
  void initState() {
    super.initState();
    sentGiftsData = giftsController.fetchSentGiftsData(context, "%", "1");
  }

  bool isLoaded = false;

  DateTime? selectedDate;

  Future<void> selectMonthYear(BuildContext context) async {
    final DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
    );

    if (pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate!;
      });
      _pullRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder<GiftsDataModel>(
        future: sentGiftsData,
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
            if (isLoaded == false) {
              dropDownValue = events.firstWhere((event) => event.id == null);
              for (int i = 0; i < snapshot.data!.eventsList!.length; i++) {
                events.add(snapshot.data!.eventsList![i]);
              }
              isLoaded = true;
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.scaffoldBackground,
                title: Text(
                  'Shagun sent (₹${snapshot.data!.totalGiftSent})',
                  style: const TextStyle(
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
                      snapshot.data!.sentGifts!.isNotEmpty?
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, Routes.searchTransactionsRoute,arguments: {
                            'type':'sent'
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            enabled: false,
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
                              hintText: 'Search by Name or Phone',
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
                      ):const SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenSize.width / 2.4,
                            height: 30,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: DropdownButton<EventsList>(
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                iconEnabledColor: Colors.white,
                                alignment: Alignment.center,
                                underline: const SizedBox(),
                                dropdownColor: AppColors.primaryColor,
                                value: dropDownValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: events
                                    .map<DropdownMenuItem<EventsList>>((EventsList event) {
                                  return DropdownMenuItem<EventsList>(
                                    value: event,
                                    child: SizedBox(
                                        width:screenSize.width/3.5,
                                        child: Text(event.eventTypeName!,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (EventsList? newValue) {
                                  setState(() {
                                    dropDownValue = newValue!;
                                  });
                                  _pullRefresh();
                                },
                              ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => selectMonthYear(context),
                            child: Container(
                              width: screenSize.width / 2.4,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width:screenSize.width/3.5,
                                  child: Text(
                                    selectedDate!=null?"${selectedDate!.month}-${selectedDate!.year}":"All Time",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      snapshot.data!.sentGifts!.isNotEmpty?
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.sentGifts!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, Routes.trackOrderRoute,arguments: {
                                "orderId":snapshot.data!.sentGifts![index].id
                              });
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
                                                        backgroundImage: i==0?NetworkImage(UrlConstant.imageBaseUrl+prefModel.userData!.user!.profile!):NetworkImage(UrlConstant.imageBaseUrl+snapshot.data!.sentGifts![index].profilePic!),
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
                                                width: screenSize.width/2.5,
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
                                                        text: '${snapshot.data!.sentGifts![index].name}',
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
                                                'On their ${snapshot.data!.sentGifts![index].eventTypeName}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                '₹${snapshot.data!.sentGifts![index].shagunAmount}',
                                                style: const TextStyle(
                                                  color: Color(0xFFBE9535),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                DateFormat("dd MMM yyyy hh:mm aa").format(
                                                    DateTime.parse(snapshot
                                                        .data!
                                                        .sentGifts![index]
                                                        .createdOn
                                                        .toString())),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              snapshot.data!.sentGifts![index].settlementStatus==1?
                                              const Text(
                                                'Settled to recipient bank',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ):const SizedBox.shrink(),
                                              const SizedBox(height: 5,),
                                              GestureDetector(
                                                onTap: (){
                                                  showWishDialog(context,snapshot.data!.sentGifts![index].wish,snapshot.data!.sentGifts![index].onBehalfOf!);
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
                          return const SizedBox(
                            height: 15,
                          );
                        },
                      ):const Center(
                        child: Text("No records found !",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
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
                      onPressed: _pullRefresh, child: const Text("Refresh"))
                ],
              ),
            );
          }
          return const Center(
            child: Text("Loading..."),
          );
        });
  }

  Future<void> _pullRefresh() async {
    String? type;
    if (dropDownValue!.eventTypeName == "All Events") {
      type = "%";
    } else {
      type = dropDownValue!.eventTypeName;
    }
    String formattedMonth = DateFormat('MM').format(selectedDate!);

    setState(() {
      sentGiftsData = giftsController.fetchSentGiftsData(
          context, type!, "${selectedDate!.year}-$formattedMonth");
    });
  }
}
