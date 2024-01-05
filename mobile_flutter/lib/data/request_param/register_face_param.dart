import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class RegisterFaceParam {
  final int userId;
  final File videoFile;

  RegisterFaceParam({
    required this.userId,
    required this.videoFile,
  });

  FormData toFormData() {
    final formData = FormData.fromMap({
      'user': userId,
      'video_file': MultipartFile.fromFileSync(
        videoFile.path,
        // filename: "20230723_104800.mp4",
      ),
    });
    return formData;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user'] = userId;
    data['video_file'] = MultipartFile.fromFile(
      videoFile.path,
      filename: "20230723_104800.mp4",
    );
    log('dataaa: ${data}');
    return data;
  }
}
