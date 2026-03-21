import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookingDetails/ui/bookingDetailScreen.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../../chat/chat_listing.dart';
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
        context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
      },
      child:
          BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
        if (state.isLoading && state.homeDataResponseModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final allBookings = state.homeDataResponseModel!.activeBooking.data;

        // Filter by status == 2 for active bookings
        final query = state.searchQuery.trim().toLowerCase();
        final activeBooking = allBookings.where((booking) {
          // Only show bookings with status 2
          if (booking.status != 2) return false;
          // Search by booking ID
          if (query.isNotEmpty) {
            return booking.bookingId.toLowerCase().contains(query) ||
                booking.id.toLowerCase().contains(query);
          }
          return true;
        }).toList();

        if (activeBooking.isEmpty) {
          return const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20),
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
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeBooking.length,
                    itemBuilder: (context, index) {
                      final bookingData = activeBooking[index];
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
                                                  fontSize: 14,
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
                                                  text: '${bookingData.bookingId} ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const TextSpan(
                                                  text: 'Assigned',
                                                  style: TextStyle(
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
                                              fontSize: 13,
                                              fontFamily: 'Poppins',
                                              color: Colors.black),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${HelperFunctions.formatDate(bookingData.pickupDate)} '),
                                            const TextSpan(
                                                text: '@',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            TextSpan(
                                              text: HelperFunctions.formatTo12Hour(bookingData.pickupTime),
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
                                          const Icon(Icons.location_on,
                                              size: 18, color: Colors.orange),
                                          SizedBox(
                                            width: 1,
                                            height: 30,
                                            child: CustomPaint(
                                                painter: DashLinePainter()),
                                          ),
                                          bookingData.bookingType.toLowerCase().contains('round')
                                              ? const Icon(Icons.sticky_note_2,
                                                  size: 18, color: Color(0xFF4CAF50))
                                              : const Icon(Icons.location_on,
                                                  size: 18,
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    bookingData.pickupLocation,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                _pillPriceBox(bookingData.totalFare, bookingData.driverCommission),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            if (bookingData.bookingType.toLowerCase().contains('round'))
                                              Text(
                                                'Trip Notes: ${bookingData.destinationLocation}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF4CAF50)),
                                              )
                                            else
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
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        bookingData.carImage,
                                        height: 35,
                                        width: 60,
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
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
                                    ],
                                  ),
                                ),

                                /// EXTRA REQUIREMENTS / NOTES
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 10),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 13, fontFamily: 'Poppins'),
                                      children: [
                                        const TextSpan(
                                          text: 'Extra Requirement: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
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

                                /// PRICE BOXES
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      _priceBox(
                                          "₹${bookingData.totalFare}",
                                          "Total Amount"),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${((double.tryParse(bookingData.totalFare.replaceAll(',', '')) ?? 0) - (double.tryParse(bookingData.driverCommission.replaceAll(',', '')) ?? 0)).toStringAsFixed(0)}",
                                          "Driver's Earning",
                                          isEarning: true),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${bookingData.driverCommission}",
                                          "Commission"),
                                    ],
                                  ),
                                ),

                                /// BUTTONS
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ChatListingScreen.show(context, bookingId: bookingData.id);
                                        },
                                        child: Container(
                                          height: 48,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFEFEF),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset("assets/images/chatNew.png", height: 20, color: const Color(0xffFCB117)),
                                              const SizedBox(width: 10),
                                              const Text("Chat", style: TextStyle(color: Color(0xffFCB117), fontWeight: FontWeight.bold, fontSize: 16)),
                                            ],
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

  Widget _pillPriceBox(String total, String commission) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('₹$total',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
                const Text('Total Amount',
                    style: TextStyle(fontSize: 6, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xffFCB117),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('₹$commission',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const Text('Commission',
                    style: TextStyle(fontSize: 6, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
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
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: isEarning ? const Color(0xFFF45858) : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
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
