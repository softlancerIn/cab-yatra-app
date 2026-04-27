import 'dart:io';
import '../model/driverListModel.dart';

class DriverState {
  final bool loading;
  final bool isFetching;
  final bool success;
  final List<SubDriver> drivers;
  final String? error;

  final File? dlFront;
  final File? dlBack;
  final File? aadharFront;
  final File? aadharBack;
  final File? profileImage;
  final dynamic selectedDriver;

  DriverState({
    this.loading = false,
    this.isFetching = false,
    this.success = false,
    this.drivers = const [],
    this.error,
    this.dlFront,
    this.dlBack,
    this.aadharFront,
    this.aadharBack,
    this.profileImage,
    this.selectedDriver,
  });

  DriverState copyWith({
    bool? loading,
    bool? isFetching,
    bool? success,
    List<SubDriver>? drivers,
    String? error,
    File? dlFront,
    File? dlBack,
    File? aadharFront,
    File? aadharBack,
    File? profileImage,
    dynamic selectedDriver,
    bool clearSelectedDriver = false,
    bool clearFiles = false,
  }) {
    return DriverState(
      loading: loading ?? this.loading,
      isFetching: isFetching ?? this.isFetching,
      success: success ?? this.success,
      drivers: drivers ?? this.drivers,
      error: error,
      dlFront: clearFiles ? null : (dlFront ?? this.dlFront),
      dlBack: clearFiles ? null : (dlBack ?? this.dlBack),
      aadharFront: clearFiles ? null : (aadharFront ?? this.aadharFront),
      aadharBack: clearFiles ? null : (aadharBack ?? this.aadharBack),
      profileImage: clearFiles ? null : (profileImage ?? this.profileImage),
      selectedDriver: (clearSelectedDriver || clearFiles) ? null : (selectedDriver ?? this.selectedDriver),
    );
  }
}
