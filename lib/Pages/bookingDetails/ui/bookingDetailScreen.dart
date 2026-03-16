import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';

import 'package:cab_taxi_app/Pages/bookingDetails/bloc/bookingDetailsEvent.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: const AppBAR(
        title: "Booking Details",
        showLeading: true,
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
                        /// ID Header
                        Padding(
                          padding: const EdgeInsets.all(12),
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
                                  text: data.orderId,
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(
                            height: 1, thickness: 0.5, color: Colors.grey),

                        /// Date, Time and Trip Type
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      color: Colors.black),
                                  children: [
                                    TextSpan(text: '${data.pickupDate} '),
                                    const TextSpan(
                                        text: '@',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                      text: data.pickupTime,
                                      style: const TextStyle(
                                          color: Color(0xFFF45858),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
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

                        /// Route: Pickup & Drop
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.circle,
                                      size: 14, color: Colors.orange),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.grey.shade300,
                                  ),
                                  const Icon(Icons.circle,
                                      size: 14, color: Color(0xFFC51C1C)),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                      data.pickupLocation,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 28),
                                    Text(
                                      data.dropLocation,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
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
                              horizontal: 12, vertical: 4),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: 'Poppins'),
                              children: [
                                const TextSpan(
                                  text: 'Extra Requirement: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: data.remark.isNotEmpty
                                      ? data.remark
                                      : "No remarks provided",
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

                  /// Driver Info (Safe Check)
                  // The current API response doesn't include driver info for this specific booking,
                  // so we show it only if available or a placeholder.
                  const DriverInfoCard(
                    imagePath:
                        'https://img.freepik.com/premium-vector/blue-car-flat-style-illustration-isolated-white-background_108231-795.jpg?semt=ais_hybrid&w=740&q=80',
                    name: 'Assigned Driver',
                    subtitle: 'Verification in progress',
                    rating: 5,
                    reviewCount: 0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CommonAppButton(
          text: "Chat",
          onPressed: () {
            Nav.push(context, Routes.chatListing);
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
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isEarning ? const Color(0xFFF45858) : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
