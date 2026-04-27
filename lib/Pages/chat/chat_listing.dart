import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/router/navigation/nav.dart';
import '../../app/router/navigation/routes.dart';
import '../../cores/utils/helperFunctions.dart';
import '../Custom_Widgets/custom_app_bar.dart';
import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';

class ChatListingScreen extends StatefulWidget {
  final String? bookingId;
  final bool isBottomSheet;
  final VoidCallback? onBack;
  const ChatListingScreen({super.key, this.bookingId, this.isBottomSheet = false, this.onBack});

  static void show(BuildContext context, {String? bookingId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Adjust as needed for 'half screen'
          child: BlocProvider(
            create: (context) => ChatListBloc(),
            child: ChatListingScreen(bookingId: bookingId, isBottomSheet: true),
          ),
        );
      },
    );
  }

  @override
  State<ChatListingScreen> createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen> {
  bool isPostedSelected = true;

  @override
  void initState() {
    super.initState();
    if (widget.bookingId != null) {
      context.read<ChatListBloc>().add(
          GetChatHistoryForBookingEvent(
              context: context, bookingId: widget.bookingId!));
    } else {
      context.read<ChatListBloc>().add(
          GetAllChatDriversEvent(context: context, type: "0"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        if (widget.isBottomSheet) ...[
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.bookingId != null ? 'Chat History' : 'Chats',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
        if (widget.bookingId == null) ...[
          const SizedBox(height: 10),
          /// Toggle Switch (posted / Received)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isPostedSelected = true);
                        context.read<ChatListBloc>().add(
                            GetAllChatDriversEvent(context: context, type: "0"));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isPostedSelected
                              ? const Color(0xFFFFB300)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Posted',
                          style: TextStyle(
                            color: isPostedSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isPostedSelected = false);
                        context.read<ChatListBloc>().add(
                            GetAllChatDriversEvent(context: context, type: "1"));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isPostedSelected
                              ? const Color(0xFFFFB300)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Received',
                          style: TextStyle(
                            color: !isPostedSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        
        /// Chat List
        Expanded(
          child: BlocBuilder<ChatListBloc, ChatListState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state.errorMessage != null) {
                return Center(child: Text(state.errorMessage!));
              }

              final drivers = state.chatDriversResponse?.drivers ?? [];

              if (drivers.isEmpty) {
                return const Center(child: Text("No chats found"));
              }

              return ListView.separated(
                itemCount: drivers.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: DottedDivider(),
                ),
                itemBuilder: (context, index) {
                  final item = drivers[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.isBottomSheet) {
                        Navigator.pop(context); // Close bottom sheet
                      }
                      Nav.push(context, Routes.chatScreen, extra: {
                        'userName': item.name ?? "User",
                        'bookingId': item.bookingId?.toString() ?? widget.bookingId ?? "N/A",
                        'creatorName': item.name ?? "Guddu",
                        'receiverId': item.id?.toString() ?? "0",
                      }).then((_) {
                        if (context.mounted) {
                          if (widget.bookingId != null) {
                            context.read<ChatListBloc>().add(
                                GetChatHistoryForBookingEvent(
                                    context: context, bookingId: widget.bookingId!));
                          } else {
                            context.read<ChatListBloc>().add(
                                GetAllChatDriversEvent(context: context, type: isPostedSelected ? "0" : "1"));
                          }
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// User Avatar
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(item.driverImageUrl ?? "https://cabyatra.com/assets/images/user.png"),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          const SizedBox(width: 15),

                          /// Name and Message
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? "User",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.lastMessage ?? "Last message snippet here...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Booking ID (on the right)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Booking ID : ${item.orderId ?? item.bookingId ?? widget.bookingId ?? "N/A"}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                HelperFunctions.formatTimeAgo(item.lastMessageTime ??
                                    item.updatedAt ??
                                    item.createdAt),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );

    if (widget.isBottomSheet) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        showLeading: true,
        title: widget.bookingId != null ? 'Chat History' : 'Chats',
        onLeadingPressed: widget.onBack ?? () => Navigator.pop(context),
      ),
      body: content,
    );
  }
}

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}
