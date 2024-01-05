part of 'update_profile_bloc.dart';

class UpdateProfileState extends Equatable {
  final FormzStatus status;
  final String? message;
  final Gender gender;
  final DateTime? birthday;
  final String? errorBirthday;
  final String? avatarPath;
  final String? avatarSelected;

  const UpdateProfileState({
    this.status = FormzStatus.pure,
    this.message,
    required this.gender,
    this.birthday,
    this.errorBirthday,
    this.avatarPath,
    this.avatarSelected,
  });

  UpdateProfileState copyWith({
    FormzStatus? status,
    String? message,
    String? avatarPath,
    String? avatarSelected,
    String? errorBirthday,
    Gender? gender,
    DateTime? birthday,
  }) {
    return UpdateProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      errorBirthday: errorBirthday ?? this.errorBirthday,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarSelected: avatarSelected ?? this.avatarSelected,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        avatarPath,
        avatarSelected,
        gender,
        birthday,
        errorBirthday,
      ];
}
