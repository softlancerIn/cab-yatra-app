import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/bookingRepo.dart';


import 'booking_event.dart';
import 'booking_state.dart';


class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingRepo repo = BookingRepo();
//ResetDashboardEvent
  BookingBloc() : super(const BookingState()) {
 on<GetPostedBooingEvent>(getBookingEvent);
 on<DeleteBooingEvent>(deleteBookingEvent);


    on<ResetBookingEvent>((event, emit) {
      emit(const BookingState()); // pura state reset
    });
  }

  Future<void> getBookingEvent(
      GetPostedBooingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getBookingApi(context: event.context);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false, postedBookingModel: response));
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>get booking Data Exception Error>>>>$e");
    }
  }
  Future<void> deleteBookingEvent(
      DeleteBooingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.deleteBookingApi(context: event.context,bookingID: event.bookingId);
      if (response.status == true) {
        //getBookingEvent
        add(GetPostedBooingEvent(context: event.context));
        emit(state.copyWith(isLoading: false, deletePostedBookingModel: response));

      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>get booking Data Exception ....... Error>>>>$e");
    }
  }






}
