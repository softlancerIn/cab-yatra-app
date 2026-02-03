import 'dart:convert';

// Top-level Homepage Response Model
class HomePageResponse {
  final bool status;
  final String message;
  final List<BannerItem> banners;
  final BookingSection newBooking;
  final BookingSection activeBooking;

  HomePageResponse({
    required this.status,
    required this.message,
    required this.banners,
    required this.newBooking,
    required this.activeBooking,
  });

  factory HomePageResponse.fromJson(Map<String, dynamic> json) {
    return HomePageResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      newBooking: BookingSection.fromJson(json['new_booking'] as Map<String, dynamic>),
      activeBooking: BookingSection.fromJson(json['active_booking'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'banners': banners.map((e) => e.toJson()).toList(),
      'new_booking': newBooking.toJson(),
      'active_booking': activeBooking.toJson(),
    };
  }
}

// Banner Item
class BannerItem {
  final int id;
  final String name;
  final String image;
  final String url;

  BannerItem({
    required this.id,
    required this.name,
    required this.image,
    required this.url,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'url': url,
    };
  }
}

// Main Booking Section (used for both new_booking and active_booking)
class BookingSection {
  final List<BookingItem> data;
  final PaginationLinks links;
  final PaginationMeta meta;

  BookingSection({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory BookingSection.fromJson(Map<String, dynamic> json) {
    return BookingSection(
      data: (json['data'] as List<dynamic>)
          .map((e) => BookingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'links': links.toJson(),
      'meta': meta.toJson(),
    };
  }
}

// Single Booking Item
class BookingItem {
  final String bookingId;
  final String id;
  final String pickupDate;
  final String pickupTime;
  final String bookingType;
  final String pickupLocation;
  final String destinationLocation;
  final String carImage;
  final String carCategoryName;
  final String? remark;
  final String totalFare;
  final String driverCommission;
  final String? isShowPhoneNumber;
  final String? driverNumber;

  BookingItem({
    required this.bookingId,
    required this.id,
    required this.pickupDate,
    required this.pickupTime,
    required this.bookingType,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.carImage,
    required this.carCategoryName,
    this.remark,
    required this.totalFare,
    required this.driverCommission,
    this.isShowPhoneNumber,
    this.driverNumber,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      bookingId: json['bookingId']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      pickupDate: json['pickup_date'] as String? ?? '',
      pickupTime: json['pickup_time'] as String? ?? '',
      bookingType: json['booking_type'] as String? ?? '',
      pickupLocation: json['pickup_location'] as String? ?? '',
      destinationLocation: json['destination_location'] as String? ?? '',
      carImage: json['car_image'] as String? ?? '',
      carCategoryName: json['car_category_name'] as String? ?? '',
      remark: json['remark']?.toString(),
      totalFare: json['total_fare']?.toString() ?? '0',
      driverCommission: json['driver_commission']?.toString() ?? '0',
      isShowPhoneNumber: json['is_show_phone_number']?.toString(),
      driverNumber: json['driver_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'id': id,
      'pickup_date': pickupDate,
      'pickup_time': pickupTime,
      'booking_type': bookingType,
      'pickup_location': pickupLocation,
      'destination_location': destinationLocation,
      'car_image': carImage,
      'car_category_name': carCategoryName,
      'remark': remark,
      'total_fare': totalFare,
      'driver_commission': driverCommission,
      'is_show_phone_number': isShowPhoneNumber,
      'driver_number': driverNumber,
    };
  }
}

// Pagination Links
class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first']?.toString(),
      last: json['last']?.toString(),
      prev: json['prev']?.toString(),
      next: json['next']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }
}

// Pagination Meta
class PaginationMeta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final List<MetaLink> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  PaginationMeta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int,
      links: (json['links'] as List<dynamic>)
          .map((e) => MetaLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      to: json['to'] as int?,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'links': links.map((e) => e.toJson()).toList(),
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

// Meta Link Item (for pagination links array)
class MetaLink {
  final String? url;
  final String label;
  final bool active;

  MetaLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory MetaLink.fromJson(Map<String, dynamic> json) {
    return MetaLink(
      url: json['url']?.toString(),
      label: json['label'] as String,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

// Optional: Quick parse helper
HomePageResponse parseHomePageResponse(String jsonString) {
  final jsonData = json.decode(jsonString);
  return HomePageResponse.fromJson(jsonData);
}