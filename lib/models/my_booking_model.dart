import 'dart:convert';

class BookingResponse {
  bool? status;
  String? message;
  MyBooking? myBooking;

  BookingResponse({this.status, this.message, this.myBooking});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    myBooking = json['my_booking'] != null
        ? MyBooking.fromJson(json['my_booking'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (myBooking != null) {
      data['active_booking'] = myBooking!.toJson();
    }
    return data;
  }
}

class MyBooking {
  var currentPage;
  List<MyBookingData>? data;
  String? firstPageUrl;
  var from;
  var lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  var perPage;
  String? prevPageUrl;
  var to;
  var total;

  MyBooking(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  MyBooking.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <MyBookingData>[];
      json['data'].forEach((v) {
        data!.add(MyBookingData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class MyBookingData {
  int? id;
  int? driver_id;
  String? orderId;
  String? type;
  String? subType;
  String? isAirpotToFrom;
  String? pickUpDate;
  String? pickUpTime;
  String? totalFaire;
  String? remark;
  String? destination_date;
  String? include_km;
  String? onlinePayment;
  String? offlinePayment;
  String? driverComission;
  List<String>? pickUpLoc;
  String? destinationLoc;
  String? carCategoryId;
  String? addOnService;
  String? fuel_type;
  String? extra_fair_perKm;
  String? toll;
  String? tax;
  String? driver_number;
  String? is_show_phoneNumber;
  String? status;
  String? typeLabel;
  String? subTypeLabel;
  String? isAirportLabel;
  CarCategory? carCategory;
  Car? car;
  TimeScheduleData? timeScheduleData;

  MyBookingData(
      {this.id,
      this.orderId,
      this.type,
      this.subType,
      this.isAirpotToFrom,
      this.pickUpDate,
      this.pickUpTime,
      this.totalFaire,
      this.remark,
      this.destination_date,
      this.is_show_phoneNumber,
      this.include_km,
      this.onlinePayment,
      this.offlinePayment,
      this.driverComission,
      this.pickUpLoc,
      this.destinationLoc,
      this.carCategoryId,
      this.addOnService,
      this.fuel_type,
      this.extra_fair_perKm,
      this.toll,
      this.tax,
      this.driver_number,
      this.driver_id,
      this.status,
      this.typeLabel,
      this.subTypeLabel,
      this.isAirportLabel,
      this.carCategory,
      this.timeScheduleData,
      this.car});

  MyBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    type = json['type'];
    subType = json['subType'];
    isAirpotToFrom = json['is_airpotToFrom'];
    pickUpDate = json['pickUp_date'];
    is_show_phoneNumber = json['is_show_phoneNumber'];
    pickUpTime = json['pickUp_time'];
    totalFaire = json['total_faire'];
    remark = json['remark'];
    destination_date = json['destination_date'];
    include_km = json['include_km'];
    onlinePayment = json['online_payment'];
    offlinePayment = json['offline_payment'];
    driverComission = json['driver_comission'];
    destinationLoc = json['destinationLoc'];
    carCategoryId = json['carCategory_id'];
    addOnService = json['add_onService'];
    fuel_type = json['fuel_type'];
    extra_fair_perKm = json['extra_fair_perKm'];
    toll = json['toll'];
    tax = json['tax'];
    driver_number = json['driver_number'];
    driver_id = json['driver_id'];
    status = json['status'];
    typeLabel = json['type_label'];
    subTypeLabel = json['sub_type_label'];
    isAirportLabel = json['is_airport_label'];
    carCategory = json['car_category'] != null
        ? CarCategory.fromJson(json['car_category'])
        : null;
    timeScheduleData = json['time_schadule_data'] != null
        ? TimeScheduleData.fromJson(json['time_schadule_data'])
        : null;
    car = json['car'] != null ? Car.fromJson(json['car']) : null;

    final rawPickUpLoc = json['pickUpLoc'];
    if (rawPickUpLoc is String) {
      if (rawPickUpLoc.startsWith('[') && rawPickUpLoc.endsWith(']')) {
        try {
          pickUpLoc = List<String>.from(jsonDecode(rawPickUpLoc));
        } catch (_) {
          pickUpLoc = [rawPickUpLoc];
        }
      } else {
        pickUpLoc = [rawPickUpLoc];
      }
    } else if (rawPickUpLoc is List) {
      pickUpLoc = List<String>.from(rawPickUpLoc);
    } else {
      pickUpLoc = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['type'] = type;
    data['subType'] = subType;
    data['is_airpotToFrom'] = isAirpotToFrom;
    data['pickUp_date'] = pickUpDate;
    data['pickUp_time'] = pickUpTime;
    data['total_faire'] = totalFaire;
    data['remark'] = remark;
    data['destination_date'] = destination_date;
    data['include_km'] = include_km;
    data['online_payment'] = onlinePayment;
    data['offline_payment'] = offlinePayment;
    data['driver_comission'] = driverComission;
    data['pickUpLoc'] = pickUpLoc;
    data['destinationLoc'] = destinationLoc;
    data['carCategory_id'] = carCategoryId;
    data['add_onService'] = addOnService;
    data['fuel_type'] = fuel_type;
    data['extra_fair_perKm'] = extra_fair_perKm;
    data['toll'] = toll;
    data['tax'] = tax;
    data['driver_number'] = driver_number;
    data['driver_id'] = driver_id;
    data['is_show_phoneNumber'] = is_show_phoneNumber;
    data['status'] = status;
    data['type_label'] = typeLabel;
    data['sub_type_label'] = subTypeLabel;
    data['is_airport_label'] = isAirportLabel;
    if (carCategory != null) {
      data['car_category'] = carCategory!.toJson();
    }
    if (car != null) {
      data['car'] = car!.toJson();
    }
    if (timeScheduleData != null) {
      data['time_schadule_data'] = timeScheduleData!.toJson(); // Add this line
    }
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}

class CarCategory {
  int? id;
  String? name;
  String? extraFairPerKm;
  String? extraFairPerHour;
  String? fuelCharge;
  String? driverCharge;
  String? nightCharge;
  String? toll;
  String? tax;
  String? parking;

  CarCategory(
      {this.id,
      this.name,
      this.extraFairPerKm,
      this.extraFairPerHour,
      this.fuelCharge,
      this.driverCharge,
      this.nightCharge,
      this.toll,
      this.tax,
      this.parking});

  CarCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    extraFairPerKm = json['extra_fair_perKm'];
    extraFairPerHour = json['extra_fair_perHour'];
    fuelCharge = json['fuel_charge'];
    driverCharge = json['driver_charge'];
    nightCharge = json['night_charge'];
    toll = json['toll'];
    tax = json['tax'];
    parking = json['parking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['extra_fair_perKm'] = extraFairPerKm;
    data['extra_fair_perHour'] = extraFairPerHour;
    data['fuel_charge'] = fuelCharge;
    data['driver_charge'] = driverCharge;
    data['night_charge'] = nightCharge;
    data['toll'] = toll;
    data['tax'] = tax;
    data['parking'] = parking;
    return data;
  }
}

class Car {
  int? id;
  String? name;
  String? category;

  Car({this.id, this.name, this.category});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    return data;
  }
}

class TimeScheduleData {
  int? id;
  String? time;

  TimeScheduleData({this.id, this.time});

  TimeScheduleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    return data;
  }
}
