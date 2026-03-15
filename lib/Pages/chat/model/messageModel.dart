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
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      text: json['MessageListModel'],
      timestamp: json['created_at'],
    );
  }

  String get formattedTime {
    final dt = DateTime.parse(timestamp);
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }
}