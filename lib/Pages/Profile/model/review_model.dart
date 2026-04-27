import 'dart:convert';

class ReviewModel {
  bool? status;
  String? message;
  DriverInfo? driver;
  num? averageRating;
  int? totalReviews;
  List<ReviewData>? data;

  ReviewModel({this.status, this.message, this.driver, this.averageRating, this.totalReviews, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['driver'] != null) {
      driver = DriverInfo.fromJson(json['driver']);
    }
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
    if (json['data'] != null) {
      data = <ReviewData>[];
      json['data'].forEach((v) {
        data!.add(ReviewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    data['average_rating'] = averageRating;
    data['total_reviews'] = totalReviews;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewData {
  int? id;
  String? rating;
  List<String>? checkBoxReview;
  String? textReview;
  String? createdAt;
  String? ratingById;
  String? ratingBy;
  String? ratingByName;
  String? ratingByImage;

  ReviewData(
      {this.id,
      this.rating,
      this.checkBoxReview,
      this.textReview,
      this.createdAt,
      this.ratingById,
      this.ratingBy,
      this.ratingByName,
      this.ratingByImage});

  ReviewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating']?.toString();
    
    // Decode checkBox_review if it's a string, otherwise cast if it's already a list
    if (json['checkBox_review'] is String) {
      try {
        final decoded = jsonDecode(json['checkBox_review']);
        if (decoded is List) {
          checkBoxReview = decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        checkBoxReview = [];
      }
    } else if (json['checkBox_review'] is List) {
      checkBoxReview = (json['checkBox_review'] as List).map((e) => e.toString()).toList();
    }

    textReview = json['text_review'];
    createdAt = json['created_at'];
    ratingById = json['rating_by_id']?.toString();
    ratingBy = json['rating_by'];
    ratingByName = json['rating_byName'];
    ratingByImage = json['rating_byImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['checkBox_review'] = checkBoxReview;
    data['text_review'] = textReview;
    data['created_at'] = createdAt;
    data['rating_by_id'] = ratingById;
    data['rating_by'] = ratingBy;
    data['rating_byName'] = ratingByName;
    data['rating_byImage'] = ratingByImage;
    return data;
  }
}

class DriverInfo {
  int? id;
  String? name;
  String? driverImage;
  String? driverImageUrl;

  DriverInfo({this.id, this.name, this.driverImage, this.driverImageUrl});

  DriverInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    driverImage = json['driver_image'];
    driverImageUrl = json['driver_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['driver_image'] = driverImage;
    data['driver_image_url'] = driverImageUrl;
    return data;
  }
}
