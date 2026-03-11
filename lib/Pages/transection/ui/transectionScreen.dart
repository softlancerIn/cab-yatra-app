import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        return Colors.green;
      case "Processing":
        return Colors.green.shade300;
      case "Paused":
        return Colors.orange;
      case "Refunded":
        return Colors.amber;
      case "Cancelled":
        return Colors.red.shade300;
      case "Failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getStatusBg(String status) {
    return getStatusColor(status).withOpacity(.15);
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
        customShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 2),
            ),
        ],
        showLeading: true,
        showAction: false,
      ),
      body: BlocConsumer<TransectionsBloc, TransectionsState>(
          listener: (context, state) {
        // Keep only success message + debug prints here
        // if (state.success) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Payment Saved Successfully")),
        //   );
        // }

        // Keep your debug prints...
        print("======== PAYMENT STATE ========");

        // ... rest of your prints
      }, builder: (context, state) {
        // ── Get first payment (safe access) ──
        if (state.getTransectionModel == null ||
            state.getTransectionModel!.data == null) {
          return const CircularProgressIndicator();
        }
        if (state.getTransectionModel!.data!.isEmpty) {
          return const Center(child: Text("No Data Found"));
        }

        // ── Prefill ONLY if controllers are still empty ──

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: state.getTransectionModel!.data!.length,
          itemBuilder: (context, index) {
            final transection = state.getTransectionModel!.data![index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT DATE BOX
                  Container(
                    width: 85,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xff3F4A5A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Text("04",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 4),
                        Text("Jan,2026",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 4),
                        Text("10:21 Pm",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// RIGHT CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ID + STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "#ID: ${transection.bookingId} ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: getStatusBg(statusList[index]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusList[index],
                                style: TextStyle(
                                  color: getStatusColor(statusList[index]),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
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
                            "₹${transection.plateformCharge}"),

                        const SizedBox(height: 6),

                        _rowText(
                            "Your Earning:", "₹${transection.driverEarning}",
                            isBold: true),
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

  Widget _rowText(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
