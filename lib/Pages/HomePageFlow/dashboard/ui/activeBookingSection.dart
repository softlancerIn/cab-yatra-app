import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookingDetails/ui/bookingDetailScreen.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'homepage.dart';
import 'sliderWidget.dart';

class ActiveBookingSection extends StatefulWidget {
  const ActiveBookingSection({super.key});

  @override
  State<ActiveBookingSection> createState() => _ActiveBookingSectionState();
}

class _ActiveBookingSectionState extends State<ActiveBookingSection> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.getHomeData();
      },
      child:
          BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }
        if (state.homeDataResponseModel == null) {
          return const CircularProgressIndicator();
        }

        final allBookings = state.homeDataResponseModel!.activeBooking.data;

        final activeBooking = allBookings.where((booking) {
          final query = state.searchQuery.trim().toLowerCase();
          final queryWords =
              query.split(' ').where((word) => word.isNotEmpty).toList();

          bool matchesSearch = true;
          if (queryWords.isNotEmpty) {
            matchesSearch = queryWords.every((word) {
              return booking.bookingId.toLowerCase().contains(word) ||
                  booking.pickupLocation.toLowerCase().contains(word) ||
                  booking.destinationLocation.toLowerCase().contains(word);
            });
          }

          final matchesVehicle = state.selectedVehicleType == null ||
              booking.carCategoryName.toLowerCase() ==
                  state.selectedVehicleType!.toLowerCase();

          final matchesPickup = state.pickupLocationFilter == null ||
              booking.pickupLocation
                  .toLowerCase()
                  .contains(state.pickupLocationFilter!.toLowerCase());

          final matchesDrop = state.dropLocationFilter == null ||
              booking.destinationLocation
                  .toLowerCase()
                  .contains(state.dropLocationFilter!.toLowerCase());

          return matchesSearch &&
              matchesVehicle &&
              matchesPickup &&
              matchesDrop;
        }).toList();

        if (activeBooking.isEmpty) {
          return const SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: SliderWidget(),
                ),
                Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text("No active bookings found"),
                )),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: SliderWidget(),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeBooking.length,
                    itemBuilder: (context, index) {
                      var bookingData = activeBooking[index];
                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetailScreen(
                                  bookingID: bookingData.id,
                                ),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade300, width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// HEADER: ID, Date, Trip Type
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins'),
                                              children: [
                                                const TextSpan(
                                                  text: 'ID : ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text: bookingData.bookingId,
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            bookingData.bookingType,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3E4959),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${bookingData.pickupDate} '),
                                            const TextSpan(
                                                text: '@',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            TextSpan(
                                              text: bookingData.pickupTime,
                                              style: const TextStyle(
                                                  color: Color(0xFFF45858),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: Colors.grey),

                                /// ROUTE: Pickup & Drop with Dotted Line
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(Icons.circle,
                                              size: 14, color: Colors.orange),
                                          SizedBox(
                                            width: 1,
                                            height: 30,
                                            child: CustomPaint(
                                                painter: DashLinePainter()),
                                          ),
                                          const Icon(Icons.circle,
                                              size: 14,
                                              color: Color(0xFFC51C1C)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 2),
                                            Text(
                                              bookingData.pickupLocation,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 28),
                                            Text(
                                              bookingData.destinationLocation,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Icon(Icons.arrow_forward_ios,
                                              size: 16, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// VEHICLE INFO
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        bookingData.carImage,
                                        height: 30,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                    "assets/images/carMO.png",
                                                    height: 30),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          bookingData.carCategoryName,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// EXTRA REQUIREMENTS / NOTES
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 11, fontFamily: 'Poppins'),
                                      children: [
                                        const TextSpan(
                                          text: 'Extra Requirement: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: bookingData.remark ?? "N/A",
                                          style: const TextStyle(
                                              color: Color(0xFFF45858),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// PRICE BOXES (Mini version for Active Bookings if preferred, but keeping consistent)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      _priceBox("₹${bookingData.totalFare}",
                                          "Total Amount"),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${bookingData.driverCommission}",
                                          "Driver's Earning",
                                          isEarning: true),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${bookingData.driverCommission}",
                                          "Commission"),
                                    ],
                                  ),
                                ),

                                /// CHAT / CANCEL ACTIONS
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Chat Logic
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffFCB117)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/images/chatNew.png",
                                                    height: 16),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  "Chat",
                                                  style: TextStyle(
                                                      color: Color(0xffFCB117),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Cancel Logic
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF45858)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Color(0xFFF45858),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _priceBox(String amount, String label, {bool isEarning = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isEarning ? const Color(0xFFF45858) : Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
