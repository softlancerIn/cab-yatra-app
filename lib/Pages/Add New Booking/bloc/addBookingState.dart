import 'package:equatable/equatable.dart';

import '../model/car_category_model.dart';
import '../model/updateAssignMethodModel.dart';
class AddBookingState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;
  final CarCategoryModel? carCategories;
  final UpdateAssignMethodModel? updateAssignMethodModel;
  final int? selectedCarCategoryId;
  final String? bookingId;

  const AddBookingState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
    this.carCategories,
    this.selectedCarCategoryId,
    this.updateAssignMethodModel,
    this.bookingId,
  });

  AddBookingState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool? hasError,
    bool? isSuccess,
    CarCategoryModel? carCategories,
    UpdateAssignMethodModel? updateAssignMethodModel,
    int? selectedCarCategoryId,
    String? bookingId,
  }) {
    return AddBookingState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
      carCategories: carCategories ?? this.carCategories,
      selectedCarCategoryId:
          selectedCarCategoryId ?? this.selectedCarCategoryId,
      updateAssignMethodModel:
          updateAssignMethodModel ?? this.updateAssignMethodModel,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        errorMessage,
        hasError,
        isSuccess,
        carCategories,
        selectedCarCategoryId,
        updateAssignMethodModel,
        bookingId,
      ];
}