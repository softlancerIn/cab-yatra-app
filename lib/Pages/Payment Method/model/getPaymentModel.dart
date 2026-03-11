class GetPaymentModel {
  bool? status;
  var message;
  List<Data>? data;

  GetPaymentModel({this.status, this.message, this.data});

  GetPaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  var id;
  var type;
  var driverId;
  var bankName;
  var accountNumber;
  var ifscCode;
  var accountHolderName;
  var upiId;
  var paymentNumber;
  var qrImage;
  var status;
  var createdAt;
  var updatedAt;
  var qrImageUrl;

  Data(
      {this.id,
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
      this.updatedAt,
      this.qrImageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    driverId = json['driver_id'];
    bankName = json['bank_name'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    accountHolderName = json['account_holderName'];
    upiId = json['upi_id'];
    paymentNumber = json['payment_number'];
    qrImage = json['qr_image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    qrImageUrl = json['qr_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['driver_id'] = driverId;
    data['bank_name'] = bankName;
    data['account_number'] = accountNumber;
    data['ifsc_code'] = ifscCode;
    data['account_holderName'] = accountHolderName;
    data['upi_id'] = upiId;
    data['payment_number'] = paymentNumber;
    data['qr_image'] = qrImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['qr_image_url'] = qrImageUrl;
    return data;
  }
}
