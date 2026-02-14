import 'package:equatable/equatable.dart';

import '../model/edit_car_category_model.dart';
class EditBookingState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;
  final EditCarCategoryModel? carCategories;
  final int? selectedCarCategoryId;

  const EditBookingState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
    this.carCategories,
    this.selectedCarCategoryId,
  });

  EditBookingState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool? hasError,
    bool? isSuccess,
    EditCarCategoryModel? carCategories,
    int? selectedCarCategoryId,
  }) {
    return EditBookingState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
      carCategories: carCategories ?? this.carCategories,
      selectedCarCategoryId: selectedCarCategoryId ?? this.selectedCarCategoryId,
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
  ];
}