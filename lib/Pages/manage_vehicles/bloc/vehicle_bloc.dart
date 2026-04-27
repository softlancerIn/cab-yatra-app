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
    on<PickSpecificDocument>(_onPickSpecificDocument);
    on<LoadCarCategories>(_onLoadCarCategories);
    on<SelectCarCategory>(_onSelectCarCategory);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<FetchVehicleById>(_onFetchVehicleById);
    on<ResetVehicleForm>((event, emit) {
      emit(state.copyWith(clearFiles: true));
    });
  }

  Future<void> _onFetchVehicleById(FetchVehicleById event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isFetching: true));
    try {
      final result = await repo.getVehicleById(event.id);
      emit(state.copyWith(isFetching: false, selectedVehicle: result["data"]));
    } catch (e) {
      emit(state.copyWith(isFetching: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      final success = await repo.updateVehicle(id: event.id, fields: event.fields, files: event.files);
      if (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(LoadVehicles());
        await Future.delayed(const Duration(milliseconds: 300));
        emit(state.copyWith(isSuccess: false));
      } else {
        emit(state.copyWith(isLoading: false, error: "Failed to update vehicle"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(isSuccess: false));
    }
  }

  Future<void> _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));
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
    emit(state.copyWith(isLoading: true, isSuccess: false));
    try {
      final success = await repo.addVehicle(fields: event.fields, files: event.files);
      if (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(LoadVehicles()); // Assuming LoadVehicles() is correct here, not LoadDrivers()
        await Future.delayed(const Duration(milliseconds: 300));
        emit(state.copyWith(isSuccess: false));
      } else {
        emit(state.copyWith(isLoading: false, error: "Failed to add vehicle"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(isSuccess: false));
    }
  }

  Future<void> _onPickImage(PickVehicleImage event, Emitter<VehicleState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(vehicleImage: File(pickedFile.path)));
    }
  }

  Future<void> _onPickSpecificDocument(PickSpecificDocument event, Emitter<VehicleState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      switch (event.documentType) {
        case 'insurance':
          emit(state.copyWith(insuranceImage: file));
          break;
        case 'rcFront':
          emit(state.copyWith(rcFrontImage: file));
          break;
        case 'rcBack':
          emit(state.copyWith(rcBackImage: file));
          break;
        case 'car1':
          emit(state.copyWith(carImage1: file));
          break;
        case 'car2':
          emit(state.copyWith(carImage2: file));
          break;
      }
    }
  }

  Future<void> _onLoadCarCategories(LoadCarCategories event, Emitter<VehicleState> emit) async {
    try {
      final categories = await repo.getCarCategory(context: event.context);
      emit(state.copyWith(carCategories: categories));
    } catch (e) {
      print("Failed to load car categories: $e");
    }
  }

  void _onSelectCarCategory(SelectCarCategory event, Emitter<VehicleState> emit) {
    emit(state.copyWith(selectedCarCategoryId: event.categoryId));
  }
}

