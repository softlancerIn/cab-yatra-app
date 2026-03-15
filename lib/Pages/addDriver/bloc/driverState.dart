import 'dart:io';
import '../model/driverListModel.dart';

class DriverState {
  final bool loading;
  final bool success;
  final List<SubDriver> drivers;
  final String? error;

  final File? dlFront;
  final File? dlBack;
  final File? aadharFront;
  final File? aadharBack;
  final File? profileImage;

  DriverState({
    this.loading = false,
    this.success = false,
    this.drivers = const [],
    this.error,
    this.dlFront,
    this.dlBack,
    this.aadharFront,
    this.aadharBack,
    this.profileImage,
  });

  DriverState copyWith({
    bool? loading,
    bool? success,
    List<SubDriver>? drivers,
    String? error,
    File? dlFront,
    File? dlBack,
    File? aadharFront,
    File? aadharBack,
    File? profileImage,
  }) {
    return DriverState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      drivers: drivers ?? this.drivers,
      error: error,
      dlFront: dlFront ?? this.dlFront,
      dlBack: dlBack ?? this.dlBack,
      aadharFront: aadharFront ?? this.aadharFront,
      aadharBack: aadharBack ?? this.aadharBack,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
