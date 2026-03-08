class GetTransectionModel {
  bool? status;
  var message;
  List<TransactionData>? data;

  GetTransectionModel({this.status, this.message, this.data});

  GetTransectionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['status'] = status;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class TransactionData {
  var bookingId;
  var bookingAmount;
  var commission;
  var plateformCharge;
  var driverEarning;
  var createdAt;

  TransactionData({
    this.bookingId,
    this.bookingAmount,
    this.commission,
    this.plateformCharge,
    this.driverEarning,
    this.createdAt,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingAmount = json['booking_amount'];
    commission = json['commission'];
    plateformCharge = json['plateform_charge'];
    driverEarning = json['driver_earning'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['booking_id'] = bookingId;
    data['booking_amount'] = bookingAmount;
    data['commission'] = commission;
    data['plateform_charge'] = plateformCharge;
    data['driver_earning'] = driverEarning;
    data['created_at'] = createdAt;
    return data;
  }
}