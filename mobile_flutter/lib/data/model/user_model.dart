import 'package:equatable/equatable.dart';
import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:g_json/g_json.dart';
import 'package:intl/intl.dart';

class UserModel extends Equatable {
  final int? id;
  final String email;
  final String? username;
  final String fullname;
  final Gender gender;
  final UserType userType;
  final DateTime? birthday;
  final String? phoneNumber;
  final String? address;
  final String? avatar;
  final String? avatarThumb;
  final bool isActive;
  final DateTime? createdAt;
  final String? staffId;

  UserModel({
    this.id,
    required this.email,
    this.username,
    required this.fullname,
    required this.gender,
    required this.userType,
    this.birthday,
    this.phoneNumber,
    this.address,
    this.avatar,
    this.avatarThumb,
    this.isActive = true,
    this.createdAt,
    this.staffId,
  });

  factory UserModel.fromJson(JSON json) {
    DateTime? birthday;
    if (json['birthday'].stringValue != "") {
      birthday = DateFormat(DateTimePattern.dayType2)
          .parse(json['birthday'].stringValue);
    } else {
      birthday = null;
    }
    DateTime? createdAt;
    if (json['created_at'].stringValue != "") {
      createdAt = DateFormat(DateTimePattern.dateFormatDefault)
          .parse(json['created_at'].stringValue);
    } else {
      createdAt = null;
    }

    return UserModel(
      id: json['id'].integerValue,
      username: json['username'].stringValue,
      email: json['email'].stringValue,
      fullname: json['full_name'].stringValue,
      gender: GenderHelper.convertType(json['gender'].integerValue),
      userType: UserTypeHelper.convertType(json['user_type'].integerValue),
      phoneNumber: json['phone_number'].stringValue,
      address: json['address'].stringValue,
      staffId: json['staff_id'].stringValue,
      birthday: birthday,
      avatar: json['avatar'].stringValue,
      avatarThumb: json['avatar_thumb'].stringValue,
      isActive: json['is_active'].booleanValue,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['full_name'] = fullname;
    data['gender'] = gender.type;
    data['user_type'] = userType.type;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    data['staff_id'] = staffId;

    if (birthday != null) {
      data['birthday'] = DateFormat(DateTimePattern.dayType2).format(birthday!);
    }
    data['avatar'] = avatar;
    data['avatar_thumb'] = avatarThumb;
    data['is_active'] = isActive;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullname,
        gender,
        userType,
        phoneNumber,
        address,
        birthday,
        avatar,
        avatarThumb,
        isActive,
        createdAt,
      ];
}
