class PostedBookingModel {
  bool? status;
  String? message;
  List<Data>? data;

  PostedBookingModel({this.status, this.message, this.data});

  PostedBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? orderId;
  int? driverId;
  String? subType;
  String? carCategoryId;
  String? pickUpDate;
  String? pickUpTime;
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
  CarCategory? carCategory;

  Data(
      {this.id,
        this.orderId,
        this.driverId,
        this.subType,
        this.carCategoryId,
        this.pickUpDate,
        this.pickUpTime,
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
        this.carCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    driverId = json['driver_id'];
    subType = json['subType'];
    carCategoryId = json['carCategory_id'];
    pickUpDate = json['pickUp_date'];
    pickUpTime = json['pickUp_time'];
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
    carCategory = json['car_category'] != null
        ? new CarCategory.fromJson(json['car_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['driver_id'] = this.driverId;
    data['subType'] = this.subType;
    data['carCategory_id'] = this.carCategoryId;
    data['pickUp_date'] = this.pickUpDate;
    data['pickUp_time'] = this.pickUpTime;
    data['pickUpLoc'] = this.pickUpLoc;
    data['destinationLoc'] = this.destinationLoc;
    data['total_faire'] = this.totalFaire;
    data['driverCommission'] = this.driverCommission;
    data['is_show_phoneNumber'] = this.isShowPhoneNumber;
    data['is_driver_createBooking'] = this.isDriverCreateBooking;
    data['is_assigned'] = this.isAssigned;
    data['remark'] = this.remark;
    data['type_label'] = this.typeLabel;
    data['sub_type_label'] = this.subTypeLabel;
    data['is_airport_label'] = this.isAirportLabel;
    if (this.carCategory != null) {
      data['car_category'] = this.carCategory!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
