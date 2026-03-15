import 'dart:io';

abstract class PaymentEvent {}

class SubmitPayment extends PaymentEvent {
  final Map<String, dynamic> fields;
  final Map<String, File> files;

  SubmitPayment({required this.fields, required this.files});
}

class LoadPayment extends PaymentEvent {}

class PickQrImage extends PaymentEvent {}