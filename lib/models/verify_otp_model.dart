class OtpVerifyModel {
  bool? status;
  String? message;
  String? isRegistered;
  String? userType;
  String? token;
  OtpVerifyData? data;

  OtpVerifyModel(
      {this.status,
      this.message,
      this.isRegistered,
      this.userType,
      this.token,
      this.data});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isRegistered = json['is_registered'];
    userType = json['user_type'];
    token = json['token'];
    data =
        json['data'] != null ? new OtpVerifyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_registered'] = this.isRegistered;
    data['user_type'] = this.userType;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OtpVerifyData {
  int? id;
  String? uniqId;
  String? name;
  String? email;
  String? phone;
  String? aadharNo;
  String? panNo;
  String? dlNo;
  String? driverImage;
  String? aadharFrontImage;
  String? aadharBackImage;
  String? dlImage;
  String? isVerified;
  String? isRegistered;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? driverImageUrl;
  String? aadharFrontImageUrl;
  String? aadharBackImageUrl;
  String? dlImageUrl;

  OtpVerifyData(
      {this.id,
      this.uniqId,
      this.name,
      this.email,
      this.phone,
      this.aadharNo,
      this.panNo,
      this.dlNo,
      this.driverImage,
      this.aadharFrontImage,
      this.aadharBackImage,
      this.dlImage,
      this.isVerified,
      this.isRegistered,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.driverImageUrl,
      this.aadharFrontImageUrl,
      this.aadharBackImageUrl,
      this.dlImageUrl});

  OtpVerifyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqId = json['uniqId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    aadharNo = json['aadhar_no'];
    panNo = json['pan_no'];
    dlNo = json['dl_no'];
    driverImage = json['driver_image'];
    aadharFrontImage = json['aadhar_frontImage'];
    aadharBackImage = json['aadhar_backImage'];
    dlImage = json['dl_image'];
    isVerified = json['is_verified'];
    isRegistered = json['is_registered'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driverImageUrl = json['driver_image_url'];
    aadharFrontImageUrl = json['aadhar_frontImage_url'];
    aadharBackImageUrl = json['aadhar_backImage_url'];
    dlImageUrl = json['dl_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uniqId'] = this.uniqId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['aadhar_no'] = this.aadharNo;
    data['pan_no'] = this.panNo;
    data['dl_no'] = this.dlNo;
    data['driver_image'] = this.driverImage;
    data['aadhar_frontImage'] = this.aadharFrontImage;
    data['aadhar_backImage'] = this.aadharBackImage;
    data['dl_image'] = this.dlImage;
    data['is_verified'] = this.isVerified;
    data['is_registered'] = this.isRegistered;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['driver_image_url'] = this.driverImageUrl;
    data['aadhar_frontImage_url'] = this.aadharFrontImageUrl;
    data['aadhar_backImage_url'] = this.aadharBackImageUrl;
    data['dl_image_url'] = this.dlImageUrl;
    return data;
  }
}
