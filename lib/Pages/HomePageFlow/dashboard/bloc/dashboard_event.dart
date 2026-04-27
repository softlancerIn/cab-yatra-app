import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class GetHomeDataEvent extends DashboardEvent {
  final BuildContext context;
  const GetHomeDataEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class UpdateSearchQueryEvent extends DashboardEvent {
  final String searchQuery;
  const UpdateSearchQueryEvent({required this.searchQuery});
  @override
  List<Object?> get props => [searchQuery];
}

class UpdateFilterEvent extends DashboardEvent {
  final List<String>? vehicleTypes;
  final List<String>? pickupLocations;
  final String? dropLocation;
  const UpdateFilterEvent(
      {this.vehicleTypes, this.pickupLocations, this.dropLocation});
  @override
  List<Object?> get props => [vehicleTypes, pickupLocations, dropLocation];
}

class ClearFilterEvent extends DashboardEvent {
  const ClearFilterEvent();
}

class ResetDashboardEvent extends DashboardEvent {
  const ResetDashboardEvent();
}

class GetCitiesEvent extends DashboardEvent {
  final BuildContext context;
  const GetCitiesEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class GetCarCategoryEvent extends DashboardEvent {
  final BuildContext context;
  const GetCarCategoryEvent({required this.context});
  @override
  List<Object?> get props => [context];
}

class UpdateAlertsEvent extends DashboardEvent {
  final BuildContext context;
  final String alertType;    // "location_based"
  final List<int> carIds;
  final List<String> locations; // Location names as per API spec
  final String manualPickup; // "yes" or "no"
  final String status;       // "1" = active, "0" = inactive
  const UpdateAlertsEvent({
    required this.context,
    required this.alertType,
    required this.carIds,
    required this.locations,
    required this.manualPickup,
    required this.status,
  });
  @override
  List<Object?> get props => [context, alertType, carIds, locations, manualPickup, status];
}

class ClearAlertsEventApi extends DashboardEvent {
  final BuildContext context;
  const ClearAlertsEventApi({required this.context});
  @override
  List<Object?> get props => [context];
}

class GetAlertsEvent extends DashboardEvent {
  final BuildContext context;
  const GetAlertsEvent({required this.context});
  @override
  List<Object?> get props => [context];
}
