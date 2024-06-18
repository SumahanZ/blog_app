class Failure {
  final String message;

  Failure({this.message = "An unexpected error occured!"});
}

final class ResponseFailure extends Failure {
  ResponseFailure({super.message});
}
