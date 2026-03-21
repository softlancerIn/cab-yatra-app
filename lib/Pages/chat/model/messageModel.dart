class MessageListModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String text;
  final String timestamp;

  MessageListModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) {
    return MessageListModel(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      text: json['message'] ?? "",
      timestamp: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  String get formattedTime {
    final dt = DateTime.parse(timestamp);
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }
}