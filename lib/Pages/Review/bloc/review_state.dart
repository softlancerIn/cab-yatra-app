import 'package:equatable/equatable.dart';
import '../../Profile/model/review_model.dart';
import '../../Profile/model/getProfileModel.dart';

class ReviewState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ReviewModel? reviewModel;
  final GetProfileModel? profileModel;

  const ReviewState({
    this.isLoading = false,
    this.errorMessage,
    this.reviewModel,
    this.profileModel,
  });

  ReviewState copyWith({
    bool? isLoading,
    String? errorMessage,
    ReviewModel? reviewModel,
    GetProfileModel? profileModel,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      reviewModel: reviewModel ?? this.reviewModel,
      profileModel: profileModel ?? this.profileModel,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, reviewModel, profileModel];
}
