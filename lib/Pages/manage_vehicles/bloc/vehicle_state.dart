import 'dart:io';
import '../model/vehicle_model.dart';

class VehicleState {
  final bool isLoading;
  final bool isSuccess;
  final List<VehicleItem> vehicles;
  final String? error;
  final File? vehicleImage;

  VehicleState({
    this.isLoading = false,
    this.isSuccess = false,
    this.vehicles = const [],
    this.error,
    this.vehicleImage,
  });

  VehicleState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<VehicleItem>? vehicles,
    String? error,
    File? vehicleImage,
  }) {
    return VehicleState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      vehicles: vehicles ?? this.vehicles,
      error: error,
      vehicleImage: vehicleImage ?? this.vehicleImage,
    );
  }
}
