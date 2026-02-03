import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


import 'dashboard_state.dart';

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







class ResetDashboardEvent extends DashboardEvent {
  const ResetDashboardEvent();
}






