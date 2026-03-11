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
    data = json['data'] != null ? OtpVerifyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['is_registered'] = isRegistered;
    data['user_type'] = userType;
    data['token'] = token;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uniqId'] = uniqId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['aadhar_no'] = aadharNo;
    data['pan_no'] = panNo;
    data['dl_no'] = dlNo;
    data['driver_image'] = driverImage;
    data['aadhar_frontImage'] = aadharFrontImage;
    data['aadhar_backImage'] = aadharBackImage;
    data['dl_image'] = dlImage;
    data['is_verified'] = isVerified;
    data['is_registered'] = isRegistered;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['driver_image_url'] = driverImageUrl;
    data['aadhar_frontImage_url'] = aadharFrontImageUrl;
    data['aadhar_backImage_url'] = aadharBackImageUrl;
    data['dl_image_url'] = dlImageUrl;
    return data;
  }
}
