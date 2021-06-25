import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginUserEvent) {
      try {
        yield AuthLoginLoadingState();
        // TODO: preform login..
        yield const AuthLoginLoadedState('message');
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AuthLoginErrorState(e.toString());
      }
    }
  }
}
