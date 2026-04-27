import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookingDetails/ui/bookingDetailScreen.dart';
import 'sliderWidget.dart';

class NewBookingSection extends StatefulWidget {
  const NewBookingSection({super.key});

  @override
  State<NewBookingSection> createState() => _NewBookingSectionState();
}

class _NewBookingSectionState extends State<NewBookingSection> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const ClearFilterEvent());
        context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
      },
      child:
          BlocBuilder<DashboardBloc, DashboardState>(builder: (context, state) {
        if (state.isLoading && state.homeDataResponseModel == null) {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: CircularProgressIndicator()));
        }

        final allBookings = state.homeDataResponseModel!.newBooking.data;

        final newBooking = allBookings.where((booking) {
          final query = state.searchQuery.trim().toLowerCase();

          bool matchesSearch = true;
          if (query.isNotEmpty) {
            matchesSearch = booking.bookingId.toLowerCase().contains(query) ||
                booking.id.toLowerCase().contains(query);
          }

          // Drop Location Filter
          bool matchesDrop = state.dropLocationFilter == null ||
              booking.destinationLocation
                  .toLowerCase()
                  .contains(state.dropLocationFilter!.toLowerCase());

          // Pickup Location Filter
          bool matchesPickup = state.pickupLocationFilters == null ||
              state.pickupLocationFilters!.isEmpty ||
              state.pickupLocationFilters!.any((loc) => booking.pickupLocation
                  .toLowerCase()
                  .contains(loc.toLowerCase()));

          // Vehicle Type Filter
          bool matchesVehicle = state.selectedVehicleTypes == null ||
              state.selectedVehicleTypes!.isEmpty ||
              state.selectedVehicleTypes!.any((v) => booking.carCategoryName
                  .toLowerCase()
                  .contains(v.toLowerCase()));

          return matchesSearch &&
              matchesDrop &&
              matchesPickup &&
              matchesVehicle;
        }).toList();

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // child: controller.homeLoading.value
          //     ? CircularProgressIndicator()
          //     : Column(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: SliderWidget(banners: state.homeDataResponseModel!.banners),
              ),
              if (newBooking.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Text(
                      "No bookings found",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // alignment:Alignment.centerRight,
                    itemCount: newBooking.length,
                    itemBuilder: (context, index) {
                      // var newBookingData = controller
                      //     .homeData.value.newBooking!.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailScreen(
                                bookingID: newBooking[index].id,
                                isFromHome: true,
                                showShareIcon: false,
                              ),
                            ),
                          );
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
                                                  text:
                                                      '${newBooking[index].bookingId} ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: _getStatusText(
                                                      newBooking[index].status),
                                                  style: TextStyle(
                                                      color: _getStatusColor(
                                                          newBooking[index]
                                                              .status),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            newBooking[index].bookingType,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3E4959),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${HelperFunctions.formatBookingDate(
                                          newBooking[index].pickupDate,
                                          newBooking[index].pickupTime
                                        )} ${() {
                                          if (newBooking[index].noOfDays != null &&
                                              newBooking[index].noOfDays!.isNotEmpty &&
                                              newBooking[index].noOfDays != "0") {
                                            return " (${newBooking[index].noOfDays!.padLeft(2, '0')} days)";
                                          }
                                          return "";
                                        }()}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
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
                                      if (newBooking[index]
                                          .bookingType
                                          .toLowerCase()
                                          .contains('round')) ...[
                                        // Round Trip: both icons + dashed line, "Round Trip" label at bottom
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
                                            const Icon(Icons.location_on,
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
                                              Text(
                                                (newBooking[index].pickUpCity ?? "").isNotEmpty 
                                                  ? newBooking[index].pickUpCity! 
                                                  : newBooking[index].pickupLocation,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 28),
                                              const Text(
                                                'Round Trip',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFF45858)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ] else ...[
                                        // One Way: show pickup + destination
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
                                            const Icon(Icons.location_on,
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
                                              Text(
                                                (newBooking[index].pickUpCity ?? "").isNotEmpty 
                                                  ? newBooking[index].pickUpCity! 
                                                  : newBooking[index].pickupLocation,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 28),
                                              Text(
                                                (newBooking[index].destinationCity ?? "").isNotEmpty 
                                                  ? newBooking[index].destinationCity! 
                                                  : newBooking[index].destinationLocation,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                      if (newBooking[index].carImage.isNotEmpty &&
                                          newBooking[index].carImage.startsWith('http'))
                                        Image.network(
                                          newBooking[index].carImage,
                                          height: 30,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Image.asset("assets/images/carMO.png", height: 30),
                                        )
                                      else
                                        Image.asset("assets/images/carMO.png", height: 30),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          newBooking[index].carCategoryName,
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
                                          text: () {
                                            final r = newBooking[index].remark;
                                            final e = newBooking[index].extra;
                                            if (r != null &&
                                                r.isNotEmpty &&
                                                e != null &&
                                                e.isNotEmpty) {
                                              return "$r | $e";
                                            }
                                            return (r == null || r.isEmpty)
                                                ? (e == null || e.isEmpty
                                                    ? "N/A"
                                                    : e)
                                                : r;
                                          }(),
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
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      _priceBox(
                                          "₹${newBooking[index].totalFare}",
                                          "Total Amount"),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${((double.tryParse(newBooking[index].totalFare.replaceAll(',', '')) ?? 0) - (double.tryParse(newBooking[index].driverCommission.replaceAll(',', '')) ?? 0)).toStringAsFixed(0)}",
                                          "Driver's Earning",
                                          isEarning: true),
                                      const SizedBox(width: 8),
                                      _priceBox(
                                          "₹${newBooking[index].driverCommission}",
                                          "Commission"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
            ],
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

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Open';
      case 1:
        return 'Assigned';
      case 2:
        return 'Completed';
      case 3:
        return 'Cancelled';
      case 4:
        return 'Picked Up';
      default:
        return 'Unknown ($status)';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return const Color(0xff45B129);
      case 1:
        return Colors.orange;
      case 2:
        return const Color(0xff45B129);
      case 3:
        return const Color(0xffF45858);
      case 4:
        return Colors.blue;
      default:
        return Colors.black;
    }
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
