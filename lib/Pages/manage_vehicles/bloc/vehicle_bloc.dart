import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../repo/vehicle_repo.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepo repo = VehicleRepo();
  final ImagePicker _picker = ImagePicker();

  VehicleBloc() : super(VehicleState()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<DeleteVehicle>(_onDeleteVehicle);
    on<AddVehicle>(_onAddVehicle);
    on<PickVehicleImage>(_onPickImage);
  }

  Future<void> _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await repo.getVehicles();
      emit(state.copyWith(isLoading: false, vehicles: result.vehicles));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    try {
      final success = await repo.deleteVehicle(event.id);
      if (success) {
        add(LoadVehicles());
      }
    } catch (e) {
      print("Error deleting vehicle: $e");
    }
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final success = await repo.addVehicle(fields: event.fields, files: event.files);
      if (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(LoadVehicles());
      } else {
        emit(state.copyWith(isLoading: false, error: "Failed to add vehicle"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onPickImage(PickVehicleImage event, Emitter<VehicleState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(vehicleImage: File(pickedFile.path)));
    }
  }
}
