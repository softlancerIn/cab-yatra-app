import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/repo/dashboardRepo.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/cityModel.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/alert_response_model.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_event.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_state.dart';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/model/car_category_model.dart';

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
        selectedVehicleTypes: event.vehicleTypes,
        pickupLocationFilters: event.pickupLocations,
        dropLocationFilter: event.dropLocation,
        clearVehicleType: event.vehicleTypes == null,
        clearPickupLocation: event.pickupLocations == null,
        clearDropLocation: event.dropLocation == null,
      ));
    });

    on<ClearFilterEvent>((event, emit) {
      emit(state.copyWith(
        searchQuery: '',
        clearVehicleType: true,
        clearPickupLocation: true,
        clearDropLocation: true,
      ));
    });

    on<ResetDashboardEvent>((event, emit) {
      emit(const DashboardState()); // pura state reset
    });

    on<GetCitiesEvent>(getCitiesEvent);
    on<GetCarCategoryEvent>(getCarCategoryEvent);
    on<GetAlertsEvent>(getAlertsEvent);
    on<UpdateAlertsEvent>(updateAlertsEvent);
    on<ClearAlertsEventApi>(clearAlertsEvent);
  }

  Future<void> getAlertsEvent(
    GetAlertsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getAlertsApi(context: event.context);
      if (response.status == true) {
        // Use the parsed helpers from AlertData to get List<int> IDs
        final carIdList = response.data?.parsedCarsId ?? [];
        final locationIdList = response.data?.parsedLocations ?? [];

        List<String> vehicleNames = [];
        List<String> locationNames = [];

        for (var id in carIdList) {
          final match = state.carCategoryModel?.data?.firstWhere(
            (c) => c.id == id,
            orElse: () => Data(id: -1),
          );
          if (match != null && match.id != -1 && match.name != null) {
            vehicleNames.add(match.name!);
          }
        }

        for (var name in locationIdList) {
          locationNames.add(name);
        }

        emit(state.copyWith(
          isLoading: false,
          alertResponseModel: response,
          savedVehicleTypes: vehicleNames,
          savedPickupLocations: locationNames,
          manuallyPickup: response.data?.manuallyPickup,
        ));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getCitiesEvent(
    GetCitiesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getCitiesApi(context: event.context);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false, citiesResponseModel: response));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      print(">>>>>>>>>>>>>>>>>>get Cities Data Exception Error>>>>$e");
    }
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
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      print(">>>>>>>>>>>>>>>>>>get Home Data Exception Error>>>>$e");
    }
  }





  Future<void> getCarCategoryEvent(
    GetCarCategoryEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getCarCategoryApi(context: event.context);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false, carCategoryModel: response));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> updateAlertsEvent(
    UpdateAlertsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      // Build payload matching the API spec exactly
      final data = {
        "aleart_type": event.alertType,
        "cars_id": event.carIds,        // List<int>
        "locations": event.locations,   // List<int>
        "manually_pickup": event.manualPickup,
        "status": event.status,         // "1" or "0"
      };
      final response = await repo.updateAlertsApi(context: event.context, data: data);
      if (response['status'] == true) {
        // OPTIMISTICALLY Update local state so UI reflects change instantly
        if (state.alertResponseModel?.data != null) {
          final updatedData = state.alertResponseModel!.data!;
          updatedData.status = event.status;
          updatedData.carsId = jsonEncode(event.carIds);
          updatedData.locations = jsonEncode(event.locations);
          updatedData.manuallyPickup = event.manualPickup;
          
          emit(state.copyWith(
            isLoading: false,
            alertResponseModel: AlertResponseModel(
              status: true,
              message: "Updated",
              data: updatedData,
            )
          ));
        }

        add(GetAlertsEvent(context: event.context));
        add(GetHomeDataEvent(context: event.context));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response['message']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> clearAlertsEvent(
    ClearAlertsEventApi event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.clearAlertsApi(context: event.context);
      if (response['status'] == true) {
        // OPTIMISTICALLY Update local state to status 0
        if (state.alertResponseModel?.data != null) {
          final updatedData = state.alertResponseModel!.data!;
          updatedData.status = "0";
          updatedData.carsId = "[]";
          updatedData.locations = "[]";
          
          emit(state.copyWith(
            isLoading: false,
            alertResponseModel: AlertResponseModel(
              status: true,
              message: "Cleared",
              data: updatedData,
            )
          ));
        }

        add(GetAlertsEvent(context: event.context));
        add(GetHomeDataEvent(context: event.context)); // Refresh data
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response['message']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
