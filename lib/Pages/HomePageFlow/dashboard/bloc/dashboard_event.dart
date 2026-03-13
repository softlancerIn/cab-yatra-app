import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_state.dart';

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
  final String? vehicleType;
  final String? pickupLocation;
  final String? dropLocation;
  const UpdateFilterEvent({this.vehicleType, this.pickupLocation, this.dropLocation});
  @override
  List<Object?> get props => [vehicleType, pickupLocation, dropLocation];
}

class ClearFilterEvent extends DashboardEvent {
  const ClearFilterEvent();
}

class ResetDashboardEvent extends DashboardEvent {
  const ResetDashboardEvent();
}






