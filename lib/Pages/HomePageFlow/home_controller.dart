import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Add New Booking/add_new_booking.dart';
import '../Booking/my_booking.dart';
import '../Custom_Widgets/bottom_nav_bar.dart';
import '../chat/chat_listing.dart';
import 'package:flutter/services.dart';
import '../Profile/profile.dart';
import 'dashboard/ui/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../chat/bloc/chat_bloc.dart';

class MainHomeController extends StatefulWidget {
  const MainHomeController({super.key});

  @override
  _MainHomeControllerState createState() => _MainHomeControllerState();
}

class _MainHomeControllerState extends State<MainHomeController> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Homepage(),
      BookingPage(onBack: () => _onItemTapped(0)),
      AddBookingScreen(onBack: () => _onItemTapped(0)),
      BlocProvider(
        create: (context) => ChatListBloc(),
        child: ChatListingScreen(onBack: () => _onItemTapped(0)),
      ),
      const EditProfilePage(),
    ];
    final args = Get.arguments;
    if (args != null && args['initialIndex'] != null) {
      _currentIndex = args['initialIndex'];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
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
          // If not on Home tab, redirect to Home tab
          setState(() {
            _currentIndex = 0;
          });
        } else {
          // If already on Home tab, show exit confirmation
          final bool? exit = await _showExitDialog(context);
          if (exit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
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
