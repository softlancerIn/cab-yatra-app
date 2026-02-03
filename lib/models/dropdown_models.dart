class CarModel {
  final int id;
  final String name;

  CarModel({required this.id, required this.name});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
////TimeZone Model
class TimeZone {
  final int id;
  final String time;

  TimeZone({required this.id, required this.time});

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone(
      id: json['id'],
      time: json['time'],
    );
  }
}

