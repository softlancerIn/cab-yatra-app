import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/addCreateRepo.dart';
import 'addBookingEvent.dart';
import 'addBookingState.dart';

class AddBookingBloc extends Bloc<AddBookingEvent, AddBookingState> {
  final AddBookingRepo repo=AddBookingRepo();

  AddBookingBloc() : super(const AddBookingState()) {
    on<LoadCarCategories>(_onLoadCarCategories);
    on<SelectCarCategory>(_onSelectCarCategory);
    on<SubmitBooking>(_onSubmitBooking);
    on<UpdateAssignMethodEvent>(_updateAssignMethodApi);
    on<ResetBooking>((event, emit) => emit(const AddBookingState()));
  }

  Future<void> _onLoadCarCategories(
      LoadCarCategories event,
      Emitter<AddBookingState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final model = await repo.getCarCategory(context: event.context);
      emit(state.copyWith(
        isLoading: false,
        carCategories: model,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }  Future<void> _updateAssignMethodApi(
      UpdateAssignMethodEvent event,
      Emitter<AddBookingState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final model = await repo.updateAssignMethodApi(context: event.context,assignType: event.assignType);
      emit(state.copyWith(
        isLoading: false,
        updateAssignMethodModel: model,
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
      SelectCarCategory event,
      Emitter<AddBookingState> emit,
      ) {
    emit(state.copyWith(selectedCarCategoryId: event.carCategoryId));
  }

  Future<void> _onSubmitBooking(
      SubmitBooking event,
      Emitter<AddBookingState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null, hasError: false));

    try {
      final response = await repo.bookingCreateApi(
        subType: event.subType,
        carCategoryId: event.carCategoryId,
        pickUp_date: event.pickUpDate,
        pickUp_time: event.pickUpTime,
        pickUpLoc: event.pickUpLocations,
        destinationLoc: event.destinationLocations,
        total_faire: event.totalFare,
        driverCommission: event.driverCommission,
        noOfDay: event.noOfDay,
        tripNotes: event.tripNotes,
        is_show_phoneNumber: event.showPhoneNumber ? true : false,
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