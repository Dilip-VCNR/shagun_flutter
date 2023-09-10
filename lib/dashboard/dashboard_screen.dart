import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shagun_mobile/dashboard/profile/view/profile_screen.dart';
import 'package:shagun_mobile/dashboard/transactions/view/received_shagun_screen.dart';
import 'package:shagun_mobile/dashboard/transactions/view/sent_shagun_screen.dart';
import 'package:shagun_mobile/utils/app_colors.dart';

import 'home/view/home_screen.dart';
import 'my_events/view/my_events_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  List screens = [
  const HomeScreen(),
  const SentShagunScreen(),
  const MyEventsScreen(),
  const ReceivedShagunScreen(),
  const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SalomonBottomBar(
          selectedColorOpacity:.1,
          selectedItemColor: AppColors.primaryColor,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.call_missed_outgoing_outlined),
              title: const Text("Sent"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              title: const Text("My Events"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.call_missed_outlined),
              title: const Text("Received"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
