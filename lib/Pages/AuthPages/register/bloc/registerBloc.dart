import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../repo/authRepo.dart';
import 'registerEvent.dart';
import 'registerState.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepo authRepo = AuthRepo();

  RegisterBloc() : super(const RegisterState()) {
    on<ResetRegisterEvent>((event, emit) {
      emit(const RegisterState()); // pura state reset
    });
    on<RegisterSummitedEvent>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSummitedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await authRepo.registerOtp(
        mobile: event.mobile,
        name: event.name,
        city: event.city,
        otp: event.otp,
        context: event.context,
      );
      if (response.status == true) {
        emit(
          state.copyWith(
            errorMessage:
                response.message ?? "Driver account created successfully!",
            isLoading: false,
            isSuccess: true,
          ),
        );
        Nav.go(event.context, Routes.home);
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Invalid credentials",
            hasError: true,
          ),
        );
      }
    } catch (e) {
      String message = "Something went wrong";
      if (e is DioException) {
        if (e.response?.data != null && e.response?.data is Map) {
          message = e.response?.data['message']?.toString() ?? message;
        } else {
          message = e.message ?? message;
        }
      } else {
        message = e.toString();
      }
      emit(state.copyWith(isLoading: false, errorMessage: message, hasError: true));
    }
  }
}
