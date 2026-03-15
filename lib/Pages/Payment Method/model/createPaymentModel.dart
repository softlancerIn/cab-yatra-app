class CreatePaymentModel {
  bool? status;
  String? message;
  Data? data;

  CreatePaymentModel({this.status, this.message, this.data});

  CreatePaymentModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['type'] = type;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['ifsc_code'] = ifscCode;
    data['account_holderName'] = accountHolderName;
    data['upi_id'] = upiId;
    data['payment_number'] = paymentNumber;
    data['qr_image'] = qrImage;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['qr_image_url'] = qrImageUrl;
    return data;
  }
}
