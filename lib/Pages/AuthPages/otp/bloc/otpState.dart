import 'package:equatable/equatable.dart';

class OTPState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final bool isSuccess;
  final bool isAgent;
  final bool isUser;
  final bool hasError;

  const OTPState({
    this.isLoading = false,
    this.hasError = false,
    this.isSuccess = false,
    this.isAgent = false,
    this.isUser = false,
    this.errorMessage,
  });

  OTPState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? isAgent,
    bool? isUser,
    bool? hasError,
  }) {
    return OTPState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        hasError: hasError ?? this.hasError,
        isSuccess: isSuccess ?? this.isSuccess,
        isAgent: isAgent ?? this.isAgent,
        isUser: isUser ?? this.isUser);
  }

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, hasError, isUser, isAgent];
}
