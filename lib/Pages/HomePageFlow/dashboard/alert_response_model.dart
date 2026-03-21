import 'dart:convert';

class AlertResponseModel {
  bool? status;
  String? message;
  AlertData? data;

  AlertResponseModel({this.status, this.message, this.data});

  AlertResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AlertData.fromJson(json['data']) : null;
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

class AlertData {
  int? id;
  int? driverId;
  String? aleartType;
  String? carsId;      // stored as JSON string e.g. "[12,15,18]"
  String? locations;   // stored as JSON string e.g. "[12,13,14]"
  String? manuallyPickup;
  String? status;      // "1" = active, "0" = inactive
  String? createdAt;
  String? updatedAt;

  AlertData(
      {this.id,
      this.driverId,
      this.aleartType,
      this.carsId,
      this.locations,
      this.manuallyPickup,
      this.status,
      this.createdAt,
      this.updatedAt});

  AlertData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    aleartType = json['aleart_type'];

    // Handle both List and String for cars_id
    if (json['cars_id'] is List) {
      carsId = jsonEncode(json['cars_id']);
    } else {
      carsId = json['cars_id']?.toString();
    }

    // Handle both List and String for locations
    if (json['locations'] is List) {
      locations = jsonEncode(json['locations']);
    } else {
      locations = json['locations']?.toString();
    }

    manuallyPickup = json['manually_pickup']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  /// Decode "[12,15,18]" → [12, 15, 18]
  List<int> get parsedCarsId {
    if (carsId == null || carsId!.isEmpty || carsId == 'null') return [];
    try {
      final decoded = jsonDecode(carsId!);
      if (decoded is List) return decoded.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } catch (_) {}
    return [];
  }

  /// Decode "[12,13,14]" → [12, 13, 14]
  List<int> get parsedLocations {
    if (locations == null || locations!.isEmpty || locations == 'null') return [];
    try {
      final decoded = jsonDecode(locations!);
      if (decoded is List) return decoded.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } catch (_) {}
    return [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driver_id'] = driverId;
    data['aleart_type'] = aleartType;
    data['cars_id'] = carsId;
    data['locations'] = locations;
    data['manually_pickup'] = manuallyPickup;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

