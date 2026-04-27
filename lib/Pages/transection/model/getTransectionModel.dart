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
  var id;
  var bookingId;
  var status;
  var paymentStatus;
  var bookingAmount;
  var commission;
  var platformCharge;
  var driverEarning;
  var createdAt;

  TransactionData({
    this.id,
    this.bookingId,
    this.status,
    this.paymentStatus,
    this.bookingAmount,
    this.commission,
    this.platformCharge,
    this.driverEarning,
    this.createdAt,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    bookingAmount = json['booking_amount'];
    commission = json['commission'];
    platformCharge = json['platform_charge'];
    driverEarning = json['driver_earning'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['booking_amount'] = bookingAmount;
    data['commission'] = commission;
    data['platform_charge'] = platformCharge;
    data['driver_earning'] = driverEarning;
    data['created_at'] = createdAt;
    return data;
  }
}