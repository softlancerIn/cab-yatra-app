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
  final List<String> allImages;
  final String? driverNumber;
  final int? isApprove;

  VehicleItem({
    required this.id,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleYear,
    this.image,
    this.allImages = const [],
    this.driverNumber,
    this.isApprove = 0,
  });

  factory VehicleItem.fromJson(Map<String, dynamic> json) {
    final List<String> imgs = [];
    if (json['car_image1_url'] != null) imgs.add(json['car_image1_url'].toString());
    if (json['car_image2_url'] != null) imgs.add(json['car_image2_url'].toString());
    if (json['car_image3_url'] != null) imgs.add(json['car_image3_url'].toString());
    if (json['car_image4_url'] != null) imgs.add(json['car_image4_url'].toString());
    if (imgs.isEmpty && json['vehicle_image_url'] != null) imgs.add(json['vehicle_image_url'].toString());

    // Fix vehicle type mapping
    String type = '';
    if (json['car_category'] != null) {
      if (json['car_category'] is Map) {
        type = json['car_category']['name']?.toString() ?? '';
      } else {
        type = json['car_category'].toString();
      }
    }
    if (type.isEmpty) {
      type = (json['car_name'] ?? json['car_brand'] ?? json['name'] ?? '').toString();
    }

    return VehicleItem(
      id: json['id'] ?? 0,
      vehicleType: type.isNotEmpty ? type : "Category ID: ${json['car_category_id'] ?? ''}",
      vehicleNumber: (json['car_registration_number'] ??
              json['car_no'] ??
              json['vehicle_number'])
          ?.toString() ??
          '',
      vehicleYear: (json['manifacturer_of_year'] ??
              json['registration_year'])
          ?.toString() ??
          '',
      image: imgs.isNotEmpty ? imgs.first : null,
      allImages: imgs,
      driverNumber: (json['driver_number'] ?? json['driver_contact_number'])?.toString(),
      isApprove: (json['is_approve'] == 1 ||
              json['is_approve'] == '1' ||
              json['is_approve'] == true)
          ? 1
          : 0,
    );
  }
}
