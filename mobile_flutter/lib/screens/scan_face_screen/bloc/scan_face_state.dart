part of 'scan_face_bloc.dart';

class ScanFaceState extends Equatable {
  final FormzStatus status;
  final String? message;
  final UserModel? user;

  const ScanFaceState({
    this.status = FormzStatus.pure,
    this.message,
    this.user,
  });

  ScanFaceState copyWith({
    FormzStatus? status,
    String? message,
    UserModel? user,
  }) {
    return ScanFaceState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        user,
      ];
}
