import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/dashboardRepo.dart';

import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_event.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_state.dart';

export 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_event.dart';
export 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepo repo = DashboardRepo();
//ResetDashboardEvent
  DashboardBloc() : super(const DashboardState()) {
















    on<GetHomeDataEvent>(getHomeDataEvent);

    on<UpdateSearchQueryEvent>((event, emit) {
      emit(state.copyWith(searchQuery: event.searchQuery));
    });

    on<UpdateFilterEvent>((event, emit) {
      emit(state.copyWith(
        selectedVehicleType: event.vehicleType,
        pickupLocationFilter: event.pickupLocation,
        dropLocationFilter: event.dropLocation,
      ));
    });

    on<ClearFilterEvent>((event, emit) {
      emit(state.copyWith(
        searchQuery: '',
        selectedVehicleType: null,
        pickupLocationFilter: null,
        dropLocationFilter: null,
      ));
    });

    on<ResetDashboardEvent>((event, emit) {
      emit(const DashboardState()); // pura state reset
    });
  }

  Future<void> getHomeDataEvent(
    GetHomeDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getHomeDataApi(context: event.context);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false, homeDataResponseModel: response));
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>get Home Data Exception Error>>>>$e");
    }
  }






}
