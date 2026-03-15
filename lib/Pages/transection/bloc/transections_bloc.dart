import 'package:cab_taxi_app/Pages/transection/bloc/transections_event.dart';
import 'package:cab_taxi_app/Pages/transection/bloc/transections_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/TransectionRepo.dart';

class TransectionsBloc
    extends Bloc<TransectionsEvent, TransectionsState> {
  final TransectionRepo repo=TransectionRepo();

  TransectionsBloc()
      : super(const TransectionsState()) {

    on<LoadTransections>(_onLoadProfile);

  }

  Future<void> _onLoadProfile(
      LoadTransections event,
      Emitter<TransectionsState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await repo.getTransction(
        context: event.context,
      );

      final data = response.data;
      print("😍😍😍😍😍😍😍 Name is :dffgdfgdfg");


      emit(state.copyWith(
         getTransectionModel: response,


        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }


}
