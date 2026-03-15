class BookingCreateModel {
  bool? status;
  String? message;
  Data? data;

  BookingCreateModel({this.status, this.message, this.data});

  BookingCreateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? orderId;
  int? driverId;
  String? type;
  String? subType;
  int? carCategoryId;
  String? pickUpDate;
  String? pickUpTime;
  String? pickUpLoc;
  String? destinationLoc;
  int? totalFaire;
  int? driverCommission;
  bool? isShowPhoneNumber;
  String? isDriverCreateBooking;
  String? isAssigned;
  String? remark;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? typeLabel;
  String? subTypeLabel;
  String? isAirportLabel;

  Data(
      {this.orderId,
      this.driverId,
      this.type,
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
      this.updatedAt,
      this.createdAt,
      this.id,
      this.typeLabel,
      this.subTypeLabel,
      this.isAirportLabel});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    driverId = json['driver_id'];
    type = json['type'];
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
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    typeLabel = json['type_label'];
    subTypeLabel = json['sub_type_label'];
    isAirportLabel = json['is_airport_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['driver_id'] = driverId;
    data['type'] = type;
    data['subType'] = subType;
    data['carCategory_id'] = carCategoryId;
    data['pickUp_date'] = pickUpDate;
    data['pickUp_time'] = pickUpTime;
    data['pickUpLoc'] = pickUpLoc;
    data['destinationLoc'] = destinationLoc;
    data['total_faire'] = totalFaire;
    data['driverCommission'] = driverCommission;
    data['is_show_phoneNumber'] = isShowPhoneNumber;
    data['is_driver_createBooking'] = isDriverCreateBooking;
    data['is_assigned'] = isAssigned;
    data['remark'] = remark;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['type_label'] = typeLabel;
    data['sub_type_label'] = subTypeLabel;
    data['is_airport_label'] = isAirportLabel;
    return data;
  }
}
