import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AddBookingEvent extends Equatable {
  const AddBookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadCarCategories extends AddBookingEvent {
  final BuildContext context;
  const LoadCarCategories(this.context);
  @override
  List<Object?> get props => [context];
}

class SelectCarCategory extends AddBookingEvent {
  final int carCategoryId;
  const SelectCarCategory(this.carCategoryId);
  @override
  List<Object?> get props => [carCategoryId];
}class UpdateAssignMethodEvent extends AddBookingEvent {
  final String assignType;
  final int bookingId;
  final BuildContext context;
  const UpdateAssignMethodEvent({required this.assignType, required this.bookingId, required this.context});
  @override
  List<Object?> get props => [assignType, bookingId, context];
}

class SubmitBooking extends AddBookingEvent {
  final String subType;               // "0", "1", etc.
  final int carCategoryId;
  final String pickUpDate;
  final String pickUpTime;
  final List<String> pickUpLocations;
  final List<String> destinationLocations;
  final List<String> pickupCity;
  final List<String> destinationCity;
  final double totalFare;
  final double driverCommission;
  final bool showPhoneNumber;
  final List<String> extra;
  final String remarks;
  final String noOfDay;
  final String tripNotes;
  final BuildContext context;

  const SubmitBooking({
    required this.subType,
    required this.carCategoryId,
    required this.tripNotes,
    required this.noOfDay,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.pickUpLocations,
    required this.destinationLocations,
    required this.pickupCity,
    required this.destinationCity,
    required this.totalFare,
    required this.driverCommission,
    required this.showPhoneNumber,
    required this.extra,
    required this.remarks,
    required this.context,
  });

  @override
  List<Object?> get props => [
    subType,
    carCategoryId,
    pickUpDate,
    pickUpTime,
    pickUpLocations,
    destinationLocations,
    pickupCity,
    destinationCity,
    totalFare,
    driverCommission,
    showPhoneNumber,
    extra,
    remarks,
    noOfDay,
    tripNotes
  ];
}

class ResetBooking extends AddBookingEvent {}