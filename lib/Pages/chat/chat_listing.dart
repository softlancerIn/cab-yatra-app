



import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../cores/services/secure_storage_service.dart';

class ChatListingScreen extends StatefulWidget {
  const ChatListingScreen({super.key});

  @override
  State<ChatListingScreen> createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(
    text: 'Guest_${DateTime.now().millisecond}',
  );

  final TextEditingController _channelIdController = TextEditingController(
    text: '546', // ← change to your booking_id or driver id
  );
  String? currentUserId;
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  PusherChannelsFlutter? pusher;
  String channelName = ''; // will be set dynamically

  bool _isConnected = false;
  String? _username;
  String? _authToken="251|ge2tcBrvHYt3sYIqMqBKdVDbj727s8CmxdVc7Pqrc1a027e9"; // ← add your auth token here (JWT / Sanctum / etc)

  @override
  void initState() {
    super.initState();
    loadUser();
    getMessages();
  }

  Future<void> loadUser() async {
    currentUserId = await SecureStorageService.getUserId();
    setState(() {});
  }

  Future<void> _connectAndSubscribe() async {
    if (_username == null || _channelIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter name and channel ID")),
      );
      return;
    }

    setState(() {
      channelName = 'private-chat.booking.${_channelIdController.text.trim()}';
      // OR: 'private-App.Models.Driver.${_channelIdController.text.trim()}';
    });

    try {
      pusher = PusherChannelsFlutter.getInstance();

      await pusher!.init(
        apiKey: '8a3c4b441150f546090a',
        cluster: 'ap2',
        // Do NOT set authEndpoint if using onAuthorizer
        onConnectionStateChange: (currentState, previousState) {
          debugPrint("Connection: $currentState");
          if (mounted) {
            setState(() {
              _isConnected = currentState == 'CONNECTED';
            });
          }
        },
        onError: (message, code, error) {
          debugPrint("Pusher error: $message (code: $code, error: $error)");
        },
        onSubscriptionSucceeded: (channelName, data) {
          debugPrint("Subscribed to $channelName successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Joined $channelName")),
          );
        },
        onEvent: (event) {
          if (event.eventName == 'client-new-message') {
            try {
              final data = jsonDecode(event.data as String);
              final msg = Message.fromJson(data);
              if (mounted) {
                setState(() {
                  _messages.add(msg);
                });
                _scrollToBottom();
              }
            } catch (e) {
              debugPrint("JSON decode error: $e");
            }
          }
        },
        // ── Most important part for private channels ──
        // Inside pusher!.init(...)

        onAuthorizer: (channelName, socketId, options) async {
          try {
            // ← CHANGE THIS TO THE REAL AUTH ENDPOINT (most likely one of these)
            final uri = Uri.parse('https://cabyatra.com/broadcasting/auth');
            // OR: 'https://cabyatra.com/api/broadcasting/auth'
            // OR: 'https://cabyatra.com/api/driver/V2/broadcast/auth'  ← ask backend team

            final response = await http.post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $_authToken',  // your token "251|ge2tcBrv..."
              },
              body: jsonEncode({
                'socket_id': socketId,          // ← Pusher sends this
                'channel_name': channelName,    // ← e.g. "private-chat.booking.505"
              }),
            );

            if (response.statusCode == 200) {
              final json = jsonDecode(response.body);
              debugPrint("Auth success → ${response.body}");
              return json;  // Must be {"auth": "8a3c4b441150f546090a:signature..."}
            } else {
              debugPrint("Auth failed → Status: ${response.statusCode} | Body: ${response.body}");
              return null;
            }
          } catch (e) {
            debugPrint("Authorizer error: $e");
            return null;
          }
        },
      );

      await pusher!.connect();

      // Now subscribe
      await pusher!.subscribe(channelName: channelName);

    } catch (e) {
      debugPrint("Pusher init/subscribe error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection failed: $e")),
        );
      }
    }
  }

  Future<void> _sendMessage() async {

    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    final url = "https://cabyatra.com/api/driver/V2/send-message";

    final body = {
      "receiver_id": "1",
      "booking_id": _channelIdController.text.trim(),
      "message": text
    };

    try {

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_authToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      debugPrint("SEND STATUS: ${response.statusCode}");
      debugPrint("SEND BODY: ${response.body}");

      if (response.statusCode == 200) {

        final newMsg = Message(
          id: 0,
          senderId: int.parse(currentUserId!),
          receiverId: 1,
          message: text,
          createdAt: DateTime.now().toIso8601String(),
        );

        setState(() {
          _messages.add(newMsg);
        });

        _messageController.clear();

        _scrollToBottom();
      }

    } catch (e) {
      debugPrint("Send error $e");
    }
  }

  Future<void> getMessages() async {

    final url = "https://cabyatra.com/api/driver/V2/get-messages/${_channelIdController.text}";

    try {

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $_authToken",
          "Accept": "application/json"
        },
      );

      debugPrint("CHAT STATUS: ${response.statusCode}");
      debugPrint("CHAT BODY: ${response.body}");

      if (response.statusCode == 200) {

        final List data = jsonDecode(response.body);

        _messages.clear();

        for (var item in data) {
          _messages.add(Message.fromJson(item));
        }

        setState(() {});

        _scrollToBottom();
      }

    } catch (e) {
      debugPrint("Chat list error $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  void dispose() {
    pusher?.disconnect();
    _messageController.dispose();
    _nameController.dispose();
    _channelIdController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Chat (Pusher)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              _isConnected ? '🟢 Connected' : '🔴 Disconnected',
              style: TextStyle(color: _isConnected ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Join form
          if (_username == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _channelIdController,
                    decoration: const InputDecoration(
                      labelText: 'Booking ID / Driver ID',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. 12345',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isNotEmpty && _channelIdController.text.trim().isNotEmpty) {
                        setState(() => _username = name);
                        _connectAndSubscribe();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fill all fields")),
                        );
                      }
                    },
                    child: const Text('Join Chat'),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
                itemBuilder: (context, index) {

                  final msg = _messages[index];

                  final isMe = msg.senderId.toString() == currentUserId;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.green[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [

                          Text(msg.message),

                          const SizedBox(height: 4),

                          Text(
                            msg.formattedTime,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                }
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _isConnected ? 'Type a message...' : 'Not connected...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    enabled: _isConnected,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isConnected ? _sendMessage : null,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message model (unchanged)
class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      senderId: json["sender_id"],
      receiverId: json["receiver_id"],
      message: json["message"],
      createdAt: json["created_at"],
    );
  }

  String get formattedTime {
    final dt = DateTime.parse(createdAt);
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }
}