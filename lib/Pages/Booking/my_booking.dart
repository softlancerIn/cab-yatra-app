import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/router/navigation/routes.dart';
import '../HomePageFlow/custom/customSearchBar.dart';
import '../bookingDetails/ui/bookingDetailScreen.dart';
import 'bloc/booking_bloc.dart';
import 'bloc/booking_event.dart';
import 'bloc/booking_state.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_state.dart';
import '../HomePageFlow/custom/apply_filter_dialog.dart';
import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import '../chat/chat_listing.dart';

class BookingPage extends StatefulWidget {
  final VoidCallback? onBack;
  const BookingPage({super.key, this.onBack});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetPostedBooingEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        title: "Posted Booking",
        showLeading: true,
        onLeadingPressed: widget.onBack ?? () => Navigator.pop(context),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (state.postedBookingModel == null) {
            return SizedBox(
                  height: size.height,
                  width: size.width,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final allBookings = state.postedBookingModel!.data ?? [];
              final newBooking = allBookings.where((booking) {
                // Search Query Filter
                final query = state.searchQuery.toLowerCase().trim();
                bool matchesSearch = query.isEmpty ||
                    (booking.orderId?.toLowerCase().contains(query) ?? false) ||
                    (booking.id?.toString().toLowerCase().contains(query) ?? false);

                // Drop Location Filter
                bool matchesDrop = state.dropLocationFilter == null ||
                    (booking.destinationLoc ?? "")
                        .toLowerCase()
                        .contains(state.dropLocationFilter!.toLowerCase());

                // Pickup Location Filter
                bool matchesPickup = state.pickupLocationFilters == null ||
                    state.pickupLocationFilters!.any((loc) =>
                        (booking.pickUpLoc ?? "")
                            .toLowerCase()
                            .contains(loc.toLowerCase()));

                // Vehicle Type Filter
                bool matchesVehicle = state.selectedVehicleTypes == null ||
                    state.selectedVehicleTypes!.any((v) =>
                        (booking.carCategory?.name ?? "")
                            .toLowerCase()
                            .contains(v.toLowerCase()));

                // Booking Status Filter
                bool matchesStatus = true;
                if (state.bookingStatusFilter != null) {
                  if (state.bookingStatusFilter == 'Open') {
                    matchesStatus = booking.isAssigned == '0';
                  } else if (state.bookingStatusFilter == 'Assigned') {
                    matchesStatus = booking.isAssigned == '1';
                  }
                  // Note: Add logic here for Completed/Cancelled if API supports it
                }

                return matchesSearch &&
                    matchesDrop &&
                    matchesPickup &&
                    matchesVehicle &&
                    matchesStatus;
              }).toList();

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        controller: searchController,
                        onSearch: () {
                          context.read<BookingBloc>().add(
                                UpdatePostedBookingSearchQueryEvent(
                                  searchQuery: searchController.text,
                                ),
                              );
                        },
                        onChanged: (value) {
                          context.read<BookingBloc>().add(
                                UpdatePostedBookingSearchQueryEvent(
                                  searchQuery: value,
                                ),
                              );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              const ApplyFilterDialog(isPostedBooking: true),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              style: BorderStyle.solid),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.tune,
                          color: state.isFilterActive ? const Color(0xffF45858) : Colors.black,
                          size: 28,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<BookingBloc>()
                        .add(GetPostedBooingEvent(context: context));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: newBooking.length,
                    itemBuilder: (context, index) {
                      var newBookingData = newBooking[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailScreen(
                                bookingID: newBookingData.id.toString(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Header: ID and Status
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'ID : ${newBookingData.orderId} ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: newBookingData.isAssigned == '1' ? '(Assigned)' : '(Open)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: newBookingData.isAssigned == '1' ? Colors.blue : const Color(0xff45B129),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Date, Time and Trip Type
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${HelperFunctions.formatDate(newBookingData.pickUpDate)} ',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins'),
                                          ),
                                          const Text("@ ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                          Text(
                                            HelperFunctions.formatTo12Hour(
                                                newBookingData.pickUpTime
                                                    .toString()),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xffF45858),
                                                fontFamily: 'Poppins'),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        newBookingData.subTypeLabel ?? "",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3E4959),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xffF1F1F1)),
                                ),

                                /// Pickup and Destination with Fares
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 2),
                                          const Icon(Icons.location_on,
                                              size: 18,
                                              color: Color(0xffD47716)),
                                          SizedBox(
                                            width: 1,
                                            height: 20,
                                            child: CustomPaint(
                                                painter: DashLinePainter()),
                                          ),
                                          const Icon(Icons.location_on,
                                              size: 18,
                                              color: Color(0xffC51C1C)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 2),
                                            Text(
                                              newBookingData.pickUpLoc ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            const SizedBox(height: 18),
                                            if ((newBookingData.subTypeLabel ?? "").toLowerCase().contains('round'))
                                              const Text(
                                                'Round Trip',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFF45858),
                                                    fontFamily: 'Poppins'),
                                              )
                                            else
                                              Text(
                                                newBookingData.destinationLoc ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Poppins'),
                                              ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      /// Commission Box
                                      Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEFEFEF),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      '₹ ${newBookingData.totalFaire}',
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Poppins')),
                                                  const Text('Total Faire',
                                                      style: TextStyle(
                                                          fontSize: 7,
                                                          fontFamily:
                                                              'Poppins')),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffFCB117),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      '₹ ${newBookingData.driverCommission}',
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Poppins')),
                                                  const Text('Commission',
                                                      style: TextStyle(
                                                          fontSize: 7,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Poppins')),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Car Detail
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 15, 12, 0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        newBookingData.carImage ?? "",
                                        height: 40,
                                        width: 65,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/carMO.png",
                                          width: 65,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          (newBookingData.carCategory?.name ??
                                                  "SWIFT CELERIO WAGONR ALTO OR SIMILAR")
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF1D1E20),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                /// Extra Requirements
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 12, 15),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Extra Requirement : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Poppins'),
                                        ),
                                        TextSpan(
                                          text: newBookingData.remark ?? "N/A",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffF45858),
                                              fontFamily: 'Poppins'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Footer Buttons (Chat, Edit, Delete)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _actionButton(
                                          icon: "assets/images/chatNew.png",
                                          label: "Chat",
                                          color: const Color(0xffFCB117),
                                          onTap: () {
                                            ChatListingScreen.show(context, bookingId: newBookingData.id.toString());
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _actionButton(
                                          icon: "assets/images/pencil 1.png",
                                          label: "Edit",
                                          color: Colors.black,
                                          onTap: () {
                                            Nav.push(
                                                context, Routes.editBooking,
                                                extra: newBookingData);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _actionButton(
                                          label: "Delete",
                                          color: const Color(0xffF45858),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DeleteBookingDialog(
                                                      bookingId: newBookingData
                                                          .id
                                                          .toString()),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Share Button
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 12, 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      double total = double.tryParse(newBookingData.totalFaire ?? '0') ?? 0.0;
                                      double comm = double.tryParse(newBookingData.driverCommission ?? '0') ?? 0.0;
                                      HelperFunctions.shareBookingDetail(
                                        orderId: newBookingData.orderId ?? "",
                                        subTypeLabel: newBookingData.subTypeLabel ?? "",
                                        pickupLocation: newBookingData.pickUpLoc ?? "",
                                        dropLocation: newBookingData.destinationLoc ?? "",
                                        vehicleType: newBookingData.carCategory?.name ?? "",
                                        driverEarning: total - comm,
                                        pickupDate: newBookingData.pickUpDate ?? "",
                                        pickupTime: newBookingData.pickUpTime ?? "",
                                        remark: newBookingData.remark ?? "",
                                        tripNotes: newBookingData.tripNotes ?? "",
                                        noOfDays: newBookingData.noOfDays ?? "",
                                      );
                                    },
                                    child: Container(
                                      height: 44,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFCB117),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Share",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins')),
                                          const SizedBox(width: 10),
                                          Image.asset(
                                              "assets/images/paper-plane 1.png",
                                              height: 18,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _actionButton(
      {String? icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Image.asset(
                icon,
                height: 16,
                color: label == "Chat" ? const Color(0xffFCB117) : null,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteBookingDialog extends StatelessWidget {
  final String bookingId;

  const DeleteBookingDialog({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Delete Booking',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF3E4959),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure you want to delete this booking?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF3E4959),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff3E4959)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                        child: Text('Go back',
                            style: TextStyle(color: Color(0xff3E4959)))),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<BookingBloc>().add(DeleteBooingEvent(
                        context: context, bookingId: bookingId));
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                        child:
                            Text('Yes', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
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
