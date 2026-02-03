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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_registered'] = this.isRegistered;
    data['user_type'] = this.userType;
    data['token'] = this.token;
    return data;
  }
}
