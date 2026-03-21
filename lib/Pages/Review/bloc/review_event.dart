import 'package:equatable/equatable.dart';
import '../../Profile/model/review_model.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviews extends ReviewEvent {
  final dynamic context;
  const LoadReviews(this.context);

  @override
  List<Object?> get props => [context];
}
