import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookingDetails/ui/bookingDetailScreen.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import 'sliderWidget.dart';
import '../../../chat/repo/chat_repo.dart';
import 'package:cab_taxi_app/cores/services/secure_storage_service.dart';

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
        context.read<DashboardBloc>().add(ClearFilterEvent());
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
          // Search by booking ID
          if (query.isNotEmpty) {
            return booking.bookingId.toLowerCase().contains(query) ||
                booking.id.toLowerCase().contains(query);
          }
          return true;
        }).toList();

        if (activeBooking.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const Center(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  isFromHome: true,
                                  showShareIcon: false,
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
                                                  text:
                                                      '${bookingData.bookingId} ',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: _getStatusText(
                                                      bookingData.status),
                                                  style: TextStyle(
                                                      color: _getStatusColor(
                                                          bookingData.status),
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
                                      Text(
                                        HelperFunctions.formatBookingDate(
                                            bookingData.pickupDate,
                                            bookingData.pickupTime),
                                        style: const TextStyle(
                                          fontSize: 13,
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
                                          bookingData.bookingType
                                                  .toLowerCase()
                                                  .contains('round')
                                              ? const Icon(Icons.sticky_note_2,
                                                  size: 18,
                                                  color: Color(0xFF4CAF50))
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    (bookingData.pickUpCity ??
                                                                "")
                                                            .isNotEmpty
                                                        ? bookingData
                                                            .pickUpCity!
                                                        : bookingData
                                                            .pickupLocation,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            if (bookingData.bookingType
                                                .toLowerCase()
                                                .contains('round'))
                                              Text(
                                                'Trip Notes: ${bookingData.destinationLocation}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF4CAF50)),
                                              )
                                            else
                                              Text(
                                                (bookingData.destinationCity ??
                                                            "")
                                                        .isNotEmpty
                                                    ? bookingData
                                                        .destinationCity!
                                                    : bookingData
                                                        .destinationLocation,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                          ],
                                        ),
                                      ),
                                      // const Center(
                                      //   child: Padding(
                                      //     padding: EdgeInsets.only(top: 20),
                                      //     child: Icon(Icons.arrow_forward_ios,
                                      //         size: 16, color: Colors.grey),
                                      //   ),
                                      // ),
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
                                      const Icon(Icons.arrow_forward_ios,
                                          size: 16, color: Colors.black87),
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
                                          text: () {
                                            final r = bookingData.remark;
                                            final e = bookingData.extra;
                                            if (r != null &&
                                                r.isNotEmpty &&
                                                e != null &&
                                                e.isNotEmpty) {
                                              return "$r / $e";
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      _priceBox("₹${bookingData.totalFare}",
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
                                      if (bookingData.status == 1) ...[
                                        // Status: Assigned
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildChatButton(
                                                  context, bookingData),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: _buildActionButton(
                                                text: "Pickup Booking",
                                                color: const Color(0xffFCB117),
                                                onTap: () async {
                                                  final chatRepo = ChatRepo();
                                                  final success = await chatRepo
                                                      .updateBookingStatus(
                                                    context: context,
                                                    bookingId: bookingData.id,
                                                    status: "4", // Picked Up
                                                  );
                                                  if (success) {
                                                    await chatRepo
                                                        .sendNewMessage(
                                                      context: context,
                                                      bookingId: bookingData.id,
                                                      receiverId: bookingData
                                                              .driverId ??
                                                          '0',
                                                      message:
                                                          "This booking is picked by agent",
                                                      type: 3,
                                                    );
                                                    if (context.mounted) {
                                                      context
                                                          .read<DashboardBloc>()
                                                          .add(GetHomeDataEvent(
                                                              context:
                                                                  context));
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                          _buildActionButton(
                                            text: "Cancel Booking",
                                            color: const Color(0xffF45858),
                                            onTap: () async {
                                            final chatRepo = ChatRepo();
                                            final success = await chatRepo
                                                .updateBookingStatus(
                                              context: context,
                                              bookingId: bookingData.id,
                                              status: "3", // Cancelled
                                            );
                                            if (success) {
                                              if (context.mounted) {
                                                context
                                                    .read<DashboardBloc>()
                                                    .add(GetHomeDataEvent(
                                                        context: context));
                                              }
                                            }
                                          },
                                        ),
                                      ] else if (bookingData.status == 4) ...[
                                        // Status: Picked Up
                                        _buildChatButton(context, bookingData),

                                        // Show End Booking ONLY after 2 hours from pickup time
                                        if (() {
                                          final pdt =
                                              bookingData.pickupDateTime;
                                          if (pdt == null)
                                            return true; // Fallback if parsing fails
                                          return DateTime.now().isAfter(pdt
                                              .add(const Duration(hours: 2)));
                                        }()) ...[
                                          const SizedBox(height: 12),
                                            _buildActionButton(
                                              text: "End Booking",
                                              color: const Color(0xFF2C3E50),
                                              onTap: () async {
                                              final chatRepo = ChatRepo();
                                              final success = await chatRepo
                                                  .updateBookingStatus(
                                                context: context,
                                                bookingId: bookingData.id,
                                                status: "2", // Completed
                                              );
                                              if (success) {
                                                await chatRepo.sendNewMessage(
                                                  context: context,
                                                  bookingId: bookingData.id,
                                                  receiverId:
                                                      bookingData.driverId ??
                                                          '0',
                                                  message:
                                                      "This booking is completed",
                                                  type: 3,
                                                );
                                                if (context.mounted) {
                                                  context
                                                      .read<DashboardBloc>()
                                                      .add(GetHomeDataEvent(
                                                          context: context));
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ] else ...[
                                        _buildChatButton(context, bookingData),
                                      ],
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
        );
      }),
    );
  }

  Widget _buildChatButton(BuildContext context, dynamic bookingData) {
    return GestureDetector(
      onTap: () async {
        // Check availability
        final bool isVehicleAvailable =
            bookingData.carCategoryName.toString().isNotEmpty;

        final String assignDriverId =
            bookingData.assignDriver?.id?.toString() ?? '0';

        final bool isDriverAvailable = (bookingData.status == 0)
            ? true
            : (assignDriverId != '0' ||
                (bookingData.driverId != null &&
                    bookingData.driverId.toString() != '0' &&
                    bookingData.driverId.toString().isNotEmpty));

        if (!isVehicleAvailable || !isDriverAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(!isVehicleAvailable
                  ? 'Vehicle details not available'
                  : 'Driver details not available'),
              backgroundColor: const Color(0xFFF45858),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        final myId = await SecureStorageService.getUserId();
        final isMeCreator = myId == bookingData.driverId?.toString() ||
            myId == bookingData.creatorId?.toString();

        final String finalReceiverId = isMeCreator
            ? (assignDriverId != '0'
                ? assignDriverId
                : (bookingData.driverId?.toString() ?? "0"))
            : (bookingData.driverId?.toString() ?? "0");

        final String assignDriverName = bookingData.assignDriver?.name ?? "";
        final String carCat = bookingData.carCategoryName?.toString() ?? "";
        final String finalUserName = isMeCreator
            ? (assignDriverName.isNotEmpty
                ? assignDriverName
                : (carCat.isNotEmpty ? carCat : "Driver"))
            : "Agent";

        Nav.push(context, Routes.chatScreen, extra: {
          'userName': finalUserName,
          'bookingId': bookingData.id,
          'creatorName': bookingData.creatorName ?? "Guddu",
          'receiverId': finalReceiverId,
        });
      },
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/chatNew.png",
                height: 18, color: const Color(0xffFCB117)),
            const SizedBox(width: 8),
            const Text("Chat",
                style: TextStyle(
                  color: Color(0xffFCB117),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
        ),
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
