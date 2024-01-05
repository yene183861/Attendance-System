part of 'attendance_face_bloc.dart';

class AttendanceFaceState extends Equatable {
  final FormzStatus status;
  final String? message;

  const AttendanceFaceState({
    this.status = FormzStatus.pure,
    this.message,
  });

  AttendanceFaceState copyWith({
    FormzStatus? status,
    String? message,
  }) {
    return AttendanceFaceState(
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
