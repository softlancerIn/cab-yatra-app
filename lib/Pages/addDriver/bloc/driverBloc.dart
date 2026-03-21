import 'dart:io';

import 'package:cab_taxi_app/Pages/addDriver/bloc/submitDriver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../repo/driverRepo.dart';
import 'driverState.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  final DriverRepo repo=DriverRepo();
  final ImagePicker _picker = ImagePicker();


  DriverBloc() : super(DriverState()) {
    on<SubmitDriver>(_submitDriver);
    on<LoadDrivers>(_loadDrivers);
    on<PickDLFront>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(dlFront: File(picked.path)));
      }
    });

    on<PickDLBack>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(dlBack: File(picked.path)));
      }
    });

    on<PickAadharFront>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(aadharFront: File(picked.path)));
      }
    });

    on<PickAadharBack>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(aadharBack: File(picked.path)));
      }
    });

    on<PickProfileImage>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(profileImage: File(picked.path)));
      }
    });

    on<DeleteDriver>(_deleteDriver);


  }

  Future<void> _deleteDriver(
      DeleteDriver event,
      Emitter<DriverState> emit,
      ) async {
    try {
      final success = await repo.deleteDriver(event.id);
      if(success){
        add(LoadDrivers());
      }
    } catch (e) {
      print("Error deleting driver: $e");
    }
  }

  Future<void> _submitDriver(
      SubmitDriver event,
      Emitter<DriverState> emit,
      ) async {
    emit(state.copyWith(loading: true, success: false));

    try {
      await repo.addDriver(
        fields: event.fields,
        files: event.files,
      );

      emit(state.copyWith(loading: false, success: true));
      add(LoadDrivers());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(success: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _loadDrivers(
      LoadDrivers event,
      Emitter<DriverState> emit,
      ) async {
    emit(state.copyWith(loading: true, success: false));

    try {
      final result = await repo.getDrivers();
      emit(state.copyWith(
          loading: false, drivers: result.drivers));
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }
}
