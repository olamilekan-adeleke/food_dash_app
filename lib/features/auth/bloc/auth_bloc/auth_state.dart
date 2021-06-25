part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => <Object>[];
}

class AuthInitial extends AuthState {}

//login states
class AuthLoginIntialState extends AuthState {}

class AuthLoginLoadingState extends AuthState {}

class AuthLoginLoadedState extends AuthState {
  const AuthLoginLoadedState(this.message);

  final String message;
}

class AuthLoginErrorState extends AuthState {
  const AuthLoginErrorState(this.message);

  final String message;
}

//sign up states
class AuthSignUpIntialState extends AuthState {}

class AuthSignUpLoadingState extends AuthState {}

class AuthSignUpLoadedState extends AuthState {
  const AuthSignUpLoadedState(this.message);

  final String message;
}

class AuthSignUpErrorState extends AuthState {
  const AuthSignUpErrorState(this.message);

  final String message;
}

//forgot password states
class AuthForgotPasswordIntialState extends AuthState {}

class AuthForgotPasswordLoadingState extends AuthState {}

class AuthForgotPasswordLoadedState extends AuthState {
  const AuthForgotPasswordLoadedState(this.message);

  final String message;
}

class AuthForgotPasswordErrorState extends AuthState {
  const AuthForgotPasswordErrorState(this.message);

  final String message;
}
