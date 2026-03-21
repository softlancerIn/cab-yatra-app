import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/dashboardModel.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/cityModel.dart';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/model/car_category_model.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/alert_response_model.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final HomePageResponse? homeDataResponseModel;
  final CityResponse? citiesResponseModel;
  final CarCategoryModel? carCategoryModel;
  final AlertResponseModel? alertResponseModel;
  final String searchQuery;
  final List<String>? selectedVehicleTypes;
  final List<String>? pickupLocationFilters;
  final List<String>? savedVehicleTypes;
  final List<String>? savedPickupLocations;
  final String? dropLocationFilter;
  final String? manuallyPickup;

  bool get isFilterActive =>
      (selectedVehicleTypes != null && selectedVehicleTypes!.isNotEmpty) ||
      (pickupLocationFilters != null && pickupLocationFilters!.isNotEmpty) ||
      (dropLocationFilter != null && dropLocationFilter!.isNotEmpty);

  const DashboardState({
    this.errorMessage,
    this.isLoading = false,
    this.homeDataResponseModel,
    this.citiesResponseModel,
    this.carCategoryModel,
    this.alertResponseModel,
    this.searchQuery = '',
    this.selectedVehicleTypes,
    this.pickupLocationFilters,
    this.savedVehicleTypes,
    this.savedPickupLocations,
    this.dropLocationFilter,
    this.manuallyPickup,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    HomePageResponse? homeDataResponseModel,
    CityResponse? citiesResponseModel,
    CarCategoryModel? carCategoryModel,
    AlertResponseModel? alertResponseModel,
    String? searchQuery,
    List<String>? selectedVehicleTypes,
    List<String>? pickupLocationFilters,
    List<String>? savedVehicleTypes,
    List<String>? savedPickupLocations,
    String? dropLocationFilter,
    String? manuallyPickup,
    bool clearVehicleType = false,
    bool clearPickupLocation = false,
    bool clearDropLocation = false,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      homeDataResponseModel: homeDataResponseModel ?? this.homeDataResponseModel,
      citiesResponseModel: citiesResponseModel ?? this.citiesResponseModel,
      carCategoryModel: carCategoryModel ?? this.carCategoryModel,
      alertResponseModel: alertResponseModel ?? this.alertResponseModel,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedVehicleTypes:
          clearVehicleType ? null : (selectedVehicleTypes ?? this.selectedVehicleTypes),
      pickupLocationFilters:
          clearPickupLocation ? null : (pickupLocationFilters ?? this.pickupLocationFilters),
      savedVehicleTypes: savedVehicleTypes ?? this.savedVehicleTypes,
      savedPickupLocations: savedPickupLocations ?? this.savedPickupLocations,
      dropLocationFilter:
          clearDropLocation ? null : (dropLocationFilter ?? this.dropLocationFilter),
      manuallyPickup: manuallyPickup ?? this.manuallyPickup,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        homeDataResponseModel,
        citiesResponseModel,
        carCategoryModel,
        alertResponseModel,
        searchQuery,
        selectedVehicleTypes,
        pickupLocationFilters,
        savedVehicleTypes,
        savedPickupLocations,
        dropLocationFilter,
        manuallyPickup,
      ];
}
