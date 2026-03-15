import 'dart:io';
import '../model/vehicle_model.dart';
import '../../editBooking/model/edit_car_category_model.dart';

class VehicleState {
  final bool isLoading;
  final bool isSuccess;
  final List<VehicleItem> vehicles;
  final String? error;
  final File? vehicleImage;
  final File? insuranceImage;
  final File? rcFrontImage;
  final File? rcBackImage;
  final File? carImage1;
  final File? carImage2;
  final EditCarCategoryModel? carCategories;
  final int? selectedCarCategoryId;

  VehicleState({
    this.isLoading = false,
    this.isSuccess = false,
    this.vehicles = const [],
    this.error,
    this.vehicleImage,
    this.insuranceImage,
    this.rcFrontImage,
    this.rcBackImage,
    this.carImage1,
    this.carImage2,
    this.carCategories,
    this.selectedCarCategoryId,
  });

  VehicleState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<VehicleItem>? vehicles,
    String? error,
    File? vehicleImage,
    File? insuranceImage,
    File? rcFrontImage,
    File? rcBackImage,
    File? carImage1,
    File? carImage2,
    EditCarCategoryModel? carCategories,
    int? selectedCarCategoryId,
  }) {
    return VehicleState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      vehicles: vehicles ?? this.vehicles,
      error: error,
      vehicleImage: vehicleImage ?? this.vehicleImage,
      insuranceImage: insuranceImage ?? this.insuranceImage,
      rcFrontImage: rcFrontImage ?? this.rcFrontImage,
      rcBackImage: rcBackImage ?? this.rcBackImage,
      carImage1: carImage1 ?? this.carImage1,
      carImage2: carImage2 ?? this.carImage2,
      carCategories: carCategories ?? this.carCategories,
      selectedCarCategoryId: selectedCarCategoryId ?? this.selectedCarCategoryId,
    );
  }
}
