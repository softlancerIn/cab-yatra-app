import 'package:flutter/material.dart';
import '../../bookingDetails/model/bookingDetailModel.dart';
import '../../../cores/utils/helperFunctions.dart';

class RequestCommissionScreen extends StatefulWidget {
  final BookingData bookingData;
  final String agencyName;
  final Function(num editedAmount, num editedCommission) onSubmit;

  const RequestCommissionScreen({
    super.key,
    required this.bookingData,
    required this.agencyName,
    required this.onSubmit,
  });

  @override
  State<RequestCommissionScreen> createState() => _RequestCommissionScreenState();
}

class _RequestCommissionScreenState extends State<RequestCommissionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _commissionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.bookingData.totalAmount.toStringAsFixed(0));
    _commissionController = TextEditingController(
        text: widget.bookingData.driverCommission.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '0':
        return 'open';
      case '1':
        return 'assigned';
      case '2':
        return 'completed';
      case '3':
        return 'cancelled';
      case '4':
        return 'picked up';
      default:
        return status ?? '';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case '0':
        return const Color(0xff45B129);
      case '1':
        return const Color(0xffFCB117);
      case '2':
        return const Color(0xff45B129);
      case '3':
        return const Color(0xffF45858);
      case '4':
        return Colors.blue;
      default:
        return const Color(0xff45B129);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.bookingData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.agencyName,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Poppins'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top detail row
                    Row(
                      children: [
                        Text(
                          "ID : ${data.orderId}",
                          style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(${_getStatusText(data.status)})",
                          style: TextStyle(
                              color: _getStatusColor(data.status),
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${HelperFunctions.formatDate(data.pickupDate)} @${HelperFunctions.formatTo12Hour(data.pickupTime)}",
                          style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          data.subTypeLabel,
                          style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                    const SizedBox(height: 12),
                    // Timeline
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 2),
                            const Icon(Icons.circle, color: Colors.orange, size: 16),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade400,
                            ),
                            const Icon(Icons.circle, color: Colors.red, size: 16),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (data.pickUpCity ?? "").isNotEmpty
                                    ? data.pickUpCity!
                                    : data.pickupLocation,
                                style: const TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    fontFamily: 'Poppins'),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                data.subTypeLabel == "Round Trip"
                                    ? "Round Trip..."
                                    : ((data.destinationCity ?? "").isNotEmpty
                                        ? data.destinationCity!
                                        : data.dropLocation),
                                style: const TextStyle(
                                    color: Color(0xFF2C3E50),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.share, color: Colors.black, size: 22),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Car Details
                    Row(
                      children: [
                        Image.asset("assets/images/appbar_car.png", width: 50),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data.vehicleType,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Trip Notes
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Trip Note : ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Poppins'),
                        ),
                        Expanded(
                          child: Text(
                            data.tripNotes.isNotEmpty ? data.tripNotes : "N/A",
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Enter booking amount and total commission",
                      style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 12),
                    // Textfields
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final strAmount = _amountController.text.replaceAll(',', '').trim();
                  final strCommission = _commissionController.text.replaceAll(',', '').trim();
                  num parsedAmount = num.tryParse(strAmount) ?? widget.bookingData.totalAmount;
                  num parsedCommission = num.tryParse(strCommission) ?? 0;
                  widget.onSubmit(parsedAmount, parsedCommission);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Send Commission request",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
