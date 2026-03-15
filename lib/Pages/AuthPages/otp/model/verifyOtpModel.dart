class VerifyOtpModel {
  var status;
  var message;
  var isRegistered;
  var userType;
  var token;

  VerifyOtpModel(
      {this.status,
      this.message,
      this.isRegistered,
      this.userType,
      this.token});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isRegistered = json['is_registered'];
    userType = json['user_type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['is_registered'] = isRegistered;
    data['user_type'] = userType;
    data['token'] = token;
    return data;
  }
}
