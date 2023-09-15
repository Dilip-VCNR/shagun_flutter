import 'package:flutter/material.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../../database/app_pref.dart';
import '../../../database/models/pref_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/url_constants.dart';
import '../../my_events/controller/user_events_model.dart';
import '../controller/home_controllers.dart';
import '../model/search_data_model.dart';

class ProfileSearchScreen extends StatefulWidget {
  const ProfileSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSearchScreen> createState() => _ProfileSearchScreenState();
}

class _ProfileSearchScreenState extends State<ProfileSearchScreen> {
  SearchDataModel? searchData;
  HomeControllers homeControllers = HomeControllers();
  bool isLoading = false; // Added isLoading flag to track the loading state.
  PrefModel prefModel = AppPref.getPref();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackground,
            title: const Text(
              "Search by name or phone",
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  width: screenSize.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          onChanged: (query) async {
                            setState(() {
                              isLoading = true; // Show loading indicator.
                              searchData = null; // Clear previous search data.
                            });
                            searchData = await homeControllers.searchProfile(
                                query, context);
                            setState(() {
                              isLoading = false; // Hide loading indicator.
                            });
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "Search by Name or Phone",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Implement the search functionality here.
                          // For example, you can call the searchProfile function with the current query.
                          // homeControllers.searchProfile(query, context);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator() // Show loading indicator while data is being fetched.
                else if (searchData != null && searchData!.user!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchData!.user!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          if(searchData!.user![index].uid==prefModel.userData!.user!.userId){
                            showErrorToast(context, "You cannot gift for your events");
                            return;
                          }
                          showLoaderDialog(context);
                          UserEventsDataModel userEvents =
                              await homeControllers.getUserEvents(
                                  context, searchData!.user![index].uid);
                          if (userEvents.upcomingEvents!.isNotEmpty) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, Routes.userEventsRoute,
                                  arguments: {
                                    'userEvents': userEvents,
                                    'userName': searchData!.user![index].name,
                                  });
                            }
                          } else {
                            if (context.mounted) {
                              Navigator.pop(context);
                              showErrorToast(
                                context,
                                "No ongoing events found for the ${searchData!.user![index].name}",
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: screenSize.width / 1.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: AppColors.secondaryColor,
                                        backgroundImage: NetworkImage(
                                            UrlConstant.imageBaseUrl +
                                                searchData!
                                                    .user![index].profilePic!),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            searchData!.user![index].name!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          // const SizedBox(
                                          //   height: 5,
                                          // ),
                                          // Text(
                                          //   searchData!.user![index].phone!,
                                          //   style: const TextStyle(
                                          //       color: Colors.black,
                                          //       fontSize: 16),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right))
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const Text("No results"),
              ],
            ),
          ),
        ));
  }
}
