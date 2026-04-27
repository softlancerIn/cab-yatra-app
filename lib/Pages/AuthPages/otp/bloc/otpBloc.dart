import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../repo/authRepo.dart';
import 'otpEvent.dart';
import 'otpState.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  AuthRepo authRepo = AuthRepo();

  OTPBloc() : super(const OTPState()) {
    on<ResetVerifyOtpEvent>((event, emit) {
      emit(const OTPState()); // pura state reset
    });
    on<VerifyOtpEvent>(_onSendOTPSubmitted);
  }

  Future<void> _onSendOTPSubmitted(
    VerifyOtpEvent event,
    Emitter<OTPState> emit,
  ) async {
    try {
      final response = await authRepo.verifyOtp(
        phone: event.mobileNumber,
        otp: event.otp,
        context: event.context,
      );

      if (response.status == true) {
        // Navigation is handled inside authRepo.verifyOtp for "Old" users
        // but we still emit success here.
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: response.message?.toString() ?? "Verification failed",
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
      
      emit(
        state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: message,
        ),
      );
    }
  }
}
