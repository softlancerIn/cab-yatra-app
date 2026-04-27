import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../cores/utils/helperFunctions.dart';
import '../../custom/customToggleSwitch.dart';
import '../../custom/customSearchBar.dart';
import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'activeBookingSection.dart';
import 'newBookingSection.dart';
import '../../../../Pages/Custom_Widgets/service_call_dialog.dart';

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
    context.read<DashboardBloc>().add(ResetDashboardEvent());
    context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
    context.read<DashboardBloc>().add(GetCitiesEvent(context: context));
    context.read<DashboardBloc>().add(GetCarCategoryEvent(context: context));
    context.read<DashboardBloc>().add(GetAlertsEvent(context: context));
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // controller.getHomeData();
    _loadNumericPart();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> _loadNumericPart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNumericPart = prefs.getString('numericPart');
    if (storedNumericPart != null) {
      setState(() {
        numericPart = storedNumericPart;
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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0, // Reduced from default
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        centerTitle: false,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cab',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Slightly reduced from 20
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Yatra',
              style: TextStyle(
                color: Color(0xFFFFB300),
                fontSize: 20, // Slightly reduced from 22
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                /// Alert Button
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced from 12
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Alert',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12, // Reduced from 13
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(width: 4), // Reduced from 8
                      CustomToggleSwitch(),
                    ],
                  ),
                ),
                const SizedBox(width: 4), // Reduced from 8

                /// Help Button
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const ServiceCallDialog(),
                    );
                  },
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced from 12
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Help',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12, // Reduced from 13
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 4), // Reduced from 6
                        Image.asset('assets/images/caall.png', height: 16), // Reduced height from 18
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFFFB300), width: 3),
              ),
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 17, // Increased from 15
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(
                fontSize: 17, // Increased from 15
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              tabs: const [
                Tab(text: "New Booking"),
                Tab(text: "Active Booking"),
              ],
            ),
          ),
        ),
      ),
      body:
          BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          // Sync search controller when state is cleared (on pull-to-refresh or filter clear)
          if (state.searchQuery.isEmpty && searchController.text.isNotEmpty) {
            searchController.clear();
          }
        },
        builder: (context, state) {
        if (state.isLoading && state.homeDataResponseModel == null) {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: CircularProgressIndicator()));
        }
        
        if (state.errorMessage != null && state.homeDataResponseModel == null) {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.errorMessage}"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
                      },
                      child: const Text("Retry"),
                    )
                  ],
                ),
              ));
        }

        if (state.homeDataResponseModel == null) {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: Text("No data available")));
        }

        final activeBookings = state.homeDataResponseModel!.activeBooking.data;
        final newBooking = state.homeDataResponseModel!.newBooking.data;

        return Column(
          children: [
            /// Search and Filter Section
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: searchController,
                      onSearch: () {
                        context.read<DashboardBloc>().add(
                            UpdateSearchQueryEvent(
                                searchQuery: searchController.text.trim()));
                      },
                      onChanged: (value) {
                        context.read<DashboardBloc>().add(UpdateSearchQueryEvent(searchQuery: value.trim()));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Nav.push(context, Routes.applyFilter);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/seetingFilter.png",
                          height: 24,
                          color: state.isFilterActive ? const Color(0xFFF45858) : Colors.black87,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  NewBookingSection(),
                  ActiveBookingSection(),
                ],
              ),
            ),
          ],
        );
      }),
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

///calculate
class DistanceCalculator {
  final String apiKey = 'AIzaSyCyO9SWzEn8SWchaaqa6T_yCmCD8cLHPfg';
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
