import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_dash_app/cores/constants/success_text.dart';
import 'package:food_dash_app/features/auth/repo/auth_repo.dart';
import 'package:get_it/get_it.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());
  final AuthenticationRepo authenticationRepo =
      GetIt.instance<AuthenticationRepo>();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginUserEvent) {
      try {
        yield AuthLoginLoadingState();
        await authenticationRepo.loginUserWithEmailAndPassword(
          event.email,
          event.password,
        );
        yield const AuthLoginLoadedState(loginSucessMessage);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AuthLoginErrorState(e.toString());
      }
    } else if (event is SignUpUserEvent) {
      try {
        yield AuthSignUpLoadingState();
        await authenticationRepo.registerUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
          fullName: event.fullName,
          number: event.number,
        );
        yield const AuthSignUpLoadedState(signUpSucessMessage);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AuthSignUpErrorState(e.toString());
      }
    } else if (event is ForgotPasswordEvent) {
      try {
        yield AuthForgotPasswordLoadingState();
        await authenticationRepo.resetPassword(event.email);
        yield const AuthForgotPasswordLoadedState(forgotPasswordSucessMessage);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AuthForgotPasswordErrorState(e.toString());
      }
    } else if (event is ForgotPasswordEvent) {
      try {
        yield AuthLogOutUserLoadingState();
        await authenticationRepo.signOut();
        yield const AuthLoginLoadedState(logOutSuccessText);
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        yield AuthLogOutUserErrorState(e.toString());
      }
    }
  }
}
