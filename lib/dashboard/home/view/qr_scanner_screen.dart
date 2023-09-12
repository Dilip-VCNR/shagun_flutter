import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shagun_mobile/dashboard/home/controller/home_controllers.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../my_events/model/single_event_model.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  HomeControllers homeController = HomeControllers();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: const Text(
          "Scan to gift",
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                // cutOutSize: scanArea
              ),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  "Scan Shagun's QR Code",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   margin: const EdgeInsets.all(8),
                  //   child: IconButton(
                  //       onPressed: () async {
                  //         setState(() {});
                  //       },
                  //       icon: const Icon(
                  //         Icons.insert_photo_outlined,
                  //         color: Colors.white,
                  //         size: 30,
                  //       )),
                  // ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        icon: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return snapshot.data!
                                ? const Icon(
                                    Icons.flash_on_sharp,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.flash_off_sharp,
                                    color: Colors.white,
                                    size: 30,
                                  );
                          },
                        )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      showLoaderDialog(context);
      String scanDataString = scanData.code.toString();
      List<String> parts = scanDataString.split('/');
      if (parts.isNotEmpty) {
        // Taking the last part of the split
        String lastPart = parts.last;

        // Splitting the last part by "_"
        List<String> subParts = lastPart.split('_');

        if (subParts.length == 2) {
          // Converting the first sub-part to an integer
          int eventId =
              int.tryParse(subParts[0]) ?? 0; // Default to 0 if parsing fails

          // Storing the second sub-part as a string
          String invitedPhone = subParts[1];

          SingleEventDataModel eventData = await homeController
              .getEventDetailsFromHome(context, eventId, invitedPhone);
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.eventDetailsRoute,
                arguments: {'eventData': eventData, 'type': 'searched'});
          }
        }
      }
      controller.resumeCamera();
      return;
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
