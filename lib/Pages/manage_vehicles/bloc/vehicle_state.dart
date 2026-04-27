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
  final dynamic selectedVehicle;
  final bool isFetching;

  VehicleState({
    this.isLoading = false,
    this.isFetching = false,
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
    this.selectedVehicle,
  });

  VehicleState copyWith({
    bool? isLoading,
    bool? isFetching,
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
    dynamic selectedVehicle,
    bool clearSelectedVehicle = false,
    bool clearFiles = false,
  }) {
    return VehicleState(
      isLoading: isLoading ?? this.isLoading,
      isFetching: isFetching ?? this.isFetching,
      isSuccess: isSuccess ?? this.isSuccess,
      vehicles: vehicles ?? this.vehicles,
      error: error,
      vehicleImage: clearFiles ? null : (vehicleImage ?? this.vehicleImage),
      insuranceImage: clearFiles ? null : (insuranceImage ?? this.insuranceImage),
      rcFrontImage: clearFiles ? null : (rcFrontImage ?? this.rcFrontImage),
      rcBackImage: clearFiles ? null : (rcBackImage ?? this.rcBackImage),
      carImage1: clearFiles ? null : (carImage1 ?? this.carImage1),
      carImage2: clearFiles ? null : (carImage2 ?? this.carImage2),
      carCategories: carCategories ?? this.carCategories,
      selectedCarCategoryId: clearFiles ? null : (selectedCarCategoryId ?? this.selectedCarCategoryId),
      selectedVehicle: (clearSelectedVehicle || clearFiles) ? null : (selectedVehicle ?? this.selectedVehicle),
    );
  }
}
