import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailModel {
  final bool status;
  final String message;
  final BookingData? data;
  final BookingSubDriverDetail? driverDetails;

  BookingDetailModel({
    required this.status,
    required this.message,
    this.data,
    this.driverDetails,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    
    return BookingDetailModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: dataJson != null ? BookingData.fromJson(dataJson) : null,
      driverDetails: json['driverDetails'] != null
          ? BookingSubDriverDetail.fromJson(json['driverDetails'])
          : (dataJson != null && dataJson['driver'] != null)
              ? BookingSubDriverDetail.fromJson(dataJson['driver'])
              : null,
    );
  }
}

class BookingData {
  final int id;
  final String orderId;
  final int driverId;
  final String creatorName;
  final String pickupLocation;
  final String dropLocation;
  final String pickupDate;
  final String pickupTime;
  final String vehicleType;
  final double totalAmount;
  final double driverCommission;
  final String remark;
  final String subTypeLabel;
  final String noOfDays;
  final String tripNotes;
  final String? _status;
  final String isAssigned;
  final String? creatorId;
  final String? pickUpCity;
  final String? destinationCity;
  final String? assignType;
  final String? creatorPhone;
  final String? driverPhone;
  final int? assignSubDriverId;
  final int? assignDriverId;

  BookingData({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.creatorName,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.vehicleType,
    required this.totalAmount,
    required this.driverCommission,
    required this.remark,
    required this.subTypeLabel,
    required this.noOfDays,
    required this.tripNotes,
    String? status,
    required this.isAssigned,
    this.creatorId,
    this.pickUpCity,
    this.destinationCity,
    this.assignType,
    this.carCategoryId,
    this.extra,
    this.isShowPhoneNumber,
    this.creatorPhone,
    this.driverPhone,
    this.assignSubDriverId,
    this.assignDriverId,
    this.carImage,
  }) : _status = status;

  final String? carCategoryId;
  final String? extra;
  final String? isShowPhoneNumber;
  final String? carImage;

  String get status => _status ?? '0';

