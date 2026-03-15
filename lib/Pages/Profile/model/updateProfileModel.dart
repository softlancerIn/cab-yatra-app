class UpdateProfileModel {
  bool? status;
  String? message;
  Data? data;

  UpdateProfileModel({this.status, this.message, this.data});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? uniqId;
  String? name;
  String? email;
  String? phone;
  String? city;
  String? type;
  String? licenseNumber;
  String? licenseNumber2;
  String? cInfo;
  String? status;
  String? rating;
  String? driverImageUrl;
  String? createdAt;
  String? updatedAt;

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
        this.updatedAt});

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
    driverImageUrl = json['driver_image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uniqId'] = this.uniqId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['type'] = this.type;
    data['license_number'] = this.licenseNumber;
    data['license_number2'] = this.licenseNumber2;
    data['c_info'] = this.cInfo;
    data['status'] = this.status;
    data['rating'] = this.rating;
    data['driver_image_url'] = this.driverImageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
