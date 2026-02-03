import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/dashboardRepo.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepo repo = DashboardRepo();
//ResetDashboardEvent
  DashboardBloc() : super(const DashboardState()) {
















    on<GetHomeDataEvent>(getHomeDataEvent);


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
