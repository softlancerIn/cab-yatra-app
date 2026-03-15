
import 'dart:ui';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../../../cores/utils/helperFunctions.dart';



import '../../custom/customToggleSwitch.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'activeBookingSection.dart';
import 'newBookingSection.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController searchController = TextEditingController();


  String numericPart = '0.0';

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // controller.getHomeData();
    _loadNumericPart();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadNumericPart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNumericPart = prefs.getString('numericPart');
    if (storedNumericPart != null) {
      setState(() {
        numericPart =
            storedNumericPart;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset("assets/images/menu.png", height: 20),
        ),
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              // color: Color.fromRGBO(0, 0, 0, 1),
              color: Colors.white),
        ),
        centerTitle: false,
        title: Text(
          'CabYatra',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(Icons.menu, color: Colors.black, size: 27),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 28,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Alert',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomToggleSwitch(),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 28,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Help',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Image.asset('assets/images/caall.png', scale: 4),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ServiceCallDialog();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (value) {
            // controller.getHomeData();
          },
          indicator: BoxDecoration(
            border: Border(
              bottom: const BorderSide(
                  color: Color.fromRGBO(255, 216, 0, 1), width: 4),
            ),
          ),
          labelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelColor: const Color(0xFF5A6980),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: "New Booking"),
            Tab(text: "Active Booking"),
          ],
        ),
      ),
      body: BlocBuilder<DashboardBloc,DashboardState>(
          builder: (context,state) {
            if(state.isLoading){
              return SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Center(child: const CircularProgressIndicator()));;

            }
            if(state.homeDataResponseModel==null){
              return SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Center(child: const CircularProgressIndicator()));;

            }
            final activeBookings=state.homeDataResponseModel!.activeBooking.data;
            final newBooking=state.homeDataResponseModel!.newBooking.data;


            return  Column(
              children: [
                Expanded(
                  child: GestureDetector(

                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        NewBookingSection(),
                        ActiveBookingSection(),
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
      ),
      drawerEnableOpenDragGesture: true,
    );
  }










}




class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashHeight = 2, dashSpace = 2, startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ServiceCallDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Our Services Number Available for call from',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: Color(0xFFC41B1B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                  TextSpan(
                    text: '06:00 AM',
                    style: TextStyle(
                      color: Color(0xFFC41B1B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: Color(0xFFC41B1B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'To',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: Color(0xFFC41B1B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: '09:00 PM.',
                    style: TextStyle(
                      color: Color(0xFFC41B1B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.05,
              decoration: ShapeDecoration(
                color: const Color(0xFF008A0D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    HelperFunctions.makePhoneCall(context, '7011873145');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      const Text(
                        'Call',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



///calculate
class DistanceCalculator {
  final String apiKey = 'AIzaSyDhTJHj8fT_dHJMkH0ndpW0guo4EQzXhHY';
  final Dio dio = Dio();

  // Method to get latitude and longitude from a location name
  Future<String?> getCoordinates(String locationName) async {
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': locationName,
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          print(
              'get geocoding location: ${location['lat']},${location['lng']}');
          return '${location['lat']},${location['lng']}';
        } else {
          print(
              'Error geocoding location: $locationName, Status: ${data['status']}');
        }
      }
    } catch (e) {
      print('Exception while geocoding location: $e');
    }
    return null;
  }

  Future<double> calculateTotalDistance({
    required List<String> pickUpLocs,
    required String destinationLoc,
  }) async {
    double totalDistance = 0.0;

    // Geocode destination location
    final destinationCoords = await getCoordinates(destinationLoc);
    if (destinationCoords == null) {
      print('Failed to geocode destination location.');
      return totalDistance;
    }

    for (String pickUpLoc in pickUpLocs) {
      // Geocode each pickup location
      final pickUpCoords = await getCoordinates(pickUpLoc);
      if (pickUpCoords == null) {
        print('Failed to geocode pickup location: $pickUpLoc');
        continue;
      }

      // Fetch distance between the pickup and destination
      try {
        final response = await dio.get(
          'https://maps.googleapis.com/maps/api/distancematrix/json',
          queryParameters: {
            'origins': pickUpCoords,
            'destinations': destinationCoords,
            'key': apiKey,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;

          if (data['status'] == 'OK' &&
              data['rows'][0]['elements'][0]['status'] == 'OK') {
            final distanceValue = data['rows'][0]['elements'][0]['distance']
                ['value']; // in meters
            totalDistance += distanceValue / 1000; // Convert to kilometers

            print('Fetch with distance calculation for $totalDistance');
          } else {
            print('Error with distance calculation for $pickUpLoc');
          }
        }
      } catch (e) {
        print('Exception while calculating distance: $e');
      }
    }

    return totalDistance;
  }
}
