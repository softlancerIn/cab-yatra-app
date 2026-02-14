
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Pages/AuthPages/login/bloc/loginBloc.dart';

import 'Pages/AuthPages/otp/bloc/otpBloc.dart';
import 'Pages/AuthPages/register/bloc/registerBloc.dart';
import 'Pages/Booking/bloc/booking_bloc.dart';
import 'Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'Pages/bookingDetails/bloc/bookingDetailsBloc.dart';
import 'Pages/editBooking/bloc/editBookingBloc.dart';
import 'app/router/app_router.dart';
import 'core/api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dioClient = DioClient();
  dioClient.setupInterceptors();
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
