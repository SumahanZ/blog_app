part of 'logged_status_cubit.dart';

@immutable
sealed class LoggedStatusState {}

final class LoggedStatusStateInitial extends LoggedStatusState {}

final class LoggedStatusStateInitialLoggedIn extends LoggedStatusState {
  final User user;

  LoggedStatusStateInitialLoggedIn({required this.user});
}
