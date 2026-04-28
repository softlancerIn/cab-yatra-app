import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Pages/Payment Method/repo/paymentRepo.dart';
import '../../app/router/navigation/nav.dart';
import '../../app/router/navigation/routes.dart';

class HelperFunctions {
  static bool isPickupTime(String? pickupDate, String? pickUpTime) {
    if (pickupDate == null || pickUpTime == null) {
      return false;
    }
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
      final String combinedDateTimeString = '$pickupDate $pickUpTime';
      final DateTime currentDateTime = DateTime.now();
      final DateTime pickUpDateTime = dateFormat.parse(combinedDateTimeString);
      return currentDateTime.isAfter(pickUpDateTime) ||
          currentDateTime.isAtSameMomentAs(pickUpDateTime);
    } catch (e) {
      print('Error parsing date or time: $e');
      return false;
    }
  }

  static void makePhoneCall(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contact found')),
      );
      return;
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        print('Could not launch $launchUri');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  static Future<void> shareMessage(
    String bookingId,
    String picDate,
    String picLoc,
    String dropLoc,
    String? vehicle,
    String bookingType,
    String? bookingAmount,
    String? commission,
    String? extraRequirement,
    // String? bookingPostedBy,
    String contactNumber,
  ) async {
    String message = "🌟 *Cab Yatra Partners* 🌟\n\n"
        "📋 *Booking Details:* \n"
        "---------------------------------\n"
        "🆔 *Booking ID:* $bookingId\n"
        "📅 *Pickup Date:* ${formatDate(picDate)}\n"
        "📍 *Pickup Location:* $picLoc\n"
        "📍 *Drop Location:* $dropLoc\n"
        "💰 *Driver Commission:* ${commission ?? 'N/A'}\n"
        "💳 *Booking Amount:* ${bookingAmount ?? 'N/A'}\n"
        "🔖 *Vehicle:* ${vehicle ?? 'N/A'}\n"
        "📅 *Booking Type:* $bookingType\n"
        "📝 *Extra Requirements:* ${extraRequirement ?? 'None'}\n"
        // "👤 *Posted By:* ${bookingPostedBy ?? 'Anonymous'}\n"
        "📞 *Contact Number:* $contactNumber\n"
        "---------------------------------\n"
        "Thank you for choosing Cab Yatra!";

    await Share.share(message);
  }

  static void shareBookingDetail({
    required String orderId,
    required String subTypeLabel,
    required String pickupLocation,
    required String dropLocation,
    required String vehicleType,
    required double driverEarning,
    required String pickupDate,
    required String pickupTime,
    required String remark,
    required String tripNotes,
    required String noOfDays,
  }) {
    String message = "✨ *New Booking Assigned* ✨\n\n"
        "🆔 *Booking ID:* $orderId\n"
        "📈 *Type:* $subTypeLabel\n\n"
        "*Pickup:* $pickupLocation\n";

    message += "*Drop:* $dropLocation\n\n"
        "*Cab:* $vehicleType\n"
        "*-Driver earning ₹${driverEarning.toStringAsFixed(0)} Inclusive All*\n\n"
        "*Call:* 7011873145\n\n"
        "*Dated&time -* ${formatDate(pickupDate)} @ $pickupTime\n\n";

    if (noOfDays.isNotEmpty) {
      message += "*No. of Days:* $noOfDays\n\n";
    }

    if (tripNotes.isNotEmpty) {
      message += "*Trip Notes:* $tripNotes\n\n";
    } else if (remark.isNotEmpty) {
      message += "*Remark:* $remark\n\n";
    }

    message += "---------------------------------\n"
        "Contact for more details. 📞";

    Share.share(message);
  }

  static Future<void> navigateToMap(String pickup, [String? drop]) async {
    try {
      final String origin = Uri.encodeComponent(pickup);
      String googleMapsUrl;

      if (drop != null && drop.isNotEmpty) {
        final String destination = Uri.encodeComponent(drop);
        googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving";
      } else {
        googleMapsUrl =
            "https://www.google.com/maps/search/?api=1&query=$origin";
      }

      final Uri uri = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e) {
      debugPrint("Error launching maps: $e");
    }
  }

  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "";
    try {
      // Try parsing common formats. If it's already formatted, return as is.
      if (dateString.contains(",") && dateString.split(" ").length >= 3) {
        return dateString;
      }

      DateTime dateTime;
      if (dateString.contains("-")) {
        dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
      } else if (dateString.contains("/")) {
        dateTime = DateFormat('dd/MM/yyyy').parse(dateString);
      } else {
        // Fallback for simple yyyyMMdd or similar
        dateTime = DateTime.parse(dateString);
      }
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  static String formatBookingDate(String dateString, String timeString) {
    if (dateString.isEmpty) return "";
    try {
      DateTime bookingDate;
      if (dateString.contains("-")) {
        bookingDate = DateFormat('yyyy-MM-dd').parse(dateString);
      } else if (dateString.contains("/")) {
        bookingDate = DateFormat('dd/MM/yyyy').parse(dateString);
      } else if (dateString.contains(",")) {
        bookingDate = DateFormat('MMM dd, yyyy').parse(dateString);
      } else {
        bookingDate = DateTime.parse(dateString);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final target =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

      String formattedTime = formatTo12Hour(timeString);

      if (target == today) {
        return "Today@$formattedTime";
      } else if (target == tomorrow) {
        return "Tomorrow@$formattedTime";
      } else {
        String formattedDate =
            DateFormat('MMM dd, yyyy').format(bookingDate).toUpperCase();
        return "$formattedDate@$formattedTime";
      }
    } catch (e) {
      return "$dateString @ $timeString";
    }
  }

  static String formatTo12Hour(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "";
    try {
      if (timeString.contains("AM") || timeString.contains("PM"))
        return timeString;

      List<String> parts = timeString.split(':');
      if (parts.length < 2) return timeString;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final dt = DateTime(0, 0, 0, hour, minute);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return timeString;
    }
  }

  static String formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return "Just now";
    DateTime dateTime;
    try {
      if (timestamp is DateTime) {
        dateTime = timestamp;
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return "Just now";
      }

      final Duration diff = DateTime.now().difference(dateTime);

      if (diff.inSeconds < 60) {
        return "Just now";
      } else if (diff.inMinutes < 60) {
        return "${diff.inMinutes} min ago";
      } else if (diff.inHours < 24) {
        return "${diff.inHours} hr ago";
      } else if (diff.inDays < 7) {
        return "${diff.inDays} days ago";
      } else {
        return DateFormat('MMM d, yyyy').format(dateTime);
      }
    } catch (e) {
      return "Just now";
    }
  }

  static String getValidImageUrl(String? url,
      {String fallback = "https://cabyatra.com/assets/images/user.png"}) {
    if (url == null ||
        url.isEmpty ||
        url.trim() == "null" ||
        url.startsWith("file:///")) {
      return fallback;
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return fallback;
  }

  static Future<bool> validatePaymentDetails(BuildContext context) async {
    try {
      final paymentRepo = PaymentRepo();
      final res = await paymentRepo.getPaymentApi();

      final bool hasDetails = res.data?.any((p) {
            final bName = p.bankName?.trim() ?? "";
            final uId = p.upiId?.trim() ?? "";
            return bName.isNotEmpty || uId.isNotEmpty;
          }) ??
          false;

      if (!hasDetails) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Payment Details Required",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text(
                  "Please add your Bank Details or UPI ID in Profile > Payment Method before proceeding with this booking."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Nav.push(context, Routes.paymentMethod);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFCB117)),
                  child: const Text("Add Now",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error validating payment details: $e");
      return true; // Allow proceeding if API check fails to avoid blocking users
    }
  }
}
