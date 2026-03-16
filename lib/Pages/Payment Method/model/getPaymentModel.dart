class GetPaymentModel {
  final bool? status;
  final String? message;
  final List<PaymentData>? data;

  GetPaymentModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetPaymentModel.fromJson(Map<String, dynamic> json) {
    List<PaymentData> parsedData = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        parsedData = List<PaymentData>.from(
          (json['data'] as List).map((x) => PaymentData.fromJson(x)),
        );
      }
    }

    return GetPaymentModel(
      status: json['status'],
      message: json['message'],
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentData {
  final int? id;
  final int? type;
  final int? driverId;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? accountHolderName;
  final String? upiId;
  final String? paymentNumber;
  final String? qrImage;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? qrImageUrl;

  PaymentData({
    this.id,
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
    this.qrImageUrl,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'],
      type: json['type'],
      driverId: json['driver_id'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      accountHolderName: json['account_holderName'],
      upiId: json['upi_id'],
      paymentNumber: json['payment_number'],
      qrImage: json['qr_image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      qrImageUrl: json['qr_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "driver_id": driverId,
      "bank_name": bankName,
      "account_number": accountNumber,
      "ifsc_code": ifscCode,
      "account_holderName": accountHolderName,
      "upi_id": upiId,
      "payment_number": paymentNumber,
      "qr_image": qrImage,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "qr_image_url": qrImageUrl,
    };
  }
}