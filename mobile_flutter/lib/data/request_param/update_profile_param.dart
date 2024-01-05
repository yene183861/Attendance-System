import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';

class UpdateProfileParam {
  final String? username;
  final DateTime? birthday;
  final Gender? gender;
  final String? phoneNumber;
  final String? address;
  final File? avatar;

  UpdateProfileParam({
    this.username,
    this.birthday,
    this.gender,
    this.phoneNumber,
    this.address,
    this.avatar,
  });

  FormData toFormData() {
    final formData = FormData.fromMap({
      if (username != null) 'username': username,
      if (birthday != null)
        'birthday': Utils.formatDateTimeToString(
            time: birthday!, dateFormat: DateFormat(DateTimePattern.dayType2)),
      if (gender != null) 'gender': gender!.type,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (avatar != null) 'avatar': MultipartFile.fromFileSync(avatar!.path),
    });
    return formData;
  }
}
