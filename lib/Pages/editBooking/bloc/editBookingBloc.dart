import 'package:flutter_bloc/flutter_bloc.dart';


import '../repo/editBookingRepo.dart';
import 'editBookingEvent.dart';
import 'editBookingState.dart';

class EditBookingBloc extends Bloc<EditBookingEvent, EditBookingState> {
  final EditBookingRepo repo=EditBookingRepo();

  EditBookingBloc() : super(const EditBookingState()) {
    on<EditLoadCarCategories>(_onLoadCarCategories);
    on<EditSelectCarCategory>(_onSelectCarCategory);
    on<EditSubmitBooking>(_onSubmitBooking);
    on<ResetBooking>((event, emit) => emit(const EditBookingState()));
  }

  Future<void> _onLoadCarCategories(
      EditLoadCarCategories event,
      Emitter<EditBookingState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final model = await repo.getCarCategory(context: event.context);
      emit(state.copyWith(
        isLoading: false,
        carCategories: model,
        selectedCarCategoryId: event.initialCarCategoryId,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectCarCategory(
      EditSelectCarCategory event,
      Emitter<EditBookingState> emit,
      ) {
    emit(state.copyWith(selectedCarCategoryId: event.carCategoryId));
  }

  Future<void> _onSubmitBooking(
      EditSubmitBooking event,
      Emitter<EditBookingState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null, hasError: false));

    try {
      final response = await repo.editBookingApi(
        id: event.id,
        subType: event.subType,
        carCategoryId: event.carCategoryId,
        pickUp_date: event.pickUpDate,
        pickUp_time: event.pickUpTime,
        pickUpLoc: event.pickUpLocations,
        destinationLoc: event.destinationLocations,
        total_faire: event.totalFare,
        driverCommission: event.driverCommission,
        is_show_phoneNumber: event.showPhoneNumber ? 1 : 0,
        remarks: event.remarks,
        context: event.context,
      );

      if (response.status == true) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: response.message ?? "Booking created successfully",
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          hasError: true,
          errorMessage: response.message ?? "Failed to create booking",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }
}