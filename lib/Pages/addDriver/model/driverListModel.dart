class DriverListModel {
  final bool status;
  final List<SubDriver> drivers;

  DriverListModel({required this.status, required this.drivers});

  factory DriverListModel.fromJson(Map<String, dynamic> json) {
    List<SubDriver> parsedDrivers = [];

    if (json['data'] != null) {
      if (json['data'] is List) {
        parsedDrivers = (json['data'] as List)
            .map((e) => SubDriver.fromJson(e))
            .toList();
      } else if (json['data'] is Map && json['data']['data'] is List) {
        parsedDrivers = (json['data']['data'] as List)
            .map((e) => SubDriver.fromJson(e))
            .toList();
      }
    }

    return DriverListModel(
      status: json['status'] ?? false,
      drivers: parsedDrivers,
    );
  }
}

class SubDriver {
  final int id;
  final String name;
  final String phone;
  final String city;
  final String? image;
  final int isApprove;

  SubDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    this.image,
    required this.isApprove,
  });

  factory SubDriver.fromJson(Map<String, dynamic> json) {
    return SubDriver(
      id: json['id'],
      name: json['name'],
      phone: json['phone_number'],
      city: json['city_name'],
      image: json['driver_image_url'] ?? json['dl_frontImage_url'],
      isApprove: (json['is_approve'] == 1 ||
              json['is_approve'] == '1' ||
              json['is_approve'] == true)
          ? 1
          : 0,
    );
  }
}
