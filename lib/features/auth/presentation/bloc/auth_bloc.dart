import 'dart:async';

import 'package:blog_app/core/common/cubits/logged_status_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final LoggedStatusCubit _loggedStatusCubit;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  AuthBloc(this._loggedStatusCubit,
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    //if i get any event I want to emit AuthLoading, its gonna run first
    //dont have to mention emit(AuthLoading()) everytime
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUpEvent>(_onAuthSignUp);
    on<AuthLoginEvent>(_onAuthLogin);
    on<AuthCurrentUserEvent>(_onAuthCurrentUser);
  }

  FutureOr<void> _onAuthSignUp(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(
      UserSignUpParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(errorMessage: l.message)),
      (r) => _onStatusChanged(r, emit),
    );
  }

  FutureOr<void> _onAuthLogin(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    final res = await _userLogin.call(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold((l) => emit(AuthFailure(errorMessage: l.message)),
        (r) => _onStatusChanged(r, emit));
  }

  void _onStatusChanged(User user, Emitter<AuthState> emit) {
    _loggedStatusCubit.updateLoggedInStatus(user);
    emit(AuthSuccess(user));
  }

  FutureOr<void> _onAuthCurrentUser(
      AuthCurrentUserEvent event, Emitter<AuthState> emit) async {
    final res = await _currentUser.call(event.token);

    res.fold((l) => emit(AuthFailure(errorMessage: l.message)),
        (r) => _onStatusChanged(r, emit));
  }
}
