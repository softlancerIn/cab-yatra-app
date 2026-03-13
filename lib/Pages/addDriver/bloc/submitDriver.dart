import 'dart:io';

abstract class DriverEvent {}

class SubmitDriver extends DriverEvent {
  final Map<String, dynamic> fields;
  final Map<String, File> files;

  SubmitDriver(this.fields, this.files);
}

class LoadDrivers extends DriverEvent {}


class PickDLFront extends DriverEvent {}
class PickDLBack extends DriverEvent {}
class PickAadharFront extends DriverEvent {}
class PickAadharBack extends DriverEvent {}

class DeleteDriver extends DriverEvent {
  final int id;
  DeleteDriver(this.id);
}
