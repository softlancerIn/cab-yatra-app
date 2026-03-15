class EditCarCategoryModel {
  final bool? status;
  final String? message;
  final List<CarCategory>? data;

  EditCarCategoryModel({
    this.status,
    this.message,
    this.data,
  });

  factory EditCarCategoryModel.fromJson(Map<String, dynamic> json) {
    return EditCarCategoryModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => CarCategory.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.map((e) => e.toJson()).toList(),
    };
  }
}

class CarCategory {
  final int? id;
  final String? name;

  CarCategory({this.id, this.name});

  factory CarCategory.fromJson(Map<String, dynamic> json) {
    return CarCategory(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}