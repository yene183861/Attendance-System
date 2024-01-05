part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent {}

class ChangeGender extends UpdateProfileEvent {
  final Gender gender;
  ChangeGender({required this.gender});
}

class ChangeBirthday extends UpdateProfileEvent {
  final DateTime birthday;
  ChangeBirthday({required this.birthday});
}

class ChangAvatarEvent extends UpdateProfileEvent {
  final File avatarPath;
  ChangAvatarEvent({required this.avatarPath});
}

class SaveProfileEvent extends UpdateProfileEvent {
  final UpdateProfileParam updateProfileParam;
  SaveProfileEvent({required this.updateProfileParam});
}
