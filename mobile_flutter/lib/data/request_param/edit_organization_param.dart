import 'dart:io';

import 'package:dio/dio.dart';

class EditOrganizationParam {
  final String? name;
  final File? logo;
  final String? phoneNumber;
  final String? email;
  final String? address;

  EditOrganizationParam({
    this.name,
    this.logo,
    this.phoneNumber,
    this.email,
    this.address,
  });

  FormData toFormData() {
    final formData = FormData.fromMap({
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (logo != null) 'logo': MultipartFile.fromFileSync(logo!.path),
    });
    return formData;
  }
}
