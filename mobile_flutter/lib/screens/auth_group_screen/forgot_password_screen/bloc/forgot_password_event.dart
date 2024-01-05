part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {}

class ChangeStateEmailEvent extends ForgotPasswordEvent {
  final bool isValid;
  ChangeStateEmailEvent({required this.isValid});
}

class SubmitResetPassEvent extends ForgotPasswordEvent {
  final String email;
  SubmitResetPassEvent({required this.email});
}
