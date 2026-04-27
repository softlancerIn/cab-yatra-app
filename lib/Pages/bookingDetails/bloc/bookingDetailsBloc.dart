import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bookingDetailModel.dart';
import '../repo/bookingDetailRepo.dart';


import 'bookingDetailsEvent.dart';
import 'bookingDetailsState.dart';


class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  BookingDetailRepo repo = BookingDetailRepo();
//ResetDashboardEvent
  BookingDetailBloc() : super(const BookingDetailState()) {

    on<GetBookingDetailEvent>(getBookingDetailEvent);


    on<ResetBookingDetailEvent>((event, emit) {
      emit(const BookingDetailState()); // pura state reset
    });
  }

  Future<void> getBookingDetailEvent(
      GetBookingDetailEvent event,
      Emitter<BookingDetailState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await repo.getBookingDetailApi(context: event.context,bookingId: event.bookingId);
      if (response.status == true) {
        // --- NEW: Fetch Extra Profile/Review Data if Driver exists ---
        BookingDetailModel updatedModel = response;
        final driverId = response.driverDetails?.id.toString() ?? 
                         response.driverDetails?.driverId.toString() ??
                         response.data?.driverId.toString();

        if (driverId != null && driverId != "0") {
          final reviewData = await repo.getDriverReviews(driverId: driverId);
          if (reviewData['status'] == true) {
            final avgRating = double.tryParse(reviewData['average_rating']?.toString() ?? '0.0') ?? 5.0;
            final totalReviews = int.tryParse(reviewData['total_reviews']?.toString() ?? '0') ?? 0;
            
            // Merge into model if possible
            if (updatedModel.driverDetails != null) {
              final newDriver = BookingSubDriverDetail(
                id: updatedModel.driverDetails!.id,
                driverId: updatedModel.driverDetails!.driverId,
                name: updatedModel.driverDetails!.name,
                phoneNumber: updatedModel.driverDetails!.phoneNumber,
                driverImage: updatedModel.driverDetails!.driverImage,
                licenseNumber: updatedModel.driverDetails!.licenseNumber,
                cityName: updatedModel.driverDetails!.cityName,
                address: updatedModel.driverDetails!.address,
                dlFrontImage: updatedModel.driverDetails!.dlFrontImage,
                dlBackImage: updatedModel.driverDetails!.dlBackImage,
                aadharFrontImage: updatedModel.driverDetails!.aadharFrontImage,
                aadharBackImage: updatedModel.driverDetails!.aadharBackImage,
                rating: avgRating,
                reviewCount: totalReviews,
              );
              updatedModel = BookingDetailModel(
                status: updatedModel.status,
                message: updatedModel.message,
                data: updatedModel.data,
                driverDetails: newDriver,
              );
            }
          }
        }
        // -------------------------------------------------------------

        emit(state.copyWith(isLoading: false, bookingDetailModel: updatedModel));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: response.message));
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>get booking Data Exception Error>>>>$e");
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }






}
