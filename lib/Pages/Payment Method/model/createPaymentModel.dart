class CreatePaymentModel {
  bool? status;
  String? message;
  Data? data;

  CreatePaymentModel({this.status, this.message, this.data});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
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
  int? driverId;
  int? type;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? upiId;
  String? paymentNumber;
  String? qrImage;
  int? status;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? qrImageUrl;

  Data(
      {this.driverId,
        this.type,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.accountHolderName,
        this.upiId,
        this.paymentNumber,
        this.qrImage,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.qrImageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    type = json['type'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holderName'];
    upiId = json['upi_id'];
    paymentNumber = json['payment_number'];
    qrImage = json['qr_image'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    qrImageUrl = json['qr_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['type'] = this.type;
    data['bank_name'] = this.bankName;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['account_holderName'] = this.accountHolderName;
    data['upi_id'] = this.upiId;
    data['payment_number'] = this.paymentNumber;
    data['qr_image'] = this.qrImage;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['qr_image_url'] = this.qrImageUrl;
    return data;
  }
}
