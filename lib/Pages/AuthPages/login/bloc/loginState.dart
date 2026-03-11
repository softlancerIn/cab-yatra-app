import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final bool hasError;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SignInState({
    this.errorMessage,
    this.isLoading = false,
    this.hasError = false,
    this.isSuccess = false,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? hasError,
    String? errorMessage,
  }) {
    return SignInState(
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, hasError, isSuccess];
}
