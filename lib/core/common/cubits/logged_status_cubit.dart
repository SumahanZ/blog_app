import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logged_status_state.dart';

class LoggedStatusCubit extends Cubit<LoggedStatusState> {
  LoggedStatusCubit() : super(LoggedStatusStateInitial());

  void updateLoggedInStatus(User? user) {
    if (user == null) {
      emit(LoggedStatusStateInitial());
    } else {
      emit(LoggedStatusStateInitialLoggedIn(user: user));
    }
  }
}

//core cannot depend on  other  features
//other features can depend on core the auth feature is totally dependent on the core 