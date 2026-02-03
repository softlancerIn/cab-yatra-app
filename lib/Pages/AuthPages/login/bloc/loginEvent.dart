import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends SignInEvent {
  final String mobileNumber;
  final BuildContext context;

  const SendOtpEvent({required this.mobileNumber,required this.context});

  @override
  List<Object?> get props => [mobileNumber,context];
}

class ResetSendOtpEvent extends SignInEvent {
  const ResetSendOtpEvent();
}
