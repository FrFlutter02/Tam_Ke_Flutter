import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String email;
  final String password;
  final String emailErrorMessage;
  final String passwordErrorMessage;

  const LoginFailure({
    this.email = '',
    this.password = '',
    this.emailErrorMessage = '',
    this.passwordErrorMessage = '',
  });

  @override
  List<Object> get props => [
        email,
        password,
        emailErrorMessage,
        passwordErrorMessage,
      ];
}