class DriverPaymentMethod {
  bool? status;
  String? message;
  PayMethodData? data; // Change from List<PayMethodData> to PayMethodData

  DriverPaymentMethod({this.status, this.message, this.data});

  DriverPaymentMethod.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = PayMethodData.fromJson(json['data']); // Directly parse the single object
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson(); // Convert the single object to JSON
    }
    return data;
  }
}

class PayMethodData {
  // int? id;
  String? type;
  String? driverId;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? upiId;
  String? paymentNumber;
  String? qrImage;
  String? status;
  String? createdAt;
  String? updatedAt;

  PayMethodData(
      {
        // this.id,
        this.type,
        this.driverId,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.accountHolderName,
        this.upiId,
        this.paymentNumber,
        this.qrImage,
        this.status,
        this.createdAt,
        this.updatedAt});

  PayMethodData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    type = json['type'];
    driverId = json['driver_id'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holderName'];
    upiId = json['upi_id'];
    paymentNumber = json['payment_number'];
    qrImage = json['qr_image'];
    status = json['status'];//
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['type'] = this.type;
    data['driver_id'] = this.driverId;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['account_holderName'] = this.accountHolderName;
    data['upi_id'] = this.upiId;
    data['payment_number'] = this.paymentNumber;
    data['qr_image'] = this.qrImage;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}