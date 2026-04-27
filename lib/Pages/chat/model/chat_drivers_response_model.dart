class ChatDriversResponseModel {
  bool? status;
  List<Driver>? drivers;

  ChatDriversResponseModel({this.status, this.drivers});

  ChatDriversResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? true; 
    
    // Use a temporary list to collect all entries
    List<Driver> rawDrivers = [];
    
    if (json['drivers'] != null && json['drivers'] is List) {
      for (var v in json['drivers']) {
        rawDrivers.add(Driver.fromJson(v));
      }
    }
    
    if (json['users'] != null && json['users'] is List) {
      for (var v in json['users']) {
        rawDrivers.add(Driver.fromJson(v));
      }
    }

    // Deduplicate by combining id and orderId
    final Map<String, Driver> deduplicated = {};
    for (var driver in rawDrivers) {
      // Key is formed by driver ID and booking ID to ensure uniqueness of the chat session
      final key = "${driver.id}_${driver.bookingId}";
      deduplicated[key] = driver;
    }
    
    drivers = deduplicated.values.toList();
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
  String? lastMessageTime;
  dynamic bookingId;
  String? orderId;
  String? createdAt;
  String? updatedAt;

  Driver({
    this.id,
    this.name,
    this.driverImage,
    this.driverImageUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.bookingId,
    this.orderId,
    this.createdAt,
    this.updatedAt,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? json['user_name'];
    driverImage = json['driver_image'] ?? json['profile_image'];
    driverImageUrl = json['driver_image_url'] ?? json['profile_image_url'] ?? json['image'];
    lastMessage = json['last_message'];
    lastMessageTime = json['last_message_time'];
    bookingId = json['booking_id'];
    orderId = (json['order_id'] ?? json['booking_id'] ?? '').toString();
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
    data['last_message_time'] = lastMessageTime;
    data['booking_id'] = bookingId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
