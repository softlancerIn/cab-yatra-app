import 'dart:io';

import 'package:cab_taxi_app/Pages/Payment%20Method/bloc/paymentEvent.dart';
import 'package:cab_taxi_app/Pages/Payment%20Method/bloc/paymentState.dart';
import 'package:cab_taxi_app/Pages/addDriver/bloc/submitDriver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../repo/paymentRepo.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepo repo = PaymentRepo();
  final ImagePicker _picker = ImagePicker();

  PaymentBloc() : super(const PaymentState()) {
    on<SubmitPayment>(_submitPayment);
    on<LoadPayment>(_loadPayment);

    on<PickQrImage>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(state.copyWith(qrImage: File(picked.path)));
      }
    });
  }

  Future<void> _submitPayment(
    SubmitPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await repo.addPaymentApi(
        fields: event.fields,
        files: event.files,
      );

      // Success true karo
      emit(state.copyWith(loading: false, success: true));

      // 300ms wait
      await Future.delayed(const Duration(milliseconds: 300));

      // Success false karo (reset)
      emit(state.copyWith(success: false));

      // Reload payment list
      add(LoadPayment());
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
        success: false,
      ));
    }
  }

  Future<void> _loadPayment(
    LoadPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      final result = await repo.getPaymentApi();
      emit(state.copyWith(loading: false, success: true, payment: result));
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }
}
