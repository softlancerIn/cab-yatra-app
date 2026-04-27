import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cab_taxi_app/Pages/Add%20New%20Booking/add_new_booking.dart';
import 'package:cab_taxi_app/Pages/Booking/my_booking.dart';
import 'package:cab_taxi_app/Pages/Custom_Widgets/bottom_nav_bar.dart';
import 'package:cab_taxi_app/Pages/chat/chat_listing.dart';
import 'package:cab_taxi_app/Pages/Profile/profile.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:cab_taxi_app/Pages/chat/bloc/chat_bloc.dart';
import 'package:cab_taxi_app/Pages/Booking/bloc/booking_bloc.dart';
import 'package:cab_taxi_app/Pages/Booking/bloc/booking_event.dart';

class MainHomeController extends StatefulWidget {
  const MainHomeController({super.key});

  @override
  _MainHomeControllerState createState() => _MainHomeControllerState();
}

class _MainHomeControllerState extends State<MainHomeController> {
  int _currentIndex = 0;

  // Key generator for each tab to force complete state reset on tap
  final List<int> _tabKeys = List.generate(5, (_) => 0);

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['initialIndex'] != null) {
      _currentIndex = args['initialIndex'];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Incrementing the key forces Flutter to dispose the old state and create a new one,
      // which fulfills the requirement of "never hold the data" and "refresh page everytime".
      _tabKeys[index]++;
    });

    // Manually trigger data refresh to be extra sure
    if (index == 1) {
      context.read<BookingBloc>().add(GetPostedBooingEvent(context: context));
    }
  }

  Widget _buildPage(int index) {
    final key = ValueKey("${index}_${_tabKeys[index]}");
    switch (index) {
      case 0:
        return Homepage(key: key);
      case 1:
        return BookingPage(key: key, onBack: () => _onItemTapped(0));
      case 2:
        return AddBookingScreen(
          key: key,
          onBack: () => _onItemTapped(0),
          onSuccess: () => _onItemTapped(1),
        );
      case 3:
        return BlocProvider(
          key: key,
          create: (context) => ChatListBloc(),
          child: ChatListingScreen(onBack: () => _onItemTapped(0)),
        );
      case 4:
        return EditProfilePage(key: key);
      default:
        return const Homepage();
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    } else {
      bool? exit = await _showExitDialog(context);
      if (exit == true) {
        await SystemNavigator.pop();
      }
      return false;
    }
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Exit App',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: const Text('Do you really want to exit the app?',
            style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes',
                style: TextStyle(
                    color: Color(0xFFFFB300),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        } else {
          final bool? exit = await _showExitDialog(context);
          if (exit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(5, (index) => _buildPage(index)),
        ),
        bottomNavigationBar: _currentIndex == 2
            ? null
            : CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
              ),
      ),
    );
  }
}
