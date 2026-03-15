import 'package:cab_taxi_app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/custom_app_bar.dart';

class BookingTransactionsScreen extends StatelessWidget {
  const BookingTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Transactions",
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionCard(data: transactions[index]);
        },
      ),
    );
  }
}

/// Transaction Card Widget
class TransactionCard extends StatelessWidget {
  final TransactionModel data;

  const TransactionCard({super.key, required this.data});

  Color getStatusColor() {
    switch (data.status) {
      case "Success":
        return Colors.green;
      case "Processing":
        return Colors.orange;
      case "Paused":
        return Colors.amber;
      case "Refunded":
        return Colors.blueGrey;
      case "Canceled":
        return Colors.redAccent;
      case "Failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [

          /// Date Box
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2F3A4A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.monthYear,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
                Text(
                  data.time,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "#ID: ${data.id}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.status,
                        style: TextStyle(
                          color: getStatusColor(),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                _row("Booking Amount:", data.bookingAmount),
                _row("Commission Paid by Driver:", data.commission),
                _row("Platform Charges:", data.platformCharges),

                const SizedBox(height: 4),

                _rowBold("Your Earnings:", data.earnings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _rowBold(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// Model
class TransactionModel {
  final String id;
  final String date;
  final String monthYear;
  final String time;
  final String bookingAmount;
  final String commission;
  final String platformCharges;
  final String earnings;
  final String status;

  TransactionModel({
    required this.id,
    required this.date,
    required this.monthYear,
    required this.time,
    required this.bookingAmount,
    required this.commission,
    required this.platformCharges,
    required this.earnings,
    required this.status,
  });
}

/// Dummy Data
List<TransactionModel> transactions = [
  TransactionModel(
    id: "245268",
    date: "04",
    monthYear: "Jan,2026",
    time: "10:21 PM",
    bookingAmount: "₹15000.0",
    commission: "₹1000.0",
    platformCharges: "₹36.5",
    earnings: "₹9967.7",
    status: "Success",
  ),
  TransactionModel(
    id: "245269",
    date: "04",
    monthYear: "Jan,2026",
    time: "10:22 PM",
    bookingAmount: "₹15000.0",
    commission: "₹1000.0",
    platformCharges: "₹36.5",
    earnings: "₹9967.7",
    status: "Processing",
  ),
  TransactionModel(
    id: "245270",
    date: "04",
    monthYear: "Jan,2026",
    time: "10:23 PM",
    bookingAmount: "₹15000.0",
    commission: "₹1000.0",
    platformCharges: "₹36.5",
    earnings: "₹9967.7",
    status: "Failed",
  ),
];
