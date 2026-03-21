import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/chat_repo.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepo _repo = ChatRepo();

  ChatListBloc() : super(const ChatListState()) {
    on<GetAllChatDriversEvent>(_getAllChatDrivers);
    on<GetChatHistoryForBookingEvent>(_getChatHistoryForBooking);
  }

  Future<void> _getChatHistoryForBooking(
    GetChatHistoryForBookingEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await _repo.getChatHistoryForBooking(
        context: event.context,
        bookingId: event.bookingId,
      );
      emit(state.copyWith(
        isLoading: false,
        chatDriversResponse: response,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _getAllChatDrivers(
    GetAllChatDriversEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await _repo.getAllChatDrivers(
        context: event.context,
        type: event.type,
      );
      emit(state.copyWith(
        isLoading: false,
        chatDriversResponse: response,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
