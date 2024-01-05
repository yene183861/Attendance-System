part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final String? message;
  final bool isValidEmail;

  const LoginState({
    required this.status,
    this.message,
    this.isValidEmail = false,
  });

  LoginState copyWith({
    FormzStatus? status,
    String? message,
    bool? isValidEmail,
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      isValidEmail: isValidEmail ?? this.isValidEmail,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        isValidEmail,
      ];
}
