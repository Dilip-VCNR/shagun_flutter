import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shagun_mobile/splash/view/on_boarding_screen.dart';
import 'package:shagun_mobile/splash/view/splash_screen.dart';
import 'package:shagun_mobile/utils/app_colors.dart';
import 'package:shagun_mobile/utils/routes.dart';
import 'package:shagun_mobile/web_view_screen.dart';
import 'auth/views/login_screen.dart';
import 'auth/views/otp_screen.dart';
import 'auth/views/register_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/my_events/view/all_invitations.dart';
import 'dashboard/my_events/view/event_details.dart';
import 'dashboard/notification/view/notifications_screen.dart';
import 'firebase_options.dart';
import 'gift_flow/view/check_out_screen.dart';
import 'gift_flow/view/greeting_card_detail.dart';
import 'gift_flow/view/select_greeting_card.dart';
import 'gift_flow/view/wish_input_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MaterialApp(
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
      },
    );
  }
}
