import 'package:equatable/equatable.dart';
import '../model/chat_drivers_response_model.dart';

class ChatListState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ChatDriversResponseModel? chatDriversResponse;

  const ChatListState({
    this.isLoading = false,
    this.errorMessage,
    this.chatDriversResponse,
  });

  ChatListState copyWith({
    bool? isLoading,
    String? errorMessage,
    ChatDriversResponseModel? chatDriversResponse,
  }) {
    return ChatListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      chatDriversResponse: chatDriversResponse ?? this.chatDriversResponse,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, chatDriversResponse];
}
