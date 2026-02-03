class DriverDataModel {
  final String name;
  final int driverId;

  DriverDataModel({required this.name, required this.driverId});

  factory DriverDataModel.fromJson(Map<String, dynamic> json) {
    return DriverDataModel(
      name: json['name'],
      driverId: json['driver_id'],
    );
  }
}