class UpdateAssignMethodModel {
  bool? status;
  String? message;

  UpdateAssignMethodModel({this.status, this.message});

  UpdateAssignMethodModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
