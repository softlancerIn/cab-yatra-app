import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/cmsRepo.dart';
import 'cms_event.dart';
import 'cms_state.dart';

class CmsBloc extends Bloc<CmsEvent, CmsState> {

  final CmsRepo repo = CmsRepo();

  CmsBloc() : super(const CmsState()) {

    on<LoadCms>(_loadCms);

  }

  Future<void> _loadCms(
      LoadCms event,
      Emitter<CmsState> emit,
      ) async {

    try {

      emit(state.copyWith(isLoading: true));

      final response = await repo.getCms(
        context: event.context,
      );

      emit(state.copyWith(
        isLoading: false,
        cms: response,
      ));

    } catch (e) {

      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));

    }

  }

}