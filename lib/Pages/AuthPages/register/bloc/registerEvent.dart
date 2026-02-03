import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSummitedEvent extends RegisterEvent {
  final String mobile;
  final String otp;
  final String name;
  final String city;
  final BuildContext context;


  const RegisterSummitedEvent({required this.mobile,required this.context,required this.name,required this.city,required this.otp});

  @override
  List<Object?> get props => [name,context,mobile,city,otp];
}

class ResetRegisterEvent extends RegisterEvent {
  const ResetRegisterEvent();
}
