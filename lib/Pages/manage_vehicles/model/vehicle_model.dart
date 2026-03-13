class VehicleListModel {
  final bool status;
  final List<VehicleItem> vehicles;

  VehicleListModel({required this.status, required this.vehicles});

  factory VehicleListModel.fromJson(Map<String, dynamic> json) {
    return VehicleListModel(
      status: json['status'] ?? false,
      vehicles: (json['data'] != null && json['data']['data'] != null)
          ? (json['data']['data'] as List)
              .map((e) => VehicleItem.fromJson(e))
              .toList()
          : [],
    );
  }
}

class VehicleItem {
  final int id;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleYear;
  final String? image;

  VehicleItem({
    required this.id,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleYear,
    this.image,
  });

  factory VehicleItem.fromJson(Map<String, dynamic> json) {
    return VehicleItem(
      id: json['id'] ?? 0,
      vehicleType: json['car_category_name'] ?? json['type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleYear: json['registration_year']?.toString() ?? '',
      image: json['vehicle_image_url'],
    );
  }
}
