import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EditBookingEvent extends Equatable {
  const EditBookingEvent();
  @override
  List<Object?> get props => [];
}

class EditLoadCarCategories extends EditBookingEvent {
  final BuildContext context;
  final int? initialCarCategoryId;
  const EditLoadCarCategories(this.context, {this.initialCarCategoryId});
  @override
  List<Object?> get props => [context, initialCarCategoryId];
}

class EditSelectCarCategory extends EditBookingEvent {
  final int carCategoryId;
  const EditSelectCarCategory(this.carCategoryId);
  @override
  List<Object?> get props => [carCategoryId];
}

class EditSubmitBooking extends EditBookingEvent {
  final String id;
  final String subType;
  final int carCategoryId;
  final String pickUpDate;
  final String pickUpTime;
  final List<String> pickUpLocations;
  final List<String> destinationLocations;
  final double totalFare;
  final double driverCommission;
  final bool showPhoneNumber;
  final String remarks;
  final String? noOfDays;
  final String? tripNotes;
  final BuildContext context;

  const EditSubmitBooking({
    required this.id,
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
    this.noOfDays,
    this.tripNotes,
    required this.context,
  });

  @override
  List<Object?> get props => [
    id,
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
    noOfDays,
    tripNotes,
  ];
}

class ResetBooking extends EditBookingEvent {}

class EditUpdateAssignMethodEvent extends EditBookingEvent {
  final BuildContext context;
  final String assignType;
  const EditUpdateAssignMethodEvent({required this.context, required this.assignType});
  @override
  List<Object?> get props => [context, assignType];
}