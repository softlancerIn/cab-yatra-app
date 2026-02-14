

import 'package:equatable/equatable.dart';

import '../model/postBookingListModel.dart';


class BookingState extends Equatable {

  final bool isLoading;
  final String? errorMessage;

  final PostedBookingModel? postedBookingModel;


  const BookingState({

    this.errorMessage,
    this.isLoading = false,

    this.postedBookingModel,


  });

  BookingState copyWith({

    bool? isLoading,
    String? errorMessage,

    PostedBookingModel? postedBookingModel,

  }) {
    return BookingState(

      isLoading: isLoading??this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,

      postedBookingModel: postedBookingModel ?? this.postedBookingModel,


    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,

    postedBookingModel,

  ];
}


