class AddDriverResponse {
  final bool status;
  final String message;

  AddDriverResponse({
    required this.status,
    required this.message,
  });

  factory AddDriverResponse.fromJson(Map<String, dynamic> json) {
    return AddDriverResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
