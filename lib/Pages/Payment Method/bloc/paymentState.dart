import 'dart:io';
import 'package:equatable/equatable.dart';
import '../model/getPaymentModel.dart';

class PaymentState extends Equatable {
  final bool loading;
  final bool success;
  final GetPaymentModel? payment;
  final String? error;
  final File? qrImage;

  const PaymentState({
    this.loading = false,
    this.success = false,
    this.payment,
    this.error,
    this.qrImage,
  });

  PaymentState copyWith({
    bool? loading,
    bool? success,
    GetPaymentModel? payment,
    String? error,
    File? qrImage,
  }) {
    return PaymentState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      payment: payment ?? this.payment,
      error: error,
      qrImage: qrImage ?? this.qrImage,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    success,
    payment,
    error,
    qrImage,
  ];
}