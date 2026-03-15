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
  String? remark;
  String? typeLabel;
  String? subTypeLabel;
  String? isAirportLabel;
  String? carImage;
  CarCategory? carCategory;

  SeeBookingData(
      {this.id,
      this.orderId,
      this.driverId,
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
      this.remark,
      this.typeLabel,
      this.subTypeLabel,
      this.isAirportLabel,
      this.carImage,
      this.carCategory});

  SeeBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    driverId = json['driver_id'];
    subType = json['subType'];
    carCategoryId = json['carCategory_id'];
    pickUpDate = json['pickUp_date'];
    pickUpTime = json['pickUp_time'];
    // booking_type = json['booking_type'];
    pickUpLoc = json['pickUpLoc'];
    destinationLoc = json['destinationLoc'];
    totalFaire = json['total_faire'];
    driverCommission = json['driverCommission'];
    isShowPhoneNumber = json['is_show_phoneNumber'];
    isDriverCreateBooking = json['is_driver_createBooking'];
    isAssigned = json['is_assigned'];
    remark = json['remark'];
    typeLabel = json['type_label'];
    subTypeLabel = json['sub_type_label'];
    isAirportLabel = json['is_airport_label'];
    carImage = json['car_image'];
    carCategory = json['car_category'] != null
        ? CarCategory.fromJson(json['car_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['driver_id'] = driverId;
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
    data['remark'] = remark;
    data['type_label'] = typeLabel;
    data['sub_type_label'] = subTypeLabel;
    data['is_airport_label'] = isAirportLabel;
    data['car_image'] = carImage;
    if (carCategory != null) {
      data['car_category'] = carCategory!.toJson();
    }
    return data;
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
