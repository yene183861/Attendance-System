part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  final FormzStatus status;
  final String? message;

  const ChangePasswordState({
    this.status = FormzStatus.pure,
    this.message,
  });

  ChangePasswordState copyWith({
    FormzStatus? status,
    String? message,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
