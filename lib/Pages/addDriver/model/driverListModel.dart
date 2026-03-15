class DriverListModel {
  final bool status;
  final List<SubDriver> drivers;

  DriverListModel({required this.status, required this.drivers});

  factory DriverListModel.fromJson(Map<String, dynamic> json) {
    return DriverListModel(
      status: json['status'],
      drivers: (json['data']['data'] as List)
          .map((e) => SubDriver.fromJson(e))
          .toList(),
    );
  }
}

class SubDriver {
  final int id;
  final String name;
  final String phone;
  final String city;
  final String? image;

  SubDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    this.image,
  });

  factory SubDriver.fromJson(Map<String, dynamic> json) {
    return SubDriver(
      id: json['id'],
      name: json['name'],
      phone: json['phone_number'],
      city: json['city_name'],
      image: json['dl_frontImage_url'],
    );
  }
}
