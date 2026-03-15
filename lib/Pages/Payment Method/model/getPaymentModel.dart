class GetPaymentModel {
  final bool? status;
  final String? message;
  final PaymentData? data;

  GetPaymentModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetPaymentModel.fromJson(Map<String, dynamic> json) {
    PaymentData? parsedData;
    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        parsedData = PaymentData.fromJson(json['data']);
      } else if (json['data'] is List && json['data'].isNotEmpty) {
        parsedData = PaymentData.fromJson(json['data'][0]);
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
      "data": data?.toJson(),
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
      id: int.tryParse(json['id'].toString()),
      type: int.tryParse(json['type'].toString()),
      driverId: int.tryParse(json['driver_id'].toString()),
      bankName: json['bank_name']?.toString(),
      accountNumber: json['account_number']?.toString(),
      ifscCode: json['ifsc_code']?.toString(),
      accountHolderName: json['account_holderName']?.toString(),
      upiId: json['upi_id']?.toString(),
      paymentNumber: json['payment_number']?.toString(),
      qrImage: json['qr_image']?.toString(),
      status: int.tryParse(json['status'].toString()),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      qrImageUrl: json['qr_image_url']?.toString(),
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