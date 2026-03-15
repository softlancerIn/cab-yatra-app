import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/profileRepo.dart';
import 'personal_info_event.dart';
import 'personal_info_state.dart';
class PersonalInfoBloc
    extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  final ProfileRepo repo=ProfileRepo();

  PersonalInfoBloc()
      : super(const PersonalInfoState()) {

    on<LoadProfile>(_onLoadProfile);
    on<SubmitPressed>(_onSubmit);
    on<TypeChanged>((event, emit) {
      emit(state.copyWith(type: event.type));
    });
    on<ImageChanged>((event, emit) {
      emit(state.copyWith(image: event.image));
    });
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<PersonalInfoState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await repo.getProfile(
        context: event.context,
      );

      final data = response.data;
      emit(state.copyWith(
        name: data?.name ?? "Name",
        company: data?.cInfo ?? "Remark",
        phone: data?.phone ?? "00000000",
        type: data?.type?.toLowerCase() ?? "agent",
        networkImage: data?.driverImageUrl,
        licenseNumber2: data?.licenseNumber2,
        licenseNumber: data?.licenseNumber,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSubmit(
      SubmitPressed event,
      Emitter<PersonalInfoState> emit,
      ) async {
    try {
      emit(state.copyWith(isSubmitting: true));
      final updateResponse = await repo.updateProfile(
        context: event.context,
        type: event.type,
        name: event.name,
        licenseNumber: event.licenseNumber,
        licenseNumber2: event.licenseNumber2,
        cInfo: event.cInfo,
        driverImage: event.driverImage,
      );
      // Update state with new profile info from API response
      final updatedData = updateResponse.data;
      emit(state.copyWith(
        isSubmitting: false,
        name: updatedData?.name ?? event.name,
        company: updatedData?.cInfo ?? event.cInfo,
        type: updatedData?.type?.toLowerCase() ?? event.type,
        licenseNumber: updatedData?.licenseNumber ?? event.licenseNumber,
        licenseNumber2: updatedData?.licenseNumber2 ?? event.licenseNumber2,
        networkImage: updatedData?.driverImageUrl ?? state.networkImage,
      ));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
