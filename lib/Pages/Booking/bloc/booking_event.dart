import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';




abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}







class GetPostedBooingEvent extends BookingEvent {
  final BuildContext context;

  const GetPostedBooingEvent({required this.context});

  @override
  List<Object?> get props => [context];
}







class ResetBookingEvent extends BookingEvent {
  const ResetBookingEvent();
}






