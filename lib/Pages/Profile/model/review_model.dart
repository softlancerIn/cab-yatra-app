class ReviewModel {
  bool? status;
  String? message;
  List<ReviewData>? data;

  ReviewModel({this.status, this.message, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewData {
  int? id;
  String? rating;
  dynamic checkBoxReview;
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
    rating = json['rating'].toString();
    checkBoxReview = json['checkBox_review'];
    textReview = json['text_review'];
    createdAt = json['created_at'];
    ratingById = json['rating_by_id'].toString();
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
