import '../dashboardModel.dart';

import 'package:equatable/equatable.dart';


class DashboardState extends Equatable {

  final bool isLoading;
  final String? errorMessage;

  final HomePageResponse? homeDataResponseModel;
  final String searchQuery;
  final String? selectedVehicleType;
  final String? pickupLocationFilter;
  final String? dropLocationFilter;


  const DashboardState({

    this.errorMessage,
    this.isLoading = false,

    this.homeDataResponseModel,
    this.searchQuery = '',
    this.selectedVehicleType,
    this.pickupLocationFilter,
    this.dropLocationFilter,


  });

  DashboardState copyWith({

    bool? isLoading,
    String? errorMessage,

    HomePageResponse? homeDataResponseModel,
    String? searchQuery,
    String? selectedVehicleType,
    String? pickupLocationFilter,
    String? dropLocationFilter,

  }) {
    return DashboardState(

      isLoading: isLoading??this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,

      homeDataResponseModel: homeDataResponseModel ?? this.homeDataResponseModel,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      pickupLocationFilter: pickupLocationFilter ?? this.pickupLocationFilter,
      dropLocationFilter: dropLocationFilter ?? this.dropLocationFilter,


    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,

    homeDataResponseModel,
    searchQuery,
    selectedVehicleType,
    pickupLocationFilter,
    dropLocationFilter,

  ];
}
