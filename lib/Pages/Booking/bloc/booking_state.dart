

import 'package:equatable/equatable.dart';

import '../model/deletePostedBookingModel.dart';
import '../model/postBookingListModel.dart';


class BookingState extends Equatable {

  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  final PostedBookingModel? postedBookingModel;
  final DeletePostedBookingModel? deletePostedBookingModel;
  final List<String>? selectedVehicleTypes;
  final List<String>? pickupLocationFilters;
  final String? dropLocationFilter;
  final String? bookingStatusFilter;

  bool get isFilterActive =>
      (selectedVehicleTypes != null && selectedVehicleTypes!.isNotEmpty) ||
      (pickupLocationFilters != null && pickupLocationFilters!.isNotEmpty) ||
      (dropLocationFilter != null && dropLocationFilter!.isNotEmpty) ||
      (bookingStatusFilter != null && bookingStatusFilter!.isNotEmpty);


  const BookingState({

    this.errorMessage,
    this.isLoading = false,
    this.searchQuery = '',

    this.postedBookingModel,
    this.deletePostedBookingModel,
    this.selectedVehicleTypes,
    this.pickupLocationFilters,
    this.dropLocationFilter,
    this.bookingStatusFilter,
  });

  BookingState copyWith({

    bool? isLoading,
    String? errorMessage,
    String? searchQuery,

    PostedBookingModel? postedBookingModel,
    DeletePostedBookingModel? deletePostedBookingModel,
    List<String>? selectedVehicleTypes,
    List<String>? pickupLocationFilters,
    String? dropLocationFilter,
    String? bookingStatusFilter,
    bool clearVehicleType = false,
    bool clearPickupLocation = false,
    bool clearDropLocation = false,
    bool clearBookingStatus = false,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      postedBookingModel: postedBookingModel ?? this.postedBookingModel,
      deletePostedBookingModel:
          deletePostedBookingModel ?? this.deletePostedBookingModel,
      selectedVehicleTypes: clearVehicleType
          ? null
          : (selectedVehicleTypes ?? this.selectedVehicleTypes),
      pickupLocationFilters: clearPickupLocation
          ? null
          : (pickupLocationFilters ?? this.pickupLocationFilters),
      dropLocationFilter: clearDropLocation
          ? null
          : (dropLocationFilter ?? this.dropLocationFilter),
      bookingStatusFilter: clearBookingStatus
          ? null
          : (bookingStatusFilter ?? this.bookingStatusFilter),
    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,
    searchQuery,

    postedBookingModel,
    deletePostedBookingModel,
    selectedVehicleTypes,
    pickupLocationFilters,
    dropLocationFilter,
    bookingStatusFilter,
  ];
}


