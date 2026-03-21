import 'dart:io';
import 'package:equatable/equatable.dart';
import '../model/getPaymentModel.dart';

class PaymentState extends Equatable {
  final bool loading;
  final bool loaded;
  final bool updated;
  final GetPaymentModel? payment;
  final String? error;
  final File? qrImage;

  const PaymentState({
    this.loading = false,
    this.loaded = false,
    this.updated = false,
    this.payment,
    this.error,
    this.qrImage,
  });

  PaymentState copyWith({
    bool? loading,
    bool? loaded,
    bool? updated,
    GetPaymentModel? payment,
    String? error,
    File? qrImage,
  }) {
    return PaymentState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      updated: updated ?? this.updated,
      payment: payment ?? this.payment,
      error: error,
      qrImage: qrImage ?? this.qrImage,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    loaded,
    updated,
    payment,
    error,
    qrImage,
  ];
}