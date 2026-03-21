import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> navigateToMap(String pickup, String drop) async {
    try {
      final String origin = Uri.encodeComponent(pickup);
      final String destination = Uri.encodeComponent(drop);
      final String googleMapsUrl =
          "https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving";

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

  static String formatTo12Hour(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "";
    try {
      if (timeString.contains("AM") || timeString.contains("PM")) return timeString;

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
}
