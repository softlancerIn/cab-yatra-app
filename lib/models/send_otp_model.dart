class OtpSendModel {
  bool? status;
  String? message;
  String? otp;
  String? userType;
  String? isRegistered;

  OtpSendModel(
      {this.status, this.message, this.otp, this.userType, this.isRegistered});

  OtpSendModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
    userType = json['user_type'];
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['otp'] = otp;
    data['user_type'] = userType;
    data['is_registered'] = isRegistered;
    return data;
  }
}
