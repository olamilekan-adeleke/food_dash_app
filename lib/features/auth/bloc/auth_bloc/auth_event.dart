part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => <Object>[];
}

/// bloc event for loging in user. accept two required arguments which are
/// email(String) and password(String).
class LoginUserEvent extends AuthEvent {
  const LoginUserEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

/// bloc event for siging up a new user, it requires 3 arguments, email, password
/// and full name with are all of type <String>
class SignUpUserEvent extends AuthEvent {
  const SignUpUserEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  final String email;
  final String password;
  final String fullName;
}

/// bloc event for forgot password, accept email<String>
class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent(this.email);

  final String email;
}
