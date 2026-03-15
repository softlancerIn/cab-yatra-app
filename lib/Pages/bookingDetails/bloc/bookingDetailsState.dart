
import 'package:equatable/equatable.dart';

import '../model/bookingDetailModel.dart';


class BookingDetailState extends Equatable {

  final bool isLoading;
  final String? errorMessage;

  final BookingDetailModel? bookingDetailModel;


  const BookingDetailState({

    this.errorMessage,
    this.isLoading = false,

    this.bookingDetailModel,


  });

  BookingDetailState copyWith({

    bool? isLoading,
    String? errorMessage,

    BookingDetailModel? bookingDetailModel,

  }) {
    return BookingDetailState(

      isLoading: isLoading??this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,

      bookingDetailModel: bookingDetailModel ?? this.bookingDetailModel,


    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,

    bookingDetailModel,

  ];
}


