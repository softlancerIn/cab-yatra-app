import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:uuid/uuid.dart';

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

  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  PusherChannelsFlutter? pusher;
  late String channelName = 'private-chat-demo'; // ← changed to private-...

  bool _isConnected = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _connectToPusher();
  }

  Future<void> _connectToPusher() async {
    try {
      pusher = PusherChannelsFlutter.getInstance();

      await pusher!.init(
        apiKey: '8a3c4b441150f546090a',
        cluster: 'mt1',
        authEndpoint: "https://cabyatra.com",

        onConnectionStateChange: (currentState, previousState) {
          debugPrint("Connection: $currentState");
          if (mounted) {
            setState(() {
              _isConnected = currentState == 'CONNECTED';
            });
          }
        },
        onError: (String message, int? code, dynamic error) {          // ← fixed signature
          debugPrint("Pusher error: $message (code: $code, error: $error)");
        },
        onSubscriptionSucceeded: (channelName, data) {
          debugPrint("Subscribed to $channelName successfully");
        },
        onEvent: (event) {
          // Listen for client- prefixed event
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
      );

      await pusher!.connect();

      // Subscribe to private channel
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
    if (text.isEmpty || !_isConnected) return;

    final username = _username ?? _nameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    final message = Message(
      id: const Uuid().v4(),
      username: username,
      text: text,
      timestamp: DateTime.now().toIso8601String(),
    );

    try {
      await pusher!.trigger(
        PusherEvent(                              // ← This is the correct way
          channelName: channelName,
          eventName: 'client-new-message',
          data: jsonEncode(message.toJson()),     // or pass Map: message.toJson()
        ),
      );

      _messageController.clear();

      // Optional: show your own message immediately (optimistic update)
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Trigger error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send: $e")),
      );
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusher Private Chat'),
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
          // Name input (shown until joined)
          if (_username == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        final trimmed = value.trim();
                        if (trimmed.isNotEmpty) {
                          setState(() => _username = trimmed);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        setState(() => _username = name);
                      }
                    },
                    child: const Text('Join'),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.username == (_username ?? '');

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(msg.text),
                        const SizedBox(height: 4),
                        Text(
                          msg.formattedTime,
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input
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
  final String id;
  final String username;
  final String text;
  final String timestamp;

  Message({
    required this.id,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      username: json['username'] as String,
      text: json['text'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'text': text,
    'timestamp': timestamp,
  };

  String get formattedTime {
    final dt = DateTime.parse(timestamp);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}