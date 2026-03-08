

import 'package:equatable/equatable.dart';

import '../model/deletePostedBookingModel.dart';
import '../model/postBookingListModel.dart';


class BookingState extends Equatable {

  final bool isLoading;
  final String? errorMessage;

  final PostedBookingModel? postedBookingModel;
  final DeletePostedBookingModel? deletePostedBookingModel;


  const BookingState({

    this.errorMessage,
    this.isLoading = false,

    this.postedBookingModel,
    this.deletePostedBookingModel,


  });

  BookingState copyWith({

    bool? isLoading,
    String? errorMessage,

    PostedBookingModel? postedBookingModel,
    DeletePostedBookingModel? deletePostedBookingModel,

  }) {
    return BookingState(

      isLoading: isLoading??this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,

      postedBookingModel: postedBookingModel ?? this.postedBookingModel,
      deletePostedBookingModel: deletePostedBookingModel ?? this.deletePostedBookingModel,


    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,

    postedBookingModel,deletePostedBookingModel

  ];
}


