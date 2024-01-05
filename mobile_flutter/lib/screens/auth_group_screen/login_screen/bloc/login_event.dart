part of 'login_bloc.dart';

abstract class LoginEvent {}

class ChangeStateEmailTextFieldEvent extends LoginEvent {
  final bool isValid;

  ChangeStateEmailTextFieldEvent({required this.isValid});
}

class SubmitLoginEvent extends LoginEvent {
  final LoginParams loginParams;
  SubmitLoginEvent({required this.loginParams});
}
