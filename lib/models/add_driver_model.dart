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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['driver_id'] = this.driverId;
    return data;
  }
}
