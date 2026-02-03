import '../dashboardModel.dart';

import 'package:equatable/equatable.dart';


class DashboardState extends Equatable {

  final bool isLoading;
  final String? errorMessage;

  final HomePageResponse? homeDataResponseModel;


  const DashboardState({

    this.errorMessage,
    this.isLoading = false,

    this.homeDataResponseModel,


  });

  DashboardState copyWith({

    bool? isLoading,
    String? errorMessage,

    HomePageResponse? homeDataResponseModel,

  }) {
    return DashboardState(

      isLoading: isLoading??this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,

      homeDataResponseModel: homeDataResponseModel ?? this.homeDataResponseModel,


    );
  }


  @override
  List<Object?> get props => [

    isLoading,
    errorMessage,

    homeDataResponseModel,

  ];
}


