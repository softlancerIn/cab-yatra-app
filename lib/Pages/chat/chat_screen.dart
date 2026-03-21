import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../app/router/navigation/nav.dart';
import '../../app/router/navigation/routes.dart';
import '../Custom_Widgets/custom_app_bar.dart';
import 'repo/chat_repo.dart';
import 'model/messageModel.dart';
import '../../cores/services/secure_storage_service.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String bookingId;
  final String creatorName;
  final String receiverId;

  const ChatScreen({
    super.key,
    this.userName = "User",
    this.bookingId = "25435",
    this.creatorName = "Guddu",
    this.receiverId = "0",
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatRepo _chatRepo = ChatRepo();
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _initPusher();
  }

  void _fetchMessages() async {
    try {
      final myId = await SecureStorageService.getUserId();
      final messages = await _chatRepo.getChatMessages(
        context: context,
        bookingId: widget.bookingId,
      );
      setState(() {
        _messages = messages.map((m) => ChatMessage(
          text: m.text,
          isMe: m.senderId.toString() == myId,
          time: m.formattedTime,
          type: MessageType.sent,
        )).toList();
      });
      _scrollToBottom();
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  void _initPusher() async {
    try {
      final myId = await SecureStorageService.getUserId();
      final token = await SecureStorageService.getToken();

      await _pusher.init(
        apiKey: "8a3c4b441150f546090a",
        cluster: "mt1",
        onAuthorizer: (channelName, socketId, options) async {
          debugPrint("Authorizing channel: $channelName");
          try {
            final response = await _chatRepo.authorizeChannel(
              channelName: channelName,
              socketId: socketId,
              token: token ?? "",
            );
            return response;
          } catch (e) {
            debugPrint("Pusher Authorizer error: $e");
            return null;
          }
        },
        onEvent: (PusherEvent event) async {
          debugPrint("Pusher event received: ${event.eventName}");
          if (event.data != null) {
            try {
              final dynamic data = event.data is String ? jsonDecode(event.data) : event.data;
              
              // Map the Pusher payload to MessageListModel
              // Handle potential nesting (e.g. data['message'] or the data itself)
              final Map<String, dynamic> messageData = (data is Map && data.containsKey('message') && data['message'] is Map) 
                                                        ? data['message'] 
                                                        : (data is Map ? data : {});

              if (messageData.isNotEmpty && messageData.containsKey('id')) {
                final newMessage = MessageListModel.fromJson(messageData);
                final myId = await SecureStorageService.getUserId();
                final isMe = newMessage.senderId.toString() == myId;

                // Prevent duplicates: avoid adding if I sent it (already added locally)
                // or if it already exists in the list
                bool exists = _messages.any((m) => m.text == newMessage.text && m.time == newMessage.formattedTime);
                
                if (!exists) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: newMessage.text,
                      isMe: isMe,
                      time: newMessage.formattedTime,
                      type: isMe ? MessageType.sent : MessageType.received,
                    ));
                  });
                  _scrollToBottom();
                }
              } else {
                // Fallback for safety if format is unknown
                _fetchMessages();
              }
            } catch (e) {
              debugPrint("Error parsing Pusher event data: $e");
              _fetchMessages(); // Fallback
            }
          }
        },
      );
      
      await _pusher.subscribe(channelName: "private-chat.booking.${widget.bookingId}");
      if (myId != null) {
        await _pusher.subscribe(channelName: "private-App.Models.Driver.$myId");
      }
      
      await _pusher.connect();
    } catch (e) {
      debugPrint("Pusher error: $e");
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() async {
    final myId = await SecureStorageService.getUserId();
    _pusher.unsubscribe(channelName: "private-chat.booking.${widget.bookingId}");
    if (myId != null) {
      _pusher.unsubscribe(channelName: "private-App.Models.Driver.$myId");
    }
    _pusher.disconnect();
    super.dispose();
  }

  void _sendMessage({String? text, MessageType type = MessageType.sent, bool isMe = true}) async {
    final String content = text ?? _messageController.text.trim();
    if (content.isEmpty) return;

    if (text == null) {
      _messageController.clear();
    }

    try {
      await _chatRepo.sendMessage(
        context: context,
        bookingId: widget.bookingId,
        receiverId: widget.receiverId,
        message: content,
      );
      // Local update
      setState(() {
        _messages.add(ChatMessage(
          text: content,
          isMe: isMe,
          time: TimeOfDay.now().format(context),
          type: type,
        ));
      });
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _showShareDetailsDialog() {
    String selectedDriver = "Mukesh Kushwaha";
    String selectedVehicle = "UP14HT9864";
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8F9FA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Select car and driver",
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF2C3E50), 
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  const Text(
                    "Driver", 
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50), fontFamily: 'Poppins')
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDriver,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB300)),
                        style: const TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.w500, fontSize: 15, fontFamily: 'Poppins'),
                        items: ["Mukesh Kushwaha", "Rajesh Kumar", "Amit Singh"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedDriver = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Vehicle", 
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50), fontFamily: 'Poppins')
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFFFB300), width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedVehicle,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFB300)),
                        style: const TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.w500, fontSize: 15, fontFamily: 'Poppins'),
                        items: ["UP14HT9864", "DL01AB1234", "HR26XY9876"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedVehicle = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _sendMessage(
                            text: "Driver Name: $selectedDriver\nContact Number: 7011873145\nVehicle Registration: $selectedVehicle\nVehicle Type: Ertiga",
                            type: MessageType.info,
                            isMe: false,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins')),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        showLeading: true,
        title: widget.userName == "User" ? "Chat" : widget.userName,
        showAction: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero, // Removed horizontal padding from here
              itemCount: _messages.length + 2, 
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildBookingCard();
                }
                if (index == 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildChatBubble(_messages[index - 2]),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildBookingCard() {
    return InkWell(
      onTap: () {
        Nav.push(context, Routes.bookingDetails, extra: widget.bookingId);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "ID : ",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: widget.bookingId,
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Round Trip",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue.shade700, fontFamily: 'Poppins'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Jan 12, 2026 @ 5:00AM",
              style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            ),
            const Divider(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(Icons.circle, color: Colors.orange, size: 16),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    const Icon(Icons.circle, color: Colors.red, size: 16),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sector- 63, Noida",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Round Trip...",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                            border: Border.all(color: Colors.grey.shade300, width: 0.5),
                          ),
                          child: const Column(
                            children: [
                              Text("₹17,500", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C3E50), fontFamily: 'Poppins')),
                              Text("Total Amount", style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB300),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                          ),
                          child: const Column(
                            children: [
                              Text("₹1,000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white, fontFamily: 'Poppins')),
                              Text("Commission", style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Image.asset("assets/images/appbar_car.png", width: 80),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Dzire, Etios, Aura, Glanza Similar (a/c)",
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showShareDetailsDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Share Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    if (message.isAction) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Text("Pay Commission ₹700.0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Poppins')),
            label: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ),
      );
    }

    if (message.type == MessageType.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.text,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          ),
        ),
      );
    }

    final bool isMe = message.isMe;
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Transform.rotate(
                  angle: -0.5,
                  child: const Icon(Icons.send, color: Colors.orange, size: 20),
                ),
              ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFE8E8E8) : (message.type == MessageType.received ? const Color(0xFFFFB300) : const Color(0xFFF2F2F2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: (message.type == MessageType.received || message.type == MessageType.system) ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
                    height: 1.4,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          message.time,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "Say Someting...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MessageType { sent, received, info, system }

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final MessageType type;
  final bool isAction;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.type = MessageType.sent,
    this.isAction = false,
  });
}
