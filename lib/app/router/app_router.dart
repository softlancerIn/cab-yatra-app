import 'package:cab_taxi_app/Pages/AuthPages/login/ui/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import '../../Pages/Add Profile/add_profile.dart';
import '../../Pages/AuthPages/login/ui/loginSelection.dart';

import '../../Pages/AuthPages/otp/ui/verify_otp.dart';
import '../../Pages/AuthPages/register/ui/newRegister.dart';

import '../../Pages/AuthPages/spalsh/spalshScreen.dart';
import '../../Pages/Booking/model/postBookingListModel.dart';
import '../../Pages/HomePageFlow/custom/alertFilterScreen.dart';
import '../../Pages/HomePageFlow/custom/apply_filter_dialog.dart';
import '../../Pages/HomePageFlow/home_controller.dart';
import '../../Pages/chat/chat_listing.dart';
import '../../Pages/Payment Method/ui/payment_method.dart';
import '../../Pages/Profile/ui/personalInfoScreen.dart';
import '../../Pages/Review/reviewSectionNew.dart';
import '../../Pages/addDriver/ui/manageDriversScreen.dart';
import '../../Pages/editBooking/edit_new_booking.dart';
import '../../Pages/transection/ui/transectionScreen.dart';
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
      ), GoRoute(
        path: Routes.paymentMethod,
        builder: (_, __) =>  PaymentMethodScreen(),
      ),
      GoRoute(
        path: Routes.manageDrivers,
        builder: (_, __) =>  ManageDriversScreen(),
      ),GoRoute(
        path: Routes.transection,
        builder: (_, __) =>  TransectionScreen(),
      ),
      GoRoute(
        path: Routes.applyFilter,
        builder: (_, __) =>  ApplyFilterDialog(),
      ),
      GoRoute(
        path: Routes.editBooking,
        builder: (context, state) {

          final bookingData = state.extra as SeeBookingData; // 👈 your model

          return EditBookingScreen(
            bookingType: bookingData.subTypeLabel ?? "",
            vehicalType: bookingData.carCategoryId ?? "",
            pickUpLocation: bookingData.pickUpLoc ?? "",
            dropLocation: bookingData.destinationLoc ?? "",
            pickUpDate: bookingData.pickUpDate ?? "",
            pickUpTime: bookingData.pickUpTime ?? "",
            totalFare: bookingData.totalFaire ?? "",
            driverCommission: bookingData.driverCommission ?? "",
            remark: bookingData.remark ?? "",
          );
        },
      ),


      GoRoute(
        path: Routes.reviewScreen,
        builder: (_, __) =>  AgentReviewScreen(),
      ),    GoRoute(
        path: Routes.profile,
        builder: (_, __) =>  PersonalInfoScreen (),
      ),
      GoRoute(
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
