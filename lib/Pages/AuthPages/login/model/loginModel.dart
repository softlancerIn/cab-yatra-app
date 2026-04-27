class LoginModel {
  bool? status;
  bool? isRegistered;
  String? message;
  int? otp;
  Data? data;

  LoginModel({this.status, this.isRegistered, this.message, this.otp, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == true || json['status']?.toString() == "1" || json['status']?.toString() == "true";
    isRegistered = json['is_registered'] == true || json['is_registered']?.toString() == "1" || json['is_registered']?.toString() == "true";
    message = json['message']?.toString();
    otp = int.tryParse(json['otp']?.toString() ?? "");
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['is_registered'] = isRegistered;
    data['message'] = message;
    data['otp'] = otp;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? otp;

  Data({this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    return data;
  }
}
