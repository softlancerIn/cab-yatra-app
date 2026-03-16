
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  NoInternetException() : super('No internet connection');
}

class ServerException extends AppException {
  ServerException() : super('Internal server error');
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super('Session expired. Please login again.');
}

class ApiException extends AppException {
  final int statusCode;
  ApiException(this.statusCode, String message) : super(message);
}