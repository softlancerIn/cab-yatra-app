import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Profile/repo/profileRepo.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ProfileRepo profileRepo;

  ReviewBloc({required this.profileRepo}) : super(const ReviewState()) {
    on<LoadReviews>(_onLoadReviews);
  }

  Future<void> _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      // Get profile info and reviews in parallel if possible, or sequentially
      final profile = await profileRepo.getProfile(context: event.context);
      final reviews = await profileRepo.getReviews(context: event.context);
      
      emit(state.copyWith(
        isLoading: false,
        profileModel: profile,
        reviewModel: reviews,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
