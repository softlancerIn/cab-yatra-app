class WalletResponse {
  final bool status;
  final String message;
  final DriverData driverData;
  final List<TransactionData> transactionData;

  WalletResponse({
    required this.status,
    required this.message,
    required this.driverData,
    required this.transactionData,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      status: json['status'],
      message: json['message'],
      driverData: DriverData.fromJson(json['driver_data']),
      transactionData: (json['ransaction_data'] as List)
          .map((transaction) => TransactionData.fromJson(transaction))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'driver_data': driverData.toJson(),
      'ransaction_data': transactionData.map((e) => e.toJson()).toList(),
    };
  }
}

class DriverData {
  final int id;
  final String wallet;
  final String driverImageUrl;
  final String aadharFrontImageUrl;
  final String aadharBackImageUrl;
  final String dlImageUrl;

  DriverData({
    required this.id,
    required this.wallet,
    required this.driverImageUrl,
    required this.aadharFrontImageUrl,
    required this.aadharBackImageUrl,
    required this.dlImageUrl,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      id: json['id'],
      wallet: json['wallet'],
      driverImageUrl: json['driver_image_url'] ?? '',
      aadharFrontImageUrl: json['aadhar_frontImage_url'] ?? '',
      aadharBackImageUrl: json['aadhar_backImage_url'] ?? '',
      dlImageUrl: json['dl_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet': wallet,
      'driver_image_url': driverImageUrl,
      'aadhar_frontImage_url': aadharFrontImageUrl,
      'aadhar_backImage_url': aadharBackImageUrl,
      'dl_image_url': dlImageUrl,
    };
  }
}

class TransactionData {
  final int id;
  final int driverId;
  final String amount;
  final String transactionId;
  final String razorpayId;
  final String type;
  final String createdAt;
  final String updatedAt;

  TransactionData({
    required this.id,
    required this.driverId,
    required this.amount,
    required this.transactionId,
    required this.razorpayId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'],
      driverId: int.parse(json['driver_id']),
      amount: json['amount'],
      transactionId: json['transaction_id'],
      razorpayId: json['razorpayId'] ?? '',
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId.toString(),
      'amount': amount,
      'transaction_id': transactionId,
      'razorpayId': razorpayId,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
