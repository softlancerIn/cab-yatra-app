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
  final String id;               // "0", "1", etc.
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

class ResetBooking extends EditBookingEvent {}