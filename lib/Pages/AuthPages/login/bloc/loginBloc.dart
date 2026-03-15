import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/navigation/routes.dart';
import '../../repo/authRepo.dart';
import 'loginEvent.dart';
import 'loginState.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  AuthRepo authRepo = AuthRepo();

  SignInBloc() : super(SignInState()) {
    on<ResetSendOtpEvent>((event, emit) {
      emit(SignInState()); // pura state reset
    });
    on<SendOtpEvent>(_onSendOTPSubmitted);
  }

  Future<void> _onSendOTPSubmitted(
    SendOtpEvent event,
    Emitter<SignInState> emit,
  ) async {
    if (event.mobileNumber.trim().isEmpty || event.mobileNumber.length != 10) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Enter a valid 10 digit mobile number",
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final response = await authRepo.sendOtp(
        phone: event.mobileNumber,
        context: event.context,
      );
      if (response.status == true) {
        // Nav.push(event.context,Routes.otp,extra: {
        //
        //
        // });
        //  Nav.go(context, Router.)
        emit(
          state.copyWith(
            errorMessage: "Send OTP Successfully",
            isLoading: false,
            isSuccess: true,
          ),
        );
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
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