  factory BookingData.fromJson(Map<String, dynamic> json) {
    debugPrint("🔍 BookingData.fromJson: assign_driver_id=${json['assign_driver_id']}, "
        "assign_subDriver_id=${json['assign_subDriver_id']}, "
        "user_id=${json['user_id']}, creator_id=${json['creator_id']}, "
        "driver_id=${json['driver_id']}");
    // NEW API MAPPINGS
    final String effectiveOrderId = json['bookingId']?.toString() ?? json['orderId']?.toString() ?? '';
    final String effectivePickupDate = json['pickup_date']?.toString() ?? json['pickUp_date']?.toString() ?? '';
    final String effectivePickupTime = json['pickup_time']?.toString() ?? json['pickUp_time']?.toString() ?? '';
    final String effectivePickupLoc = json['pickup_location']?.toString() ?? json['pickUpLoc']?.toString() ?? '';
    final String effectiveDropLoc = json['destination_location']?.toString() ?? json['destinationLoc']?.toString() ?? '';
    final double effectiveTotalFare = double.tryParse(json['total_fare']?.toString() ?? json['total_faire']?.toString() ?? '0') ?? 0.0;
    final double effectiveCommission = double.tryParse(json['driver_commission']?.toString() ?? json['driverCommission']?.toString() ?? '0') ?? 0.0;
    final String effectiveShowPhone = json['is_show_phone_number']?.toString() ?? json['is_show_phoneNumber']?.toString() ?? '0';
    final String effectiveSubTypeLabel = json['booking_type']?.toString() ?? json['sub_type_label']?.toString() ?? '';

    return BookingData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: effectiveOrderId,
      driverId: int.tryParse(json['driver_id']?.toString() ?? '0') ?? 0,
      creatorName: json['creator_name']?.toString() ??
          (json['driver'] != null ? json['driver']['name']?.toString() ?? '' : ''),
      pickupLocation: effectivePickupLoc,
      dropLocation: effectiveDropLoc,
      pickupDate: effectivePickupDate,
      pickupTime: effectivePickupTime,
      vehicleType: json['car_category'] != null
          ? json['car_category']['name']?.toString() ?? ''
          : (json['car_category_name']?.toString() ?? ''),
      totalAmount: effectiveTotalFare,
      driverCommission: effectiveCommission,
      remark: json['remark'] ?? '',
      subTypeLabel: effectiveSubTypeLabel,
      status: json['status']?.toString() ?? '0',
      isAssigned: json['is_assigned']?.toString() ?? '0',
      creatorId: json['user_id']?.toString() ?? json['creator_id']?.toString(),
      pickUpCity: json['pickUpCity']?.toString(),
      destinationCity: json['destinationCity']?.toString(),
      assignType: json['assignType']?.toString(),
      carCategoryId: (json['car_category_id'] ??
              json['carCategory_id'] ??
              (json['car_category'] != null ? json['car_category']['id'] : null))
          ?.toString(),
      noOfDays: json['no_of_days']?.toString() ?? '',
      tripNotes: json['trip_notes']?.toString() ?? '',
      extra: json['extra']?.toString(),
      isShowPhoneNumber: effectiveShowPhone,
      creatorPhone: json['creator_phone']?.toString() ??
          (json['driver'] != null ? json['driver']['phone']?.toString() ?? '' : ''),
      driverPhone: json['driver_phone']?.toString() ?? json['driver_number']?.toString(),
      assignSubDriverId: int.tryParse(json['assign_subDriver_id']?.toString() ?? ''),
      assignDriverId: int.tryParse(json['assign_driver_id']?.toString() ?? ''),
      carImage: json['car_image']?.toString() ??
          (json['car'] != null ? json['car']['image']?.toString() : null),
    );
  }

  DateTime? get pickupDateTime {
    try {
      if (pickupDate.isEmpty) return null;

      final List<String> dateFormats = [
        'yyyy-MM-dd',
        'dd-MM-yyyy',
        'dd/MM/yyyy',
        'MMM dd, yyyy',
        'MMMM dd, yyyy',
      ];

      final List<String> timeFormats = [
        'HH:mm:ss',
        'HH:mm',
        'hh:mm a',
        'h:mm a',
      ];

      DateTime? parsedDate;
      for (var fmt in dateFormats) {
        try {
          parsedDate = DateFormat(fmt).parse(pickupDate);
          break;
        } catch (_) {}
      }

      if (parsedDate == null) {
        // Fallback to manual parsing if intl fails
        String cleanDate =
            pickupDate.contains('T') ? pickupDate.split('T').first : pickupDate;
        cleanDate = cleanDate.replaceAll('/', '-');
        if (cleanDate.contains('-') && cleanDate.split('-').first.length < 3) {
          final parts = cleanDate.split('-');
          if (parts.length == 3) {
            cleanDate =
                "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
          }
        }
        parsedDate = DateTime.tryParse(cleanDate);
      }

      if (parsedDate == null) return null;

      DateTime? parsedTime;
      final timeToParse = pickupTime.isEmpty ? "00:00:00" : pickupTime;
      for (var fmt in timeFormats) {
        try {
          parsedTime = DateFormat(fmt).parse(timeToParse);
          break;
        } catch (_) {}
      }

      if (parsedTime != null) {
        return DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedTime.hour,
          parsedTime.minute,
          parsedTime.second,
        );
      } else {
        return parsedDate;
      }
    } catch (e) {
      debugPrint("❌ Error parsing pickupDateTime ($pickupDate $pickupTime): $e");
      return null;
    }
  }
}

class BookingSubDriverDetail {
  final int id;
  final int driverId;
  final String name;
  final String phoneNumber;
  final String driverImage;
  final String licenseNumber;
  final String cityName;
  final String address;
  final String dlFrontImage;
  final String dlBackImage;
  final String aadharFrontImage;
  final String aadharBackImage;
  final double rating;
  final int reviewCount;

  BookingSubDriverDetail({
    required this.id,
    required this.driverId,
    required this.name,
    required this.phoneNumber,
    required this.driverImage,
    required this.licenseNumber,
    required this.cityName,
    required this.address,
    required this.dlFrontImage,
    required this.dlBackImage,
    required this.aadharFrontImage,
    required this.aadharBackImage,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory BookingSubDriverDetail.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['driver_image_url']?.toString();
    if (imageUrl == null || imageUrl.isEmpty) {
      imageUrl = json['driver_image']?.toString() ?? json['image']?.toString();
    }

    return BookingSubDriverDetail(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 
          int.tryParse(json['driver_id']?.toString() ?? '0') ?? 0,
      driverId: int.tryParse(json['driver_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      phoneNumber:
          json['phone_number']?.toString() ?? json['phone']?.toString() ?? '',
      driverImage: imageUrl ?? '',
      licenseNumber: json['license_number']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      dlFrontImage: json['dl_frontImage_url']?.toString() ?? '',
      dlBackImage: json['dl_backImage_url']?.toString() ?? '',
      aadharFrontImage: json['aadhar_frontImage_url']?.toString() ?? '',
      aadharBackImage: json['aadhar_backImage_url']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 5.0,
      reviewCount: int.tryParse(json['review_count']?.toString() ?? '0') ?? 0,
    );
  }
}
