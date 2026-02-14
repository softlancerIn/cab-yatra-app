import 'package:cab_taxi_app/Pages/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Add New Booking/add_new_booking.dart';
import '../Booking/my_booking.dart';
import '../Custom_Widgets/bottom_nav_bar.dart';
import '../Mohnish_Sir/chat_listing.dart';
import '../Profile/profile.dart';
import '../Review/reviewSectionNew.dart';
import 'dashboard/ui/homepage.dart';



class MainHomeController extends StatefulWidget {
  const MainHomeController({Key? key}) : super(key: key);

  @override
  _MainHomeControllerState createState() => _MainHomeControllerState();
}

class _MainHomeControllerState extends State<MainHomeController> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Homepage(),
    BookingPage(),
    AddBookingScreen(),
    ChatListingScreen(),
    // EditProfilePagRe(),
    // AgentReviewScreen(),
    ProfileScreen(),
  ];

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
    }
    return true;
  }
  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['initialIndex'] != null) {
      _currentIndex = args['initialIndex'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _currentIndex == 2
            ? null // Hide the bottom navigation bar
            : CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}