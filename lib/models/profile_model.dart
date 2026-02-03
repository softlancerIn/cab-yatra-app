class DriverProfile {
  bool? status;
  String? message;
  Data? data;

  DriverProfile({this.status, this.message, this.data});

  DriverProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
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
  String? aadharNo;
  String? panNo;
  String? dlNo;
  String? driverImage;
  String? aadharFrontImage;
  String? aadharBackImage;
  String? dlImage;
  String? wallet;
  String? isVerified;
  String? isRegistered;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? driverImageUrl;
  String? aadharFrontImageUrl;
  String? aadharBackImageUrl;
  String? dlImageUrl;

  DriverCarDetails? driverCarDetails;

  Data({
    this.id,
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
    this.wallet,
    this.isVerified,
    this.isRegistered,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.driverImageUrl,
    this.aadharFrontImageUrl,
    this.aadharBackImageUrl,
    this.dlImageUrl,
    this.driverCarDetails,
  });

  Data.fromJson(Map<String, dynamic> json) {
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
    wallet = json['wallet'];
    isVerified = json['is_verified'];
    isRegistered = json['is_registered'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driverImageUrl = json['driver_image_url'];
    aadharFrontImageUrl = json['aadhar_frontImage_url'];
    aadharBackImageUrl = json['aadhar_backImage_url'];
    dlImageUrl = json['dl_image_url'];
    driverCarDetails = json['driver_car_details'] != null
        ? DriverCarDetails.fromJson(json['driver_car_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    data['wallet'] = wallet;
    data['is_verified'] = isVerified;
    data['is_registered'] = isRegistered;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['driver_image_url'] = driverImageUrl;
    data['aadhar_frontImage_url'] = aadharFrontImageUrl;
    data['aadhar_backImage_url'] = aadharBackImageUrl;
    data['dl_image_url'] = dlImageUrl;
    if (driverCarDetails != null) {
      data['driver_car_details'] = driverCarDetails!.toJson();
    }
    return data;
  }
}

class DriverCarDetails {
  int? id;
  String? driverId;
  String? carBrand;
  String? carName;
  String? carNo;
  String? fuelType;
  String? noSeat;
  String? carImage;
  String? insurenceImage;
  String? insurenceExpiry;
  String? carRcFrontImage;
  String? carRcBackImage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? carImageUrl;
  String? insurenceImageUrl;
  String? carRcFrontImageUrl;

  DriverCarDetails({
    this.id,
    this.driverId,
    this.carBrand,
    this.carName,
    this.carNo,
    this.fuelType,
    this.noSeat,
    this.carImage,
    this.insurenceImage,
    this.insurenceExpiry,
    this.carRcFrontImage,
    this.carRcBackImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.carImageUrl,
    this.insurenceImageUrl,
    this.carRcFrontImageUrl,
  });

  DriverCarDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    carBrand = json['car_brand'];
    carName = json['car_name'];
    carNo = json['car_no'];
    fuelType = json['fuel_type'];
    noSeat = json['no_seat'];
    carImage = json['car_image'];
    insurenceImage = json['insurence_image'];
    insurenceExpiry = json['insurence_expiry'];
    carRcFrontImage = json['car_rc_frontImage'];
    carRcBackImage = json['car_rc_backImage'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    carImageUrl = json['car_image_url'];
    insurenceImageUrl = json['insurence_image_url'];
    carRcFrontImageUrl = json['car_rc_frontImage_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['driver_id'] = driverId;
    data['car_brand'] = carBrand;
    data['car_name'] = carName;
    data['car_no'] = carNo;
    data['fuel_type'] = fuelType;
    data['no_seat'] = noSeat;
    data['car_image'] = carImage;
    data['insurence_image'] = insurenceImage;
    data['insurence_expiry'] = insurenceExpiry;
    data['car_rc_frontImage'] = carRcFrontImage;
    data['car_rc_backImage'] = carRcBackImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['car_image_url'] = carImageUrl;
    data['insurence_image_url'] = insurenceImageUrl;
    data['car_rc_frontImage_url'] = carRcFrontImageUrl;
    return data;
  }
}
