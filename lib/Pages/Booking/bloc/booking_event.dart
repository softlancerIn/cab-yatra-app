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
}class DeleteBooingEvent extends BookingEvent {
  final BuildContext context;
  final String bookingId;

  const DeleteBooingEvent({required this.context,required this.bookingId});

  @override
  List<Object?> get props => [context,bookingId];
}







class RESETBookingEvent extends BookingEvent {
  const RESETBookingEvent();
}

class UpdatePostedBookingSearchQueryEvent extends BookingEvent {
  final String searchQuery;

  const UpdatePostedBookingSearchQueryEvent({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}






