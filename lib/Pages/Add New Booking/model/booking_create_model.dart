class BookingCreateModel {
  bool? status;
  String? message;
  Data? data;

  BookingCreateModel({this.status, this.message, this.data});

  BookingCreateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null && json['data'] is Map<String, dynamic>) 
        ? Data.fromJson(json['data']) 
        : null;
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
    orderId = json['orderId'] == null ? null : (double.tryParse(json['orderId'].toString())?.toInt());
    driverId = json['driver_id'] == null ? null : (double.tryParse(json['driver_id'].toString())?.toInt());
    type = json['type']?.toString();
    subType = json['subType']?.toString();
    carCategoryId = json['carCategory_id'] == null ? null : (double.tryParse(json['carCategory_id'].toString())?.toInt());
    pickUpDate = json['pickUp_date'];
    pickUpTime = json['pickUp_time'];
    pickUpLoc = json['pickUpLoc'];
    destinationLoc = json['destinationLoc'];
    totalFaire = json['total_faire'] == null ? null : (double.tryParse(json['total_faire'].toString())?.toInt());
    driverCommission = json['driverCommission'] == null ? null : (double.tryParse(json['driverCommission'].toString())?.toInt());
    isShowPhoneNumber = json['is_show_phoneNumber'] == 1 || 
                        json['is_show_phoneNumber'] == true || 
                        json['is_show_phoneNumber'].toString() == "1";
    isDriverCreateBooking = json['is_driver_createBooking']?.toString();
    isAssigned = json['is_assigned']?.toString();
    remark = json['remark'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'] == null ? null : (double.tryParse(json['id'].toString())?.toInt());
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
    data['is_show_phoneNumber'] = isShowPhoneNumber == true ? 1 : 0;
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
