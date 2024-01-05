part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  final bool isValidEmail;
  final FormzStatus status;
  final String? message;

  const ForgotPasswordState({
    this.isValidEmail = false,
    this.status = FormzStatus.pure,
    this.message,
  });

  ForgotPasswordState copyWith({
    bool? isValidEmail,
    FormzStatus? status,
    String? message,
  }) {
    return ForgotPasswordState(
      isValidEmail: isValidEmail ?? this.isValidEmail,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        isValidEmail,
        status,
        message,
      ];
}
