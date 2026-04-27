import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final bool hasError;
  final bool isLoading;
  final bool isSuccess;
  final bool? isRegistered;
  final String? errorMessage;

  const SignInState({
    this.errorMessage,
    this.isLoading = false,
    this.hasError = false,
    this.isSuccess = false,
    this.isRegistered,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? hasError,
    bool? isRegistered,
    String? errorMessage,
  }) {
    return SignInState(
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isRegistered: isRegistered ?? this.isRegistered,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, hasError, isSuccess, isRegistered];
}
