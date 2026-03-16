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

  const AddBookingState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
    this.carCategories,
    this.selectedCarCategoryId,
    this.updateAssignMethodModel,
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
  }) {
    return AddBookingState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
      carCategories: carCategories ?? this.carCategories,
      selectedCarCategoryId: selectedCarCategoryId ?? this.selectedCarCategoryId,
      updateAssignMethodModel: updateAssignMethodModel ?? this.updateAssignMethodModel,
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
  ];
}