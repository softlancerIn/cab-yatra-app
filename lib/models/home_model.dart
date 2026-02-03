import 'dart:convert';

class HomePageModel {
  bool? status;
  String? message;
  List<Banners>? banners;
  NewBooking? newBooking;
  NewBooking? activeBooking;

  HomePageModel(
      {this.status,
      this.message,
      this.banners,
      this.newBooking,
      this.activeBooking});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    newBooking = json['new_booking'] != null
        ? new NewBooking.fromJson(json['new_booking'])
        : null;
    activeBooking = json['active_booking'] != null
        ? new NewBooking.fromJson(json['active_booking'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.newBooking != null) {
      data['new_booking'] = this.newBooking!.toJson();
    }
    if (this.activeBooking != null) {
      data['active_booking'] = this.activeBooking!.toJson();
    }
    return data;
  }
}

class Banners {
  int? id;
  String? name;
  String? image;
  String? url;

  Banners({this.id, this.name, this.image, this.url});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['url'] = this.url;
    return data;
  }
}

class NewBooking {
  var currentPage;
  List<NewBookingData>? data;
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

  NewBooking(
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

  NewBooking.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <NewBookingData>[];
      json['data'].forEach((v) {
        data!.add(new NewBookingData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class NewBookingData {
  int? id;
  String? orderId;
  String? type;
  String? subType;
  String? isAirpotToFrom;
  String? pickUpDate;
  String? pickUpTime;
  String? totalFaire;
  String? remark;
  String? destination_date;
  String? include_km ;
  String? toll ;
  String? tax ;
  String? onlinePayment;
  String? offlinePayment;
  String? driverComission;
  List<String>? pickUpLoc;
  String? destinationLoc;
  String? carCategoryId;
  String? addOnService;
  String? fuel_type;
  String? extra_fair_perKm;
  String? driver_number;
  String? is_show_phoneNumber;
  String? assign_booking_status;
  String? status;
  String? typeLabel;
  String? subTypeLabel;
  String? isAirportLabel;
  CarCategory? carCategory;
  Car? car;
  TimeScheduleData? timeScheduleData;

  NewBookingData(
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
      this.toll,
      this.tax,
      this.onlinePayment,
      this.offlinePayment,
      this.driverComission,
      this.pickUpLoc,
      this.destinationLoc,
      this.carCategoryId,
      this.addOnService,
      this.fuel_type,
      this.extra_fair_perKm,
      this.driver_number,
      this.assign_booking_status,
      this.status,
      this.typeLabel,
      this.subTypeLabel,
      this.isAirportLabel,
      this.carCategory,
      this.timeScheduleData,
      this.car});

  NewBookingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    type = json['type'];
    subType = json['subType'];
    isAirpotToFrom = json['is_airpotToFrom'];
    pickUpDate = json['pickUp_date'];
    is_show_phoneNumber = json['is_show_phoneNumber'];
    toll = json['toll'];
    tax = json['tax'];
    pickUpTime = json['pickUp_time'];
    totalFaire = json['total_faire'];
    remark = json['remark'];
    destination_date = json['destination_date'];
    include_km  = json['include_km'];
    onlinePayment = json['online_payment'];
    offlinePayment = json['offline_payment'];
    driverComission = json['driver_comission'];
    destinationLoc = json['destinationLoc'];
    carCategoryId = json['carCategory_id'];
    addOnService = json['add_onService'];
    fuel_type = json['fuel_type'];
    extra_fair_perKm = json['extra_fair_perKm'];
    driver_number = json['driver_number'];
    assign_booking_status = json['assign_booking_status'];
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
    car = json['car'] != null ? new Car.fromJson(json['car']) : null;

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
    data['include_km'] = include_km ;
    data['online_payment'] = onlinePayment;
    data['offline_payment'] = offlinePayment;
    data['driver_comission'] = driverComission;
    data['pickUpLoc'] = pickUpLoc;
    data['destinationLoc'] = destinationLoc;
    data['carCategory_id'] = carCategoryId;
    data['add_onService'] = this.addOnService;
    data['fuel_type'] = this.fuel_type;
    data['extra_fair_perKm'] = this.extra_fair_perKm;
    data['driver_number'] = this.driver_number;
    data['is_show_phoneNumber'] = this.is_show_phoneNumber;
    data['toll'] = this.toll;
    data['tax'] = this.tax;
    data['status'] = this.status;
    data['assign_booking_status'] = this.assign_booking_status;
    data['type_label'] = typeLabel;
    data['sub_type_label'] = subTypeLabel;
    data['is_airport_label'] = isAirportLabel;
    if (carCategory != null) {
      data['car_category'] = carCategory!.toJson();
    }
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    if (timeScheduleData != null) {
      data['time_schadule_data'] = timeScheduleData!.toJson(); // Add this line
    }
    return data;
  }
}

// class NewBookingData {
//   int? id;
//   String? orderId;
//   String? type;
//   String? subType;
//   String? isAirpotToFrom;
//   String? pickUpDate;
//   String? pickUpTime;
//   String? totalFaire;
//   String? onlinePayment;
//   String? offlinePayment;
//   String? driverComission;
//   String? pickUpLoc;
//   String? destinationLoc;
//   String? carCategoryId;
//   String? typeLabel;
//   String? subTypeLabel;
//   String? isAirportLabel;
//   CarCategory? carCategory;
//
//   NewBookingData(
//       {this.id,
//       this.orderId,
//       this.type,
//       this.subType,
//       this.isAirpotToFrom,
//       this.pickUpDate,
//       this.pickUpTime,
//       this.totalFaire,
//       this.onlinePayment,
//       this.offlinePayment,
//       this.driverComission,
//       this.pickUpLoc,
//       this.destinationLoc,
//       this.carCategoryId,
//       this.typeLabel,
//       this.subTypeLabel,
//       this.isAirportLabel,
//       this.carCategory});
//
//   NewBookingData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['orderId'];
//     type = json['type'];
//     subType = json['subType'];
//     isAirpotToFrom = json['is_airpotToFrom'];
//     pickUpDate = json['pickUp_date'];
//     pickUpTime = json['pickUp_time'];
//     totalFaire = json['total_faire'];
//     onlinePayment = json['online_payment'];
//     offlinePayment = json['offline_payment'];
//     driverComission = json['driver_comission'];
//     pickUpLoc = json['pickUpLoc'];
//     destinationLoc = json['destinationLoc'];
//     carCategoryId = json['carCategory_id'];
//     typeLabel = json['type_label'];
//     subTypeLabel = json['sub_type_label'];
//     isAirportLabel = json['is_airport_label'];
//     carCategory = json['car_category'] != null
//         ? new CarCategory.fromJson(json['car_category'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderId'] = this.orderId;
//     data['type'] = this.type;
//     data['subType'] = this.subType;
//     data['is_airpotToFrom'] = this.isAirpotToFrom;
//     data['pickUp_date'] = this.pickUpDate;
//     data['pickUp_time'] = this.pickUpTime;
//     data['total_faire'] = this.totalFaire;
//     data['online_payment'] = this.onlinePayment;
//     data['offline_payment'] = this.offlinePayment;
//     data['driver_comission'] = this.driverComission;
//     data['pickUpLoc'] = this.pickUpLoc;
//     data['destinationLoc'] = this.destinationLoc;
//     data['carCategory_id'] = this.carCategoryId;
//     data['type_label'] = this.typeLabel;
//     data['sub_type_label'] = this.subTypeLabel;
//     data['is_airport_label'] = this.isAirportLabel;
//     if (this.carCategory != null) {
//       data['car_category'] = this.carCategory!.toJson();
//     }
//     return data;
//   }
// }

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['extra_fair_perKm'] = this.extraFairPerKm;
    data['extra_fair_perHour'] = this.extraFairPerHour;
    data['fuel_charge'] = this.fuelCharge;
    data['driver_charge'] = this.driverCharge;
    data['night_charge'] = this.nightCharge;
    data['toll'] = this.toll;
    data['tax'] = this.tax;
    data['parking'] = this.parking;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
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
