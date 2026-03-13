import 'dart:io';

abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {}

class DeleteVehicle extends VehicleEvent {
  final int id;
  DeleteVehicle(this.id);
}

class AddVehicle extends VehicleEvent {
  final Map<String, dynamic> fields;
  final Map<String, File> files;
  AddVehicle(this.fields, this.files);
}

class PickVehicleImage extends VehicleEvent {}
