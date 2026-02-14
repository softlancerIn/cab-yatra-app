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
}

class SubmitBooking extends AddBookingEvent {
  final String subType;               // "0", "1", etc.
  final int carCategoryId;
  final String pickUpDate;
  final String pickUpTime;
  final List<String> pickUpLocations;
  final List<String> destinationLocations;
  final double totalFare;
  final double driverCommission;
  final bool showPhoneNumber;
  final String remarks;
  final BuildContext context;

  const SubmitBooking({
    required this.subType,
    required this.carCategoryId,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.pickUpLocations,
    required this.destinationLocations,
    required this.totalFare,
    required this.driverCommission,
    required this.showPhoneNumber,
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
    totalFare,
    driverCommission,
    showPhoneNumber,
    remarks,
  ];
}

class ResetBooking extends AddBookingEvent {}