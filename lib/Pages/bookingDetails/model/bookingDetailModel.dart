class BookingDetailModel {
  final bool status;
  final String message;
  final BookingData? data;

  BookingDetailModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }
}

class BookingData {
  final int id;
  final String orderId;
  final String pickupLocation;
  final String dropLocation;
  final String pickupDate;
  final String pickupTime;
  final String vehicleType;
  final double totalAmount;
  final double driverCommission;
  final String remark;
  final String subTypeLabel;

  BookingData({
    required this.id,
    required this.orderId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.vehicleType,
    required this.totalAmount,
    required this.driverCommission,
    required this.remark,
    required this.subTypeLabel,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: json['orderId']?.toString() ?? '',
      pickupLocation: json['pickUpLoc'] ?? '',
      dropLocation: json['destinationLoc'] ?? '',
      pickupDate: json['pickUp_date'] ?? '',
      pickupTime: json['pickUp_time'] ?? '',
      vehicleType: json['car_category'] != null ? json['car_category']['name']?.toString() ?? '' : '',
      totalAmount: double.tryParse(json['total_faire']?.toString() ?? '0') ?? 0.0,
      driverCommission: double.tryParse(json['driverCommission']?.toString() ?? '0') ?? 0.0,
      remark: json['remark'] ?? '',
      subTypeLabel: json['sub_type_label'] ?? '',
    );
  }
}

// Keeping DriverDetail structure in case it's added later by other endpoints,
// but making it optional in mapping or handling it safely in UI.
class DriverDetail {
  final String name;
  final String agencyName;
  final String profileImage;
  final double rating;
  final int totalReviews;

  DriverDetail({
    required this.name,
    required this.agencyName,
    required this.profileImage,
    required this.rating,
    required this.totalReviews,
  });

  factory DriverDetail.fromJson(Map<String, dynamic> json) {
    return DriverDetail(
      name: json['name'] ?? '',
      agencyName: json['agency_name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}
