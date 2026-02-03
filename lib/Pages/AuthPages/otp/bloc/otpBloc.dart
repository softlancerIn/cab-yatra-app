import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../repo/authRepo.dart';
import 'otpEvent.dart';
import 'otpState.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  AuthRepo authRepo = AuthRepo();

  OTPBloc() : super(OTPState()) {
    on<ResetVerifyOtpEvent>((event, emit) {
      emit(OTPState()); // pura state reset
    });
    on<VerifyOtpEvent>(_onSendOTPSubmitted);
  }

  Future<void> _onSendOTPSubmitted(
      VerifyOtpEvent event,
      Emitter<OTPState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, hasError: false));


      final response = await authRepo.verifyOtp(
        phone: event.mobileNumber,
        otp: event.otp,
        context: event.context,
      );

      if (response.status == true) {
        Nav.go(event.context, Routes.home);
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
            errorMessage: response.message, // 👈 API message
          ),
        );
      }

  }

}
