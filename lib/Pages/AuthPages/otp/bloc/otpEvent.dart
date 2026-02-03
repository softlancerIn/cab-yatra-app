import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OTPEvent extends Equatable {
  const OTPEvent();

  @override
  List<Object?> get props => [];
}

class VerifyOtpEvent extends OTPEvent {
  final String mobileNumber;
  final String otp;
  final BuildContext context;

  const VerifyOtpEvent({required this.mobileNumber,required this.context,required this.otp});

  @override
  List<Object?> get props => [mobileNumber,context,otp];
}

class ResetVerifyOtpEvent extends OTPEvent {
  const ResetVerifyOtpEvent();
}
