part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent {}

class SubmitPasswordEvent extends ChangePasswordEvent {
  final ChangePasswordParam param;
  SubmitPasswordEvent({required this.param});
}
