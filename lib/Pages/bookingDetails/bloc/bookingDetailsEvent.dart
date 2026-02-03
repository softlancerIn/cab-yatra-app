import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class BookingDetailEvent extends Equatable {
  const BookingDetailEvent();

  @override
  List<Object?> get props => [];
}







class GetBookingDetailEvent extends BookingDetailEvent {
  final BuildContext context;
  final String bookingId;

  const GetBookingDetailEvent({required this.context,required this.bookingId});

  @override
  List<Object?> get props => [context,bookingId];
}







class ResetBookingDetailEvent extends BookingDetailEvent {
   ResetBookingDetailEvent();
}






