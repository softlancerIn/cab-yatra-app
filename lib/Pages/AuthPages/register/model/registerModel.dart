class RegisterModel {
  bool? status;
  String? message;
  Data? data;
  String? token;

  RegisterModel({this.status, this.message, this.data, this.token});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
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
  String? agentId;
  String? name;
  String? email;
  String? phone;
  String? address;

  Data({this.agentId, this.name, this.email, this.phone, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agentId'] = agentId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
