final class ServerException implements Exception {
  final String? errorMessage;
  final String statusCode;

  ServerException({this.errorMessage, required this.statusCode});

  @override
  String toString() {
    return "Server Exception: $errorMessage with code $statusCode";
  }
}

final class LocalException implements Exception {
  final String? errorMessage;

  LocalException({this.errorMessage = "Unknown error occured"});

  @override
  String toString() {
    return "Local Exception: $errorMessage";
  }
}

final class UnknownException implements Exception {
  final String? errorMessage;
  final String statusCode;

  UnknownException(
      {this.errorMessage = "Unknown error occured", required this.statusCode});

  @override
  String toString() {
    return "Unknown Exception: $errorMessage with code $statusCode";
  }
}
