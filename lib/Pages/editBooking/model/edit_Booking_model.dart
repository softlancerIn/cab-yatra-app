class EditBookingModel {
  bool? status;
  String? message;
  Data? data;

  EditBookingModel({this.status, this.message, this.data});

  EditBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['driver_id'] = this.driverId;
    data['type'] = this.type;
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
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['type_label'] = this.typeLabel;
    data['sub_type_label'] = this.subTypeLabel;
    data['is_airport_label'] = this.isAirportLabel;
    return data;
  }
}
