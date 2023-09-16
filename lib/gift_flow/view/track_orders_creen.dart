import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:shagun_mobile/gift_flow/controller/orderController.dart';

import '../../utils/app_colors.dart';
import '../trackorderdata_model.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({Key? key}) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  String? orderId;
  late Future<TrackOrderDataModel>? trackData;

  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    orderId = arguments['orderId'].toString();
    // Size screenSize = MediaQuery.of(context).size;
    trackData = orderController.fetchOrderTrackData(context, orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Track order #$orderId"),
      ),
      body: FutureBuilder<TrackOrderDataModel>(
          future: trackData,
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
              if (snapshot.data!.trackTransaction!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: OrderTrackerZen(
                    tracker_data: [
                      for(int i=0;i<snapshot.data!.trackTransaction!.length;i++)
                      TrackerData(
                        title: snapshot.data!.trackTransaction![i].status==1?"Order Created":
                        snapshot.data!.trackTransaction![i].status==2?"Printing Started":
                        snapshot.data!.trackTransaction![i].status==3?"Printing Completed":
                        snapshot.data!.trackTransaction![i].status==4?"Ready to Dispatch":
                        snapshot.data!.trackTransaction![i].status==5?"Dispatched": "Payment Settled",
                        date: DateFormat("dd MMM yyyy").format(
                            DateTime.parse(snapshot
                                .data!
                                .trackTransaction![i]
                                .date
                                .toString())),
                        tracker_details: [
                          TrackerDetails(
                            title: snapshot.data!.trackTransaction![i].status==1?"Your order was created":
                            snapshot.data!.trackTransaction![i].status==2?"Printing started for your order":
                            snapshot.data!.trackTransaction![i].status==3?"Printing completed for your order":
                            snapshot.data!.trackTransaction![i].status==4?"Your order is ready for dispatch":
                            snapshot.data!.trackTransaction![i].status==5?"Your order is dispatched": "Payment settled for your order",
                            datetime: DateFormat("dd MMM yyyy").format(
                                DateTime.parse(snapshot
                                    .data!
                                    .trackTransaction![i]
                                    .date
                                    .toString())),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }else{
                return const Center(
                  child: Text("No records found",style: TextStyle(fontSize: 18),),
                );
              }
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
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {
      trackData = orderController.fetchOrderTrackData(context, orderId);
    });
  }
}
