class ChatDriversResponseModel {
  bool? status;
  List<Driver>? drivers;

  ChatDriversResponseModel({this.status, this.drivers});

  ChatDriversResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? true; // Default to true if missing
    
    List<Driver> allDrivers = [];
    
    if (json['drivers'] != null && json['drivers'] is List) {
      for (var v in json['drivers']) {
        allDrivers.add(Driver.fromJson(v));
      }
    }
    
    // Also check for 'users' if presented as drivers in the UI
    if (json['users'] != null && json['users'] is List) {
      for (var v in json['users']) {
        allDrivers.add(Driver.fromJson(v));
      }
    }
    
    drivers = allDrivers;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (drivers != null) {
      data['drivers'] = drivers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Driver {
  int? id;
  String? name;
  String? driverImage;
  String? driverImageUrl;
  String? lastMessage;
  dynamic bookingId;
  String? createdAt;
  String? updatedAt;

  Driver({
    this.id,
    this.name,
    this.driverImage,
    this.driverImageUrl,
    this.lastMessage,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    driverImage = json['driver_image'];
    driverImageUrl = json['driver_image_url'];
    lastMessage = json['last_message'];
    bookingId = json['booking_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['driver_image'] = driverImage;
    data['driver_image_url'] = driverImageUrl;
    data['last_message'] = lastMessage;
    data['booking_id'] = bookingId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
