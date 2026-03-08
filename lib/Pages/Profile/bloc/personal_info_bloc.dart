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
    on<RoleChanged>((event, emit) {
      emit(state.copyWith(role: event.role));
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
      print("😍😍😍😍😍😍😍 Name is : ${data!.name}");
      print("😍😍😍😍😍😍😍 cInfo is : ${data.cInfo}");
      print("😍😍😍😍😍😍😍 type is : ${data.type}");
      print("😍😍😍😍😍😍😍 driverImageUrl is : ${data.driverImageUrl}");

      emit(state.copyWith(
        name: data.name ?? "Name",
        company: data.cInfo ?? "Remark",
        phone: data.phone ?? "00000000",
        role: data.type?.toLowerCase() ?? "agent",
        networkImage: data.driverImageUrl,
        licenseNumber2: data.licenseNumber2,
        licenseNumber: data.licenseNumber,

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

      await repo.updateProfile(
        context: event.context,
        type: event.type,
        name: event.name,
        licenseNumber: event.licenseNumber,
        licenseNumber2: event.licenseNumber2,
        cInfo: event.cInfo,
        driverImage: event.driverImage,
      );

      emit(state.copyWith(isSubmitting: false));
      on<LoadProfile>(_onLoadProfile);
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
