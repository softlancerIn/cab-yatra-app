import 'dart:io';
import 'package:flutter/material.dart';

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

class PickSpecificDocument extends VehicleEvent {
  final String documentType; // 'insurance', 'rcFront', 'rcBack', 'car1', 'car2'
  PickSpecificDocument(this.documentType);
}

class LoadCarCategories extends VehicleEvent {
  final BuildContext context;
  LoadCarCategories(this.context);
}

class SelectCarCategory extends VehicleEvent {
  final int categoryId;
  SelectCarCategory(this.categoryId);
}

class UpdateVehicle extends VehicleEvent {
  final int id;
  final Map<String, dynamic> fields;
  final Map<String, File> files;
  UpdateVehicle(this.id, this.fields, this.files);
}

class FetchVehicleById extends VehicleEvent {
  final int id;
  FetchVehicleById(this.id);
}

class ResetVehicleForm extends VehicleEvent {}

