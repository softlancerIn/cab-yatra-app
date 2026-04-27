import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/transections_bloc.dart';
import '../bloc/transections_event.dart';
import '../bloc/transections_state.dart';

class TransectionScreen extends StatefulWidget {
  const TransectionScreen({super.key});

  @override
  State<TransectionScreen> createState() => _TransectionScreenState();
}

class _TransectionScreenState extends State<TransectionScreen> {
  final List<String> statusList = [
    "Success",
    "Processing",
    "Paused",
    "Refunded",
    "Cancelled",
    "Failed",
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Success":
        return const Color(0xff4CAF50);
      case "Processing":
        return const Color(0xff81C784);
      case "Paused":
        return const Color(0xffFFA726);
      case "Refunded":
        return const Color(0xffA1887F);
      case "Cancelled":
        return const Color(0xffE57373);
      case "Failed":
        return const Color(0xffF44336);
      default:
        return Colors.grey;
    }
  }

  Color getStatusBg(String status) {
    switch (status) {
      case "Success":
        return const Color(0xffE8F5E9);
      case "Processing":
        return const Color(0xffE8F5E9);
      case "Paused":
        return const Color(0xffFFF3E0);
      case "Refunded":
        return const Color(0xffEFEBE9);
      case "Cancelled":
        return const Color(0xffFFEBEE);
      case "Failed":
        return const Color(0xffFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  String formatDay(String? dateStr) {
    if (dateStr == null) return "04";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd').format(dt);
    } catch (e) {
      return "04";
    }
  }

  String formatMonthYear(String? dateStr) {
    if (dateStr == null) return "Jan,2026";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('MMM,yyyy').format(dt);
    } catch (e) {
      return "Jan,2026";
    }
  }

  String formatTime(String? dateStr) {
    if (dateStr == null) return "10:21 Pm";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return "10:21 Pm";
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TransectionsBloc>().add(LoadTransections(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBAR(
        title: "Transections",
        showLeading: true,
        showAction: false,
      ),
      body: BlocBuilder<TransectionsBloc, TransectionsState>(
          builder: (context, state) {
        if (state.getTransectionModel == null ||
            state.getTransectionModel!.data == null) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("Initializing..."));
        }

        if (state.getTransectionModel!.data!.isEmpty) {
          return const Center(
              child: Text("No Data Found",
                  style: TextStyle(fontFamily: 'Poppins')));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: state.getTransectionModel!.data!.length,
          itemBuilder: (context, index) {
            final transection = state.getTransectionModel!.data![index];
            final rawStatus = transection.status?.toString() ?? "Processing";
            final status = rawStatus.isEmpty 
                ? "Processing" 
                : "${rawStatus[0].toUpperCase()}${rawStatus.substring(1).toLowerCase()}";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT DATE BOX
                  Container(
                    width: 75,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff3F4A5A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatDay(transection.createdAt),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          formatMonthYear(transection.createdAt),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatTime(transection.createdAt),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// RIGHT CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ID + STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "#ID: ${transection.bookingId} (Posted Booking)",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: getStatusBg(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: getStatusColor(status),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _rowText(
                            "Booking Amount:", "₹${transection.bookingAmount}"),
                        _rowText("Commission Paid by Driver:",
                            "₹${transection.commission}"),
                        _rowText("Platform Charges:",
                            "₹${transection.platformCharge}"),

                        const SizedBox(height: 4),
                        const Divider(height: 1, thickness: 0.5),
                        const SizedBox(height: 6),

                        _rowText(
                            "Your Earning:", "₹${transection.driverEarning}",
                            isBold: true, valueColor: Colors.black),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _rowText(String title, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: valueColor ?? Colors.grey.shade800,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
