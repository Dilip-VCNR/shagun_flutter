import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../auth/model/ip_location_model.dart';
import '../auth/model/user_details_model.dart';
import '../dashboard/my_events/model/all_invites_data_model.dart';
import '../dashboard/home/model/home_data_model.dart';
import '../dashboard/home/model/search_data_model.dart';
import '../dashboard/my_events/model/events_screen_model.dart';
import '../dashboard/my_events/model/single_event_model.dart';
import '../dashboard/profile/model/profile_data_model.dart';
import '../dashboard/transactions/model/gifts_data_model.dart';
import '../dashboard/transactions/model/received_gifts_data_model.dart';
import '../database/app_pref.dart';
import '../database/models/pref_model.dart';
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
    var response = await hitApi(
      false,
      UrlConstant.userDetails,
      jsonEncode({
        'uid': prefModel.userData!.user!.userId!,
        'fcm_token': prefModel.userData!.token!,
      }),
    );
    UserDetailsModel user = UserDetailsModel.fromJson(json.decode(response.body));
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
                showErrorToast(context,"Something Went Wrong");
              }
              throw Exception('Failed to search');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context,"Something Went Wrong");
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
                showErrorToast(context,"Something Went Wrong");
              }
              throw Exception('Failed to fetch');
            }
          });
        });
      } else {
        if (context.mounted) {
          showErrorToast(context,"Something Went Wrong");
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
            jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
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
          showErrorToast(context,"Something Went Wrong");
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
            jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
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
          showErrorToast(context,"Something Went Wrong");
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
            jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
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
          showErrorToast(context,"Something Went Wrong");
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
            jsonEncode(<String, String>{'uid': prefModel.userData!.user!.userId!}),
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
          showErrorToast(context,"Something Went Wrong");
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
      ) async {
    var ipResponse = await http.get(
      Uri.parse(UrlConstant.ipLocation),
      headers: getHeaders(false),
    );
    String city = IpLocationModel.fromJson(json.decode(ipResponse.body)).location!.city!;

    return hitApi(
      false,
      UrlConstant.registerUser,
      jsonEncode({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'profile': "",
        'auth_type': authType,
        'role': 3,
        'city': city,
        'fcm_token': fcmToken,
      }),
    ).then((response) {
      return {
        "statusCode": response.statusCode,
        "data": UserDetailsModel.fromJson(json.decode(response.body)),
      };
    });
  }


}
