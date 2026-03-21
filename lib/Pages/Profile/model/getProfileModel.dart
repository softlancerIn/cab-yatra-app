class GetProfileModel {
  bool? status;
  var message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  var id;
  var uniqId;
  var name;
  var email;
  var phone;
  var city;
  var type;
  var licenseNumber;
  var licenseNumber2;
  var cInfo;
  var status;
  var rating;
  var driverImageUrl;
  var createdAt;
  var updatedAt;
  var totalBooking;
  var cancelBooking;

  Data(
      {this.id,
      this.uniqId,
      this.name,
      this.email,
      this.phone,
      this.city,
      this.type,
      this.licenseNumber,
      this.licenseNumber2,
      this.cInfo,
      this.status,
      this.rating,
      this.driverImageUrl,
      this.createdAt,
      this.updatedAt,
      this.totalBooking,
      this.cancelBooking});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqId = json['uniqId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
    type = json['type'];
    licenseNumber = json['license_number'];
    licenseNumber2 = json['license_number2'];
    cInfo = json['c_info'];
    status = json['status'];
    rating = json['rating'];
    driverImageUrl = json['driver_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalBooking = json['total_booking'];
    cancelBooking = json['cancel_booking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uniqId'] = uniqId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['city'] = city;
    data['type'] = type;
    data['license_number'] = licenseNumber;
    data['license_number2'] = licenseNumber2;
    data['c_info'] = cInfo;
    data['status'] = status;
    data['rating'] = rating;
    data['driver_image'] = driverImageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_booking'] = totalBooking;
    data['cancel_booking'] = cancelBooking;
    return data;
  }
}
