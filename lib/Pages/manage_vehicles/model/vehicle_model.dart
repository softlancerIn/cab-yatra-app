class VehicleListModel {
  final bool status;
  final List<VehicleItem> vehicles;

  VehicleListModel({
    required this.status,
    required this.vehicles,
  });

  factory VehicleListModel.fromJson(Map<String, dynamic> json) {
    List<VehicleItem> parsedVehicles = [];

    if (json['data'] != null) {
      if (json['data'] is List) {
        parsedVehicles = (json['data'] as List)
            .map((e) => VehicleItem.fromJson(e))
            .toList();
      } else if (json['data'] is Map && json['data']['data'] is List) {
        parsedVehicles = (json['data']['data'] as List)
            .map((e) => VehicleItem.fromJson(e))
            .toList();
      }
    }

    return VehicleListModel(
      status: json['status'] ?? false,
      vehicles: parsedVehicles,
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

      vehicleType: json['car_name'] ??
          json['car_brand'] ??
          "Category ID: ${json['car_category_id'] ?? ''}",

      vehicleNumber: (json['car_registration_number'] ??
              json['vehicle_number'])
          ?.toString() ??
          '',

      vehicleYear: (json['manifacturer_of_year'] ??
              json['registration_year'])
          ?.toString() ??
          '',

      image: json['car_image1_url'] ??
          json['vehicle_image_url'],
    );
  }
}
