class CityResponse {
  final bool? status;
  final String? message;
  final List<CityData>? data;

  CityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => CityData.fromJson(i)).toList()
          : null,
    );
  }
}

class CityData {
  final int? id;
  final String? name;

  CityData({
    this.id,
    this.name,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      id: json['id'],
      name: json['name'],
    );
  }
}
