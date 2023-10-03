import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shagun_mobile/dashboard/notification/model/notification_data_model.dart';
import 'package:shagun_mobile/gift_flow/trackorderdata_model.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../auth/model/ip_location_model.dart';
import '../auth/model/user_details_model.dart';
import '../dashboard/home/model/home_data_model.dart';
import '../dashboard/home/model/search_data_model.dart';
import '../dashboard/my_events/controller/user_events_model.dart';
import '../dashboard/my_events/model/all_invites_data_model.dart';
import '../dashboard/my_events/model/events_screen_model.dart';
import '../dashboard/my_events/model/greetings_and_wishes_model.dart';
import '../dashboard/my_events/model/single_event_model.dart';
import '../dashboard/profile/model/profile_data_model.dart';
import '../dashboard/transactions/model/gifts_data_model.dart';
import '../dashboard/transactions/model/received_gifts_data_model.dart';
import '../database/app_pref.dart';
import '../database/models/pref_model.dart';
import '../splash/model/compatibility_check_model.dart';
import '../utils/url_constants.dart';

class ApiCalls {
  String platform = Platform.isIOS ? "IOS" : "Android";

  PrefModel prefModel = AppPref.getPref();

  Future<http.Response> hitApi(
      bool requiresAuth, String url, String body) async {
    return await http.post(
      Uri.parse(url),
      headers: getHeaders(requiresAuth),
      body: body,
    );
  }

  Future<void> getRefreshToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    var response = await hitApi(
      false,
      UrlConstant.userDetails,
      jsonEncode({
        'uid': prefModel.userData!.user!.userId!,
        'fcm_token': fcmToken,
      }),
    );
    UserDetailsModel user =
        UserDetailsModel.fromJson(json.decode(response.body));
    prefModel.userData = user;
    await AppPref.setPref(prefModel);
  }

  Map<String, String> getHeaders(bool isAuthEnabled) {
    var headers = <String, String>{};
    if (isAuthEnabled) {
      headers.addAll({
        "Authorization": "Bearer ${prefModel.userData!.token}",
        "Content-Type": "application/json"
      });
    } else {
      headers.addAll({"Content-Type": "application/json"});
    }
    return headers;
  }

  Future<Map<String, dynamic>> getUserDetails(
      String uid, String fcmToken) async {
    return hitApi(
      false,
      UrlConstant.userDetails,
      jsonEncode({
        'uid': uid,
        'fcm_token': fcmToken,
      }),
    ).then((response) {
      return {
        "statusCode": response.statusCode,
        "data": UserDetailsModel.fromJson(json.decode(response.body)),
      };
    });
  }

  Future<HomeDataModel>? getHomeData(BuildContext context) async {
    return hitApi(
      true,
      UrlConstant.userHomePage,
      jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return HomeDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.userHomePage,
            jsonEncode(
                <String, String>{'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return HomeDataModel.fromJson(json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load Home Data');
      }
    });
  }

  Future<SearchDataModel>? getSearchProfiles(
      String query, BuildContext context) {
    return hitApi(
      true,
      UrlConstant.searchApi,
      jsonEncode({'search': query, 'uid': prefModel.userData!.user!.userId}),
    ).then((response) {
      if (response.statusCode == 200) {
        return SearchDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.searchApi,
            jsonEncode({
              'search': query,
              'uid': prefModel.userData!.user!.userId,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return SearchDataModel.fromJson(json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to search');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to search');
      }
    });
  }

  Future<AllInvitesDataModel>? getAllInvitedEvents() {
    return hitApi(
      true,
      UrlConstant.getAllInvitedEvents,
      jsonEncode({'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return AllInvitesDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getGreetingCards,
            jsonEncode({'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return AllInvitesDataModel.fromJson(json.decode(reResponse.body));
            } else {
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        throw Exception('Failed to fetch');
      }
    });
  }

  getSingleEventDataFromHome(
      BuildContext context, int eventId, String invitedByPhone) {
    return hitApi(
      true,
      UrlConstant.getSingleEventDetails,
      jsonEncode({
        'event_id': eventId,
        'uid': prefModel.userData!.user!.userId!,
        'phone': invitedByPhone
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return SingleEventDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getSingleEventDetails,
            jsonEncode({
              'event_id': eventId,
              'uid': prefModel.userData!.user!.userId!,
              'phone': invitedByPhone
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return SingleEventDataModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  Future<EventsScreenModel>? getEventsData(BuildContext context) {
    return hitApi(
      true,
      UrlConstant.getMyEventList,
      jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return EventsScreenModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getMyEventList,
            jsonEncode(
                <String, String>{'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return EventsScreenModel.fromJson(json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load events Data');
      }
    });
  }

  Future<GiftsDataModel>? getGiftsSentData(
      BuildContext context, String type, String month) async {
    return hitApi(
      true,
      UrlConstant.giftSentList,
      jsonEncode(<String, String>{
        'uid': prefModel.userData!.user!.userId!,
        'type': type,
        "month": month
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return GiftsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.giftSentList,
            jsonEncode(
                <String, String>{'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return GiftsDataModel.fromJson(json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load Gift sent Data');
      }
    });
  }

  Future<ReceivedGiftsDataModel>? getGiftsReceivedData(
      BuildContext context, String type, String month) async {
    return hitApi(
      true,
      UrlConstant.giftReceivedList,
      jsonEncode(<String, String>{
        'uid': prefModel.userData!.user!.userId!,
        'type': type,
        "month": month
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return ReceivedGiftsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.giftReceivedList,
            jsonEncode(
                <String, String>{'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return ReceivedGiftsDataModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load Gift Received Data');
      }
    });
  }

  Future<ProfileDataModel>? getProfileData(BuildContext context) {
    return hitApi(
      true,
      UrlConstant.getUserProfile,
      jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return ProfileDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getUserProfile,
            jsonEncode(
                <String, String>{'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return ProfileDataModel.fromJson(json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load Profile Data');
      }
    });
  }

  Future<Map<String, dynamic>> registerUser(
    String uid,
    String fcmToken,
    String name,
    String phone,
    String email,
    String authType,
    File? selectedImage,
    BuildContext context,
  ) async {
    var ipResponse = await http.get(
      Uri.parse(UrlConstant.ipLocation),
      headers: getHeaders(false),
    );
    String city =
        IpLocationModel.fromJson(json.decode(ipResponse.body)).location!.city!;

    var request =
        http.MultipartRequest('POST', Uri.parse(UrlConstant.registerUser));

    // Add form fields
    request.fields['uid'] = uid;
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['auth_type'] = authType;
    request.fields['role'] = '3';
    request.fields['city'] = city;
    request.fields['fcm_token'] = fcmToken;

    // Add file
    if (selectedImage != null) {
      var picStream = http.ByteStream(selectedImage.openRead());
      var length = await selectedImage.length();
      var multipartFile = http.MultipartFile(
        'profile_pic',
        picStream,
        length,
        filename: selectedImage.path.split('/').last,
        contentType:
            MediaType('image', 'jpeg'), // Adjust the content type accordingly
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseJson = json.decode(utf8.decode(responseData));
      return {
        "statusCode": response.statusCode,
        "data": UserDetailsModel.fromJson(responseJson),
      };
    }else if(response.statusCode==301){
      Navigator.of(context, rootNavigator: true).pop();
      showErrorToast(context, "Looks like account already exist with given details");
      throw Exception('Failed to upload image');
    } else {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorToast(context, "Something went wrong");
      }
      throw Exception('Failed to upload image');
    }
  }

  Future<UserEventsDataModel>? getUserEventsData(
      BuildContext context, String? searchUid) {
    return hitApi(
      true,
      UrlConstant.getUserEvents,
      jsonEncode(
          {'search_uid': searchUid, 'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return UserEventsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getUserEvents,
            jsonEncode({
              'search_uid': searchUid,
              'uid': prefModel.userData!.user!.userId!,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return UserEventsDataModel.fromJson(json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  Future<SingleEventDataModel> getSingleEventData(
      BuildContext context, UpcomingEvent upcomingEvent) {
    return hitApi(
      true,
      UrlConstant.getSingleEventDetails,
      jsonEncode({
        'event_id': upcomingEvent.eventId,
        'uid': prefModel.userData!.user!.userId!,
        'phone': upcomingEvent.phone
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return SingleEventDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getSingleEventDetails,
            jsonEncode({
              'event_id': upcomingEvent.eventId,
              'uid': prefModel.userData!.user!.userId!,
              'phone': upcomingEvent.phone
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return SingleEventDataModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  Future<CompatibilityCheckModel> checkCompatibilityApi(
    PackageInfo packageInfo,
    BuildContext context,
  ) async {
    return hitApi(
      false,
      UrlConstant.compatibility,
      jsonEncode({
        'app_name': packageInfo.appName,
        'platform': platform,
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return CompatibilityCheckModel.fromJson(json.decode(response.body));
      } else {
        if (context.mounted) {
          showErrorToast(
            context,
            "Something went wrong! Please try again later",
          );
        }
        throw Exception('COMPATIBILITY API FAILED LOADING');
      }
    });
  }

  requestKycCallBack(String s, BuildContext context) {
    return hitApi(
      true,
      UrlConstant.requestCallBack,
      jsonEncode({
        'uid': prefModel.userData!.user!.userId!,
        'type': 'KYC',
        'event_date': null,
        'event_type': null,
        'city': null
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.requestCallBack,
            jsonEncode({
              'uid': prefModel.userData!.user!.userId!,
              'type': 'KYC',
              'event_date': 'null',
              'event_type': 'null',
              'city': 'null'
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return response.body;
            } else {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                showErrorToast(context, "Failed to Request for KYC");
              }
              throw Exception('Failed to Request for KYC');
            }
          });
        });
      } else {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to Request for KYC');
      }
    });
  }

  requestEventCallBack(BuildContext context, String? eventTypeName) {
    return hitApi(
      true,
      UrlConstant.requestCallBack,
      jsonEncode({
        'uid': prefModel.userData!.user!.userId!,
        'type': 'EVENT',
        'event_type': eventTypeName,
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.requestCallBack,
            jsonEncode({
              'uid': prefModel.userData!.user!.userId!,
              'type': 'EVENT',
              'event_type': eventTypeName,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return response.body;
            } else {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                showErrorToast(context, "Failed to Request for Event");
              }
              throw Exception('Failed to Request for KYC');
            }
          });
        });
      } else {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to Request for Event');
      }
    });
  }

  Future<ReceivedGiftsDataModel>? getGiftsReceivedDataForEvent(
      BuildContext context, String? uid, String eid) async {
    return hitApi(
      true,
      UrlConstant.giftReceivedListForEvent,
      jsonEncode(<String, String>{
        'uid': prefModel.userData!.user!.userId!,
        'eid': eid,
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        return ReceivedGiftsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.giftReceivedListForEvent,
            jsonEncode(<String, String>{
              'uid': prefModel.userData!.user!.userId!,
              'eid': eid,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return ReceivedGiftsDataModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              throw Exception('Failed to load Home Data');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to load Gift Received Data');
      }
    });
  }

  Future<GreetingsAndWishesModel> getGreetingsAndWishes(
      BuildContext context, String? eventId) {
    return hitApi(
      true,
      UrlConstant.getGreetingCards,
      jsonEncode(
          {'uid': prefModel.userData!.user!.userId!, 'event_id': eventId}),
    ).then((response) {
      if (response.statusCode == 200) {
        return GreetingsAndWishesModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getGreetingCards,
            jsonEncode({
              'uid': prefModel.userData!.user!.userId!,
              'event_id': eventId
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return GreetingsAndWishesModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  createOrder(BuildContext context, Map arguments) {
    arguments['uid'] = prefModel.userData!.user!.userId!;
    return hitApi(
      true,
      UrlConstant.createOrder,
      jsonEncode(arguments),
    ).then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.createOrder,
            jsonEncode(arguments),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              Navigator.of(context, rootNavigator: true).pop();
            } else {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                showErrorToast(context, "Something Went Wrong");
              }
              Navigator.pop(context);
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  createPaymentSessionId(Map arguments, BuildContext context) async {
    String url = 'https://sandbox.cashfree.com/pg/orders';
    String clientId = 'TEST37487412eaae6cfeadaf419081478473';
    String clientSecret = 'TEST9a606fd25cb197a28767534be96a55e8aa19af5b';
    String apiVersion = '2022-09-01';
    String requestId = 'accelstack';

    Map<String, dynamic> requestBody = {
      "order_amount": arguments['transaction_amount'],
      "order_id": arguments['transaction_id'],
      "order_currency": "INR",
      "customer_details": {
        "customer_id": prefModel.userData!.user!.userId,
        "customer_name": prefModel.userData!.user!.name,
        "customer_email": prefModel.userData!.user!.email,
        "customer_phone": prefModel.userData!.user!.phone
      },
      "order_meta": {"notify_url": "https://test.cashfree.com"},
      "order_note": "Shagun for ",
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-client-id': clientId,
      'x-client-secret': clientSecret,
      'x-api-version': apiVersion,
      'x-request-id': requestId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String sessionId = jsonResponse['payment_session_id'];
      return sessionId;
    } else {
      if (context.mounted) {
        showErrorToast(context, "Something went wrong! Please try again later");
      }
      throw Exception('Failed to fetch');
    }
  }

  Future<NotificationDataModel>? fetchNotifications(BuildContext context) {
    return hitApi(
      true,
      UrlConstant.getNotifications,
      jsonEncode({'uid': prefModel.userData!.user!.userId!}),
    ).then((response) {
      if (response.statusCode == 200) {
        return NotificationDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.getNotifications,
            jsonEncode({'uid': prefModel.userData!.user!.userId!}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return NotificationDataModel.fromJson(
                  json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  Future<TrackOrderDataModel>? fetchOrderTrackData(
      BuildContext context, String? orderId) {
    return hitApi(
      true,
      UrlConstant.trackTransaction,
      jsonEncode({'uid': prefModel.userData!.user!.userId!, 'tid': orderId}),
    ).then((response) {
      if (response.statusCode == 200) {
        return TrackOrderDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.trackTransaction,
            jsonEncode(
                {'uid': prefModel.userData!.user!.userId!, 'tid': orderId}),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return TrackOrderDataModel.fromJson(json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to fetch');
      }
    });
  }

  searchGiftsSent(BuildContext context, String query) {
    return hitApi(
      true,
      UrlConstant.giftSentSearch,
      jsonEncode({'search': query, 'uid': prefModel.userData!.user!.userId}),
    ).then((response) {
      if (response.statusCode == 200) {
        return GiftsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.searchApi,
            jsonEncode({
              'search': query,
              'uid': prefModel.userData!.user!.userId,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return GiftsDataModel.fromJson(json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to search');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to search');
      }
    });
  }

  searchGiftsReceived(BuildContext context, String query) {
    return hitApi(
      true,
      UrlConstant.giftReceivedSearch,
      jsonEncode({'search': query, 'uid': prefModel.userData!.user!.userId}),
    ).then((response) {
      if (response.statusCode == 200) {
        return ReceivedGiftsDataModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        return getRefreshToken().then((_) {
          return hitApi(
            true,
            UrlConstant.searchApi,
            jsonEncode({
              'search': query,
              'uid': prefModel.userData!.user!.userId,
            }),
          ).then((reResponse) {
            if (reResponse.statusCode == 200) {
              return ReceivedGiftsDataModel.fromJson(json.decode(reResponse.body));
            } else {
              if (context.mounted) {
                showErrorToast(context, "Something Went Wrong");
              }
              throw Exception('Failed to search');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context, "Something Went Wrong");
        }
        throw Exception('Failed to search');
      }
    });
  }

  Future<String> updateProfile(BuildContext context, String name, File? selectedImage) async {
    var request =
    http.MultipartRequest('POST', Uri.parse(UrlConstant.editProfile));

    // Add form fields
    request.fields['uid'] = prefModel.userData!.user!.userId!;
    request.fields['name'] = name;
    request.fields['email'] = prefModel.userData!.user!.email!;
    request.fields['phone'] = prefModel.userData!.user!.phone!;
    request.headers.addAll(getHeaders(true));
    // Add file
    if (selectedImage != null) {
      var picStream = http.ByteStream(selectedImage.openRead());
      var length = await selectedImage.length();
      var multipartFile = http.MultipartFile(
        'profile_pic',
        picStream,
        length,
        filename: selectedImage.path.split('/').last,
        contentType:
        MediaType('image', 'jpeg'), // Adjust the content type accordingly
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await getRefreshToken();
      if(context.mounted){
        Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
        showSuccessToast(context, "Profile updated successfully !");
      }
      // var responseData = await response.stream.toBytes();
      // var responseJson = json.decode(utf8.decode(responseData));
      return "Success";
    } else {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
        showErrorToast(context, "Something went wrong");
      }
      throw Exception('Failed to upload image');
    }
  }
}
