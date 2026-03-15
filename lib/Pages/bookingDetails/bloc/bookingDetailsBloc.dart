import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/bookingDetailRepo.dart';


import 'bookingDetailsEvent.dart';
import 'bookingDetailsState.dart';


class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  BookingDetailRepo repo = BookingDetailRepo();
//ResetDashboardEvent
  BookingDetailBloc() : super(const BookingDetailState()) {

    on<GetBookingDetailEvent>(getBookingDetailEvent);


    on<ResetBookingDetailEvent>((event, emit) {
      emit(const BookingDetailState()); // pura state reset
    });
  }

  Future<void> getBookingDetailEvent(
      GetBookingDetailEvent event,
      Emitter<BookingDetailState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getBookingDetailApi(context: event.context,bookingId: event.bookingId);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false, bookingDetailModel: response));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>get booking Data Exception Error>>>>$e");
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }






}
