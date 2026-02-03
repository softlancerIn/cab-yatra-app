import 'package:cab_taxi_app/Pages/AuthPages/login/ui/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import '../../Pages/AuthPages/login/ui/loginSelection.dart';

import '../../Pages/AuthPages/otp/ui/verify_otp.dart';
import '../../Pages/AuthPages/register/ui/newRegister.dart';

import '../../Pages/AuthPages/spalsh/spalshScreen.dart';
import '../../Pages/HomePageFlow/custom/alertFilterScreen.dart';
import '../../Pages/HomePageFlow/custom/apply_filter_dialog.dart';
import '../../Pages/HomePageFlow/home_controller.dart';
import '../../Pages/Mohnish_Sir/chat_listing.dart';
import 'navigation/routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      /// Splash (NO TRANSITION)
      GoRoute(
        path: Routes.splash,
        pageBuilder: (_, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),

      /// Onboarding (Slide)
      // GoRoute(
      //   path: Routes.onboarding,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     transitionsBuilder: slideTransition,
      //     child: const OnboardingScreen(),
      //   ),
      // ),

      // /// Login (Fade)
      GoRoute(
        path: Routes.login,
        pageBuilder: (_, state) => CustomTransitionPage(
          transitionsBuilder: fadeTransition,
          child: const LoginSelectionScreen(),
        ),
      ),

      GoRoute(
        path: Routes.otp,
        pageBuilder: (_, state) => CustomTransitionPage(
          transitionsBuilder: fadeTransition,
          child:  VerifyOtpPage(mobile:state.extra as String??"111111111" ,),
        ),
      ),


      //RideSelect
      // GoRoute(
      //   path: Routes.rideSelect,
      //   pageBuilder: (_, state) {
      //     final data = state.extra as Map<String, String>?;
      //
      //     return CustomTransitionPage(
      //       transitionsBuilder: fadeTransition,
      //       child: VerifyOtpPage(
      //         mobile: data?['mobile'] ?? "11111111",
      //
      //       ),
      //     );
      //   },
      // ),

      // GoRoute(
      //
      //   path: Routes.register,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     transitionsBuilder: fadeTransition,
      //     child: NewRegisterScreen(
      // //      isAgent: state.extra as bool? ?? false,
      //     ),
      //   ),
      // ),


      GoRoute(
        path: Routes.loginMobile,
        pageBuilder: (_, state) => CustomTransitionPage(
          transitionsBuilder: fadeTransition,
          child:  LoginScreen(phone:"7666667676",isRegister: false,),
        ),
      ),

      // GoRoute(
      //   path: Routes.newRegister,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     transitionsBuilder: fadeTransition,
      //     child:  NewRegisterScreen(),
      //   ),
      // ),

      GoRoute(
        path: Routes.newRegister,
        pageBuilder: (_, state) => CustomTransitionPage(
          transitionsBuilder: fadeTransition,
          child:  NewRegisterScreen(mobile:state.extra as String??"111111111" ,),
        ),
      ),
      GoRoute(
        path: Routes.loginRegister,
        pageBuilder: (_, state) => CustomTransitionPage(
          transitionsBuilder: fadeTransition,
          child:  LoginScreen(phone:"7666667676",isRegister: true,),
        ),
      ),

      // // /// Home (Default)
      // GoRoute(
      //   path: Routes.home,
      //   pageBuilder: (_, state) {
      //     final extra = state.extra as Map<String, dynamic>?;
      //
      //     return CustomTransitionPage(
      //       transitionsBuilder: fadeTransition,
      //       child: HomeScreen(
      //         isAgent: extra?['isAgent'] ?? false,
      //         isUser: extra?['isUser'] ?? false,
      //       ),
      //     );
      //   },
      // ),

      GoRoute(
        path: Routes.home,
        builder: (_, __) =>  MainHomeController(),
      ),
      GoRoute(
        path: Routes.applyFilter,
        builder: (_, __) =>  ApplyFilterDialog(),
      ),     GoRoute(
        path: Routes.chatListing,
        builder: (_, __) =>  ChatListingScreen(),
      ),
      GoRoute(
        path: Routes.alertFilter,
        builder: (_, __) =>  AlertFilterScreen(),
      ),



      /// Dashboard with Bottom Navigation
      // GoRoute(
      //   path: Routes.dashboard,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     transitionsBuilder: bottomToTopTransition,
      //     child: const DashboardScreen(),
      //   ),
      // ),
    ],
  );

  // ---- TRANSITION ANIMATIONS -----

  static Widget slideTransition(context, animation, secondary, child) =>
      SlideTransition(
        position:
        Tween(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
        child: child,
      );

  static Widget fadeTransition(context, animation, secondary, child) =>
      FadeTransition(opacity: animation, child: child);

  static Widget bottomToTopTransition(context, animation, secondary, child) =>
      SlideTransition(
        position:
        Tween(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
        child: child,
      );
}
