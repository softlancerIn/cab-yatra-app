import 'package:equatable/equatable.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class PersonalInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameChanged extends PersonalInfoEvent {
  final String name;
  NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class CompanyChanged extends PersonalInfoEvent {
  final String company;
  CompanyChanged(this.company);

  @override
  List<Object?> get props => [company];
}

class RoleChanged extends PersonalInfoEvent {
  final String role;
  RoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

class ImageChanged extends PersonalInfoEvent {
  final File image;
  ImageChanged(this.image);

  @override
  List<Object?> get props => [image];
}

class SubmitPressed extends PersonalInfoEvent {
  final String type;
  final BuildContext context;
  final String name;
  final String licenseNumber;
  final String licenseNumber2;
  final File? driverImage;
  final String cInfo;
  SubmitPressed({required this.licenseNumber,required this.context,required this.name,required this.type,required this.cInfo, this.driverImage,required this.licenseNumber2});

  @override
  List<Object?> get props => [licenseNumber,name,type,cInfo,driverImage,licenseNumber2,context];}
class LoadProfile extends PersonalInfoEvent {
  final BuildContext context;
  LoadProfile(this.context);

  @override
  List<Object?> get props => [context];
}
