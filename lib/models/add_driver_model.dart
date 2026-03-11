class AddDriverModel {
  bool? status;
  String? message;
  var driverId;

  AddDriverModel({this.status, this.message, this.driverId});

  AddDriverModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    driverId = json['driver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['driver_id'] = driverId;
    return data;
  }
}
