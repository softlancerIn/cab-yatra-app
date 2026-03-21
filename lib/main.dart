
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Pages/Add New Booking/bloc/addBookingBloc.dart';
import 'Pages/Add New Booking/bloc/addBookingEvent.dart';
import 'Pages/AuthPages/login/bloc/loginBloc.dart';

import 'Pages/AuthPages/otp/bloc/otpBloc.dart';
import 'Pages/AuthPages/register/bloc/registerBloc.dart';
import 'Pages/Booking/bloc/booking_bloc.dart';
import 'Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'Pages/Payment Method/bloc/paymentBloc.dart';
import 'Pages/Profile/bloc/personal_info_bloc.dart';
import 'Pages/addDriver/bloc/driverBloc.dart';
import 'Pages/bookingDetails/bloc/bookingDetailsBloc.dart';
import 'Pages/cms/bloc/cms_bloc.dart';
import 'Pages/editBooking/bloc/editBookingBloc.dart';
import 'Pages/manage_vehicles/bloc/vehicle_bloc.dart';
import 'Pages/transection/bloc/transections_bloc.dart';
import 'Pages/Profile/repo/profileRepo.dart';
import 'Pages/Review/bloc/review_bloc.dart';
import 'app/router/app_router.dart';

import 'cores/services/notification_service.dart';
import 'firebase_options.dart';

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();
  await FCMService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
       // BlocProvider(create: (_) => SplashBloc(SplashRepo())),
       //  BlocProvider(create: (_) => OnboardingBloc(OnboardingRepo())),
       //  BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider<SignInBloc>(create: (context) => SignInBloc(),),
        BlocProvider<OTPBloc>(create: (context) => OTPBloc(),),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(),),
        BlocProvider<DashboardBloc>(create: (context) => DashboardBloc(),),
         BlocProvider<BookingDetailBloc>(create: (context) => BookingDetailBloc(),),
         BlocProvider<BookingBloc>(create: (context) => BookingBloc(),),
        BlocProvider<EditBookingBloc>(create: (context) => EditBookingBloc(),),
        BlocProvider<PersonalInfoBloc>(create: (context) => PersonalInfoBloc(),),
        BlocProvider<AddBookingBloc>(create: (context) => AddBookingBloc()..add(LoadCarCategories(context)),),
        BlocProvider<DriverBloc>(create: (context) => DriverBloc(),),
    BlocProvider<PaymentBloc>(create: (context) => PaymentBloc(),),
        BlocProvider<TransectionsBloc>(create: (context) => TransectionsBloc(),),
        BlocProvider<VehicleBloc>(create: (context) => VehicleBloc(),),
         BlocProvider<CmsBloc>(create: (context) => CmsBloc(),),
         BlocProvider<ReviewBloc>(create: (context) => ReviewBloc(profileRepo: ProfileRepo()),),
        // BlocProvider<SettingsBloc>(create: (context) => SettingsBloc(),),
        // BlocProvider<BookingHistoryBloc>(create: (context) => BookingHistoryBloc(),),
        // BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatusEvent())),
      ],
      child: MaterialApp.router(
        // navigatorKey: navigatorKey,
        title: "Cab Yatra",

        // 🔥 System theme detect automatically
        themeMode: ThemeMode.system,

        routerConfig: AppRouter.router,

        debugShowCheckedModeBanner: false,
      ),
    );
   //  return GetMaterialApp(
   //    debugShowCheckedModeBanner: false,
   //    title: 'Flutter Demo',
   //    theme: ThemeData(
   //      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
   //      useMaterial3: true,
   //    ),
   //    // home: OtpPage(),
   //   home: const SplashScreen(),
   // //    home: LoginSelectionScreen(),
   //  );
  }
}
