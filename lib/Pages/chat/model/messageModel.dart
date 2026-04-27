import 'dart:convert';

class MessageListModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String text;
  final String timestamp;
  final int type; // 0 = normal, 1 = payment
  final Map<String, dynamic>? metaData;

  MessageListModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.type = 0,
    this.metaData,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) {
    // meta_data can come as a JSON string or already as a Map
    Map<String, dynamic>? parsedMeta;
    final raw = json['meta_data'];
    if (raw is String && raw.isNotEmpty) {
      try { parsedMeta = jsonDecode(raw); } catch (_) {}
    } else if (raw is Map) {
      parsedMeta = Map<String, dynamic>.from(raw);
    }

    // type comes as String ("0", "1") or int from the API
    final rawType = json['type'];
    final int parsedType = rawType is int
        ? rawType
        : int.tryParse(rawType?.toString() ?? '0') ?? 0;

    return MessageListModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      senderId: int.tryParse(json['sender_id']?.toString() ?? '0') ?? 0,
      receiverId: int.tryParse(json['receiver_id']?.toString() ?? '0') ?? 0,
      text: json['message']?.toString() ?? "",
      timestamp: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      type: parsedType,
      metaData: parsedMeta,
    );
  }

  String get formattedTime {
    final dt = DateTime.parse(timestamp);
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }
}