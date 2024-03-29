import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shagun_mobile/dashboard/transactions/view/received_shagun_for_event_screen.dart';
import 'package:shagun_mobile/splash/view/on_boarding_screen.dart';
import 'package:shagun_mobile/splash/view/splash_screen.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/routes.dart';
import 'package:shagun_mobile/web_view_screen.dart';
import 'auth/views/login_screen.dart';
import 'auth/views/otp_screen.dart';
import 'auth/views/register_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/home/view/profile_search_screen.dart';
import 'dashboard/home/view/qr_scanner_screen.dart';
import 'dashboard/my_events/view/all_invitations.dart';
import 'dashboard/my_events/view/event_details.dart';
import 'dashboard/my_events/view/user_events_screen.dart';
import 'dashboard/notification/view/notifications_screen.dart';
import 'dashboard/transactions/view/search_transactions_screen.dart';
import 'database/app_pref.dart';
import 'firebase_options.dart';
import 'gift_flow/view/check_out_screen.dart';
import 'gift_flow/view/greeting_card_detail.dart';
import 'gift_flow/view/order_success_screen.dart';
import 'gift_flow/view/select_greeting_card.dart';
import 'gift_flow/view/track_orders_creen.dart';
import 'gift_flow/view/wish_input_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppPref.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return InternetWidget(
      offline: const FullScreenWidget(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/wireless.png'),width: 200,),
                SizedBox(height: 20,),
                Text("No Internet",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                Text("Please turn on your wifi or internet connection to keep using the app",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),)
              ],
            ),
          ),
        )
      ),
      loadingWidget: const Center(child: Text('Loading')),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shagun - Send and receive shagun on events',
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          primaryColor: AppColors.primaryColor,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
        ),
        initialRoute: Routes.splashRoute,
        routes: {
          Routes.splashRoute: (context) => const SplashScreen(),
          Routes.onBoarding: (context) => const OnBoardingScreen(),
          Routes.loginRoute: (context) => const LoginScreen(),
          Routes.otpScreenRoute: (context) => const OtpScreen(),
          Routes.registerRoute: (context) => const RegisterScreen(),
          Routes.dashboardRoute: (context) => const DashboardScreen(),
          Routes.webViewRoute: (context) => const WebViewScreen(),
          Routes.notificationsRoute: (context) => const NotificationsScreen(),
          Routes.allInvitationsRoute: (context) => const AllInvitations(),
          Routes.eventDetailsRoute: (context) => const EventDetails(),
          Routes.selectGreetingCardRoute: (context) => const SelectGreetingCard(),
          Routes.greetingCardDetailRoute: (context) => const GreetingCardDetail(),
          Routes.wishInputRoute: (context) => const WishInputScreen(),
          Routes.checkOutRoute: (context) => const CheckOutScreen(),
          Routes.profileSearchRoute: (context) => const ProfileSearchScreen(),
          Routes.userEventsRoute: (context) => const UserEventsScreen(),
          Routes.qrScannerRoute: (context) => const QrScannerScreen(),
          Routes.giftsForEventRoute: (context) => const ReceivedShagunForEventScreen(),
          Routes.orderSuccessRoute: (context) => const OrderSuccessScreen(),
          Routes.trackOrderRoute: (context) => const TrackOrderScreen(),
          Routes.searchTransactionsRoute: (context) => const SearchTransactionsScreen(),
        },
      ),
    );
  }
}
