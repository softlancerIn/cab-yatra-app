class AddBookingModel {
  final int carCategoryId;
  var fuelType;
  final String tripType;
  final List<String>  pickupAddress;
  final List<String>  destinationAddress;
  // final String destinationAddress;
  final String startDate;
  final String startTime;
  final String totalKm;
  final String extraPricePerKm;
  final String toll;
  final String tax;
  final String totalAmount;
  final String commission;
  final String addOnService;
  final String isShowPhoneNumber;
  final String specialRequirement;
  final String? endDate;
  final String? endTime;
  final int? timeScheduleId;
  var airportTypeId;


  AddBookingModel({
    required this.carCategoryId,
    required this.fuelType,
    required this.tripType,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.startDate,
    required this.startTime,
    required this.totalKm,
    required this.extraPricePerKm,
    required this.toll,
    required this.tax,
    required this.totalAmount,
    required this.commission,
    required this.addOnService,
    required this.isShowPhoneNumber,
    required this.specialRequirement,
    this.endDate,
    this.endTime,
    this.timeScheduleId,
    this.airportTypeId
  });

  Map<String, dynamic> toJson() {
    return {
      'car_category_id': carCategoryId,
      'fuel_type': fuelType,
      'trip_type': tripType,
      'pickup_address': pickupAddress,
      'destination_address': destinationAddress,
      'start_date': startDate,
      'start_time': startTime,
      'total_km': totalKm,
      'extra_price_perKm': extraPricePerKm,
      'toll': toll,
      'tax': tax,
      'total_amount': totalAmount,
      'comission': commission,
      'add_on_service': addOnService,
      'is_show_phoneNumber': isShowPhoneNumber,
      'special_requirment': specialRequirement,
      'end_date': endDate,
      'end_time': endTime,
      'time_schaduleId': timeScheduleId,
      'airport_Type': airportTypeId,
    };
  }
}
