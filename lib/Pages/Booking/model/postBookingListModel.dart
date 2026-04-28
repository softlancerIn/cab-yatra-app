import 'package:intl/intl.dart';

class PostedBookingModel {
  bool? status;
  String? message;
  List<SeeBookingData>? data;

  PostedBookingModel({this.status, this.message, this.data});

  PostedBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SeeBookingData>[];
      json['data'].forEach((v) {
        data!.add(SeeBookingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeeBookingData {
  int? id;
  String? orderId;
  int? driverId;
  String? userId;
  String? subType;
  String? carCategoryId;
  String? pickUpDate;
  String? pickUpTime;
  // String? booking_type;
  String? pickUpLoc;
  String? destinationLoc;
  String? totalFaire;
  String? driverCommission;
  String? isShowPhoneNumber;
  String? isDriverCreateBooking;
  String? isAssigned;
  String? status;
  String? remark;
  String? extra;
  String? noOfDays;
  String? tripNotes;
  String? typeLabel;
  String? subTypeLabel;
  String? isAirportLabel;
  String? carImage;
  String? carCategoryName;
  String? pickUpCity;
  String? destinationCity;
  CarCategory? carCategory;
  String? assignType;
  int? assignDriverId;
  AssignDriver? assignDriver;
  String? driverNumber;

  SeeBookingData(
      {this.id,
      this.orderId,
      this.driverId,
      this.userId,
      this.subType,
      this.carCategoryId,
      this.pickUpDate,
      this.pickUpTime,
      // this.booking_type,
      this.pickUpLoc,
      this.destinationLoc,
      this.totalFaire,
      this.driverCommission,
      this.isShowPhoneNumber,
      this.isDriverCreateBooking,
      this.isAssigned,
      this.status,
      this.remark,
      this.extra,
      this.noOfDays,
      this.tripNotes,
      this.typeLabel,
      this.subTypeLabel,
      this.isAirportLabel,
      this.carImage,
      this.carCategoryName,
      this.pickUpCity,
      this.destinationCity,
      this.carCategory,
      this.assignType,
      this.assignDriverId,
      this.assignDriver,
      this.driverNumber});

  SeeBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    driverId = json['driver_id'];
    userId = json['user_id']?.toString() ?? json['creator_id']?.toString();
    subType = json['subType'];
    carCategoryId = json['carCategory_id']?.toString();
    pickUpDate = json['pickUp_date'];
    pickUpTime = json['pickUp_time'];
    // booking_type = json['booking_type'];
    pickUpLoc = json['pickUpLoc'];
    destinationLoc = json['destinationLoc'];
    totalFaire = json['total_faire'];
    driverCommission = json['driverCommission'];
    isShowPhoneNumber = json['is_show_phoneNumber'];
    isDriverCreateBooking = json['is_driver_createBooking'];
    isAssigned = json['is_assigned']?.toString();
    status = json['status']?.toString();
    remark = json['remark'];
    extra = json['extra'];
    noOfDays = json['no_of_days']?.toString();
    tripNotes = json['trip_notes']?.toString();
    typeLabel = json['type_label'];
    subTypeLabel = json['sub_type_label'];
    isAirportLabel = json['is_airport_label'];
    carImage = json['car_image'];
    pickUpCity = json['pickUpCity'];
    destinationCity = json['destinationCity'];
    carCategory = json['car_category'] != null
        ? CarCategory.fromJson(json['car_category'])
        : null;
    assignDriver = json['assign_driver'] != null
        ? AssignDriver.fromJson(json['assign_driver'])
        : null;
    assignDriverId = int.tryParse(json['assign_driver_id']?.toString() ?? '');
    if (assignDriverId == null || assignDriverId == 0) {
      assignDriverId = assignDriver?.id;
    }
    
    // NEW API MAPPINGS
    if (json.containsKey('bookingId')) orderId = json['bookingId'];
    if (json.containsKey('pickup_date')) pickUpDate = json['pickup_date'];
    if (json.containsKey('pickup_time')) pickUpTime = json['pickup_time'];
    if (json.containsKey('pickup_location')) pickUpLoc = json['pickup_location'];
    if (json.containsKey('destination_location')) destinationLoc = json['destination_location'];
    if (json.containsKey('total_fare')) totalFaire = json['total_fare'];
    if (json.containsKey('driver_commission')) driverCommission = json['driver_commission'];
    if (json.containsKey('is_show_phone_number')) isShowPhoneNumber = json['is_show_phone_number'];
    if (json.containsKey('booking_type')) subTypeLabel = json['booking_type'];
    if (json.containsKey('assignType')) assignType = json['assignType']; // We might need to add this field or map to isAssigned
    if (json.containsKey('driver_number')) driverNumber = json['driver_number'];
    if (json.containsKey('car_category_id')) carCategoryId = json['car_category_id']?.toString();
    if (json.containsKey('car_category_name')) {
       carCategoryName = json['car_category_name']?.toString();
       carCategory ??= CarCategory(name: carCategoryName);
    }
    if (carCategoryId == null || carCategoryId!.isEmpty) {
      carCategoryId = carCategory?.id?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['driver_id'] = driverId;
    data['user_id'] = userId;
    data['subType'] = subType;
    data['carCategory_id'] = carCategoryId;
    data['pickUp_date'] = pickUpDate;
    data['pickUp_time'] = pickUpTime;
    // data['booking_type'] = this.booking_type;
    data['pickUpLoc'] = pickUpLoc;
    data['destinationLoc'] = destinationLoc;
    data['total_faire'] = totalFaire;
    data['driverCommission'] = driverCommission;
    data['is_show_phoneNumber'] = isShowPhoneNumber;
    data['is_driver_createBooking'] = isDriverCreateBooking;
    data['is_assigned'] = isAssigned;
    data['status'] = status;
    data['remark'] = remark;
    data['extra'] = extra;
    data['no_of_days'] = noOfDays;
    data['trip_notes'] = tripNotes;
    data['type_label'] = typeLabel;
    data['sub_type_label'] = subTypeLabel;
    data['is_airport_label'] = isAirportLabel;
    data['car_image'] = carImage;
    data['pickUpCity'] = pickUpCity;
    data['destinationCity'] = destinationCity;
    if (carCategory != null) {
      data['car_category'] = carCategory!.toJson();
    }
    data['assign_driver_id'] = assignDriverId;
    if (assignDriver != null) {
      data['assign_driver'] = assignDriver!.toJson();
    }
    data['driver_number'] = driverNumber;
    return data;
  }

  DateTime? get pickupDateTime {
    try {
      if (pickUpDate == null || pickUpDate!.isEmpty) return null;
      
      // Try formats: "Apr 24, 2026 04:09 PM", "yyyy-MM-dd HH:mm", "dd-MM-yyyy HH:mm"
      final List<String> formats = [
        "MMM dd, yyyy hh:mm a",
        "yyyy-MM-dd HH:mm",
        "dd-MM-yyyy HH:mm",
        "yyyy-MM-dd hh:mm a",
        "dd-MM-yyyy hh:mm a"
      ];

      for (String format in formats) {
        try {
          return DateFormat(format).parse("$pickUpDate $pickUpTime");
        } catch (_) {}
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class CarCategory {
  int? id;
  String? name;

  CarCategory({this.id, this.name});

  CarCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class AssignDriver {
  int? id;
  String? name;
  String? driverImageUrl;
  String? aadharFrontImageUrl;
  String? aadharBackImageUrl;
  String? dlImageUrl;

  AssignDriver({
    this.id,
    this.name,
    this.driverImageUrl,
    this.aadharFrontImageUrl,
    this.aadharBackImageUrl,
    this.dlImageUrl,
  });

  AssignDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    driverImageUrl = json['driver_image_url'];
    aadharFrontImageUrl = json['aadhar_frontImage_url'];
    aadharBackImageUrl = json['aadhar_backImage_url'];
    dlImageUrl = json['dl_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['driver_image_url'] = driverImageUrl;
    data['aadhar_frontImage_url'] = aadharFrontImageUrl;
    data['aadhar_backImage_url'] = aadharBackImageUrl;
    data['dl_image_url'] = dlImageUrl;
    return data;
  }
}
