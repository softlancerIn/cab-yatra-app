import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class GetAllChatDriversEvent extends ChatListEvent {
  final BuildContext context;
  final String type; // 0 for posted, 1 for received

  const GetAllChatDriversEvent({required this.context, required this.type});

  @override
  List<Object> get props => [context, type];
}

class GetChatHistoryForBookingEvent extends ChatListEvent {
  final BuildContext context;
  final String bookingId;

  const GetChatHistoryForBookingEvent(
      {required this.context, required this.bookingId});

  @override
  List<Object> get props => [context, bookingId];
}
