import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final bool isSuccess;

  final bool hasError;

  const RegisterState({
    this.isLoading = false,
    this.hasError = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? hasError,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, hasError];
}
