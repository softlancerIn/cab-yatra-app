import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';

import 'package:cab_taxi_app/Pages/bookingDetails/bloc/bookingDetailsEvent.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import '../bloc/bookingDetailsBloc.dart';
import '../bloc/bookingDetailsState.dart';
import 'driverInfoCard.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingID;

  const BookingDetailScreen({super.key, required this.bookingID});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  // late PaymentService _paymentService;

  @override
  void initState() {
    // _paymentService = PaymentService();
    super.initState();
    context.read<BookingDetailBloc>().add(
        GetBookingDetailEvent(context: context, bookingId: widget.bookingID));
  }

  @override
  void dispose() {
    // _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        title: "Booking Details",
        showLeading: true,
        actionWidget: IconButton(
          onPressed: () {
            final state = context.read<BookingDetailBloc>().state;
            final data = state.bookingDetailModel?.data;
            if (data != null) {
              HelperFunctions.shareBookingDetail(
                orderId: data.orderId,
                subTypeLabel: data.subTypeLabel,
                pickupLocation: data.pickupLocation,
                dropLocation: data.dropLocation,
                vehicleType: data.vehicleType,
                driverEarning: data.totalAmount - data.driverCommission,
                pickupDate: data.pickupDate,
                pickupTime: data.pickupTime,
                remark: data.remark,
                tripNotes: data.tripNotes,
                noOfDays: data.noOfDays,
              );
            }
          },
          icon: const Icon(Icons.share, color: Colors.black, size: 22),
        ),
      ),
      body: BlocBuilder<BookingDetailBloc, BookingDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Error: ${state.errorMessage}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final data = state.bookingDetailModel?.data;

          if (data == null) {
            return const Center(child: Text("No booking details found."));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                              children: [
                                const TextSpan(
                                  text: 'ID : ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '${data.orderId} ',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: 'Assigned to ',
                                  style: TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Mukesh Kushwaha', // Placeholder or from data
                                  style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12,bottom: 10,top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${HelperFunctions.formatDate(data.pickupDate)} @${HelperFunctions.formatTo12Hour(data.pickupTime)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data.subTypeLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E4959),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(
                            height: 1, thickness: 1, color: Color(0xFF2196F3)),

                        /// Route: Pickup & Drop
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  data.subTypeLabel == 'Round Trip'
                                      ? const Icon(Icons.sticky_note_2,
                                          size: 18, color: Color(0xFF4CAF50))
                                      : const Icon(Icons.location_on,
                                          size: 18, color: Color(0xFFC51C1C)),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.pickupLocation,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                            GestureDetector(
                                              onTap: () {
                                                HelperFunctions.navigateToMap(
                                                  data.pickupLocation,
                                                  data.dropLocation,
                                                );
                                              },
                                              child: const Icon(Icons.near_me,
                                                  color: Color(0xFF2196F3),
                                                  size: 20),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 28),
                                      if (data.subTypeLabel == 'Round Trip') ...[
                                        Text(
                                          'Trip Notes: ${data.tripNotes.isNotEmpty ? data.tripNotes : "No notes"}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF4CAF50)),
                                        ),
                                      ] else ...[
                                        Text(
                                          data.dropLocation,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Vehicle/Category Info
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Image.asset("assets/images/carMO.png",
                                  height: 30),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data.vehicleType,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Remark
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                              children: [
                                const TextSpan(
                                  text: 'Trip Note : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: data.tripNotes.isNotEmpty
                                      ? data.tripNotes
                                      : "No notes provided",
                                  style: const TextStyle(
                                      color: Color(0xFFF45858),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Fares/Statistics
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _priceBox("₹${data.totalAmount}", "Total Amount"),
                              const SizedBox(width: 8),
                              _priceBox(
                                  "₹${data.totalAmount - data.driverCommission}",
                                  "Driver's Earning",
                                  isEarning: true),
                              const SizedBox(width: 8),
                              _priceBox(
                                  "₹${data.driverCommission}", "Commission"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Nav.push(context, Routes.reviewScreen, extra: {
                        'bookingId': widget.bookingID,
                      });
                    },
                    child: const DriverInfoCard(
                      imagePath:
                          'https://img.freepik.com/premium-vector/blue-car-flat-style-illustration-isolated-white-background_108231-795.jpg?semt=ais_hybrid&w=740&q=80',
                      name: 'Assigned Driver',
                      subtitle: 'Verification in progress',
                      rating: 5,
                      reviewCount: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15,bottom: 40,top: 16),
        child: CommonAppButton(
          text: "Chat",
          assetIcon: "assets/images/chatNew.png",
          backgroundColor: const Color(0xffFCB117),
          onPressed: () {
            Nav.push(context, Routes.chatScreen, extra: {
              'bookingId': widget.bookingID,
              'userName': 'Chat',
              'creatorName': 'Guddu',
              'receiverId': '0',
            });
          },
        ),
      ),
    );
  }

  Widget _priceBox(String amount, String label, {bool isEarning = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
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
