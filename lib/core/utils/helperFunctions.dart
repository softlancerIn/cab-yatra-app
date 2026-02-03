import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/home_model.dart';


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
      return currentDateTime.isAfter(pickUpDateTime) || currentDateTime.isAtSameMomentAs(pickUpDateTime);
    } catch (e) {
      print('Error parsing date or time: $e');
      return false;
    }
  }


  static void makePhoneCall(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No contact found')),
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
        "📅 *Pickup Date:* $picDate\n"
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
}

