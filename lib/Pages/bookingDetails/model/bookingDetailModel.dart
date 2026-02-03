class BookingDetailModel {
  final bool status;
  final BookingData data;
  final String message;

  BookingDetailModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      status: json['status'] ?? false,
      data: BookingData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}
class BookingData {
  final String bookingId;
  final String pickupLocation;
  final String dropLocation;
  final String pickupDate;
  final String pickupTime;
  final String vehicleType;
  final double totalAmount;
  final String bookingStatus;
  final DriverDetail driver;

  BookingData({
    required this.bookingId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.vehicleType,
    required this.totalAmount,
    required this.bookingStatus,
    required this.driver,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingId: json['booking_id'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      dropLocation: json['drop_location'] ?? '',
      pickupDate: json['pickup_date'] ?? '',
      pickupTime: json['pickup_time'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      bookingStatus: json['booking_status'] ?? '',
      driver: DriverDetail.fromJson(json['driver'] ?? {}),
    );
  }
}
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
