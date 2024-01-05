import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../configs/resources/barrel_const.dart';
import 'popup_notification_custom.dart';

Future<List<File>?> showPickerImage(BuildContext context) async {
  final result = await showModalBottomSheet<List<File>?>(
      context: context,
      builder: (BuildContext bc) {
        File? result;
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  'camera'.tr(),
                  style: FONT_CONST.extraBold(fontSize: 15),
                ),
                onTap: () async {
                  result = await _pickCamera(context);

                  Navigator.of(context).pop([]);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('photo_library'.tr(),
                    style: FONT_CONST.extraBold(fontSize: 15)),
                onTap: () async {
                  result = await _pickImage(context);

                  Navigator.of(context).pop([]);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('video'.tr(),
                    style: FONT_CONST.extraBold(fontSize: 15)),
                onTap: () async {
                  final res = await _pickMutilpe(context);
                  print('fsssdfsdfsf');
                  print(res);
                  Navigator.of(context).pop(res);
                },
              ),
            ],
          ),
        );
      });
  if (result == null) return null;

  return result;
}

Future<File?> _pickImage(BuildContext context) async {
  final permissionCamera = await Permission.photos.request();
  if (permissionCamera.isGranted ||
      permissionCamera.isLimited ||
      Platform.isAndroid) {
    final picker = ImagePicker();
    final fileImageProfile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      requestFullMetadata: false,
    );
    if (fileImageProfile == null) {
      return null;
    }
    final img = File(fileImageProfile.path);
    return img;
  } else {
    PopupNotificationCustom.showMessgae(
      title: 'title_permission_popup'.tr(),
      message: 'message_photos_permission_popup'.tr(),
      pressButtonLeft: () async {
        await openAppSettings();
      },
    );
    return null;
  }
}

Future<File?> _pickVideo(BuildContext context) async {
  final permissionCamera = await Permission.videos.request();
  if (permissionCamera.isGranted ||
      permissionCamera.isLimited ||
      Platform.isAndroid) {
    final picker = ImagePicker();
    final fileImageProfile = await picker.pickVideo(
      source: ImageSource.gallery,
      // imageQuality: 90,
      // requestFullMetadata: false,
    );
    if (fileImageProfile == null) {
      return null;
    }
    final img = File(fileImageProfile.path);
    return img;
  } else {
    PopupNotificationCustom.showMessgae(
      title: 'title_permission_popup'.tr(),
      message: 'message_photos_permission_popup'.tr(),
      pressButtonLeft: () async {
        await openAppSettings();
      },
    );
    return null;
  }
}

Future<File?> _pickCamera(BuildContext context) async {
  final permissionCamera = await Permission.camera.request();
  if (permissionCamera.isGranted) {
    final picker = ImagePicker();
    final fileImageProfile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (fileImageProfile == null) {
      return null;
    }
    final img = File(fileImageProfile.path);

    return img;
  } else {
    PopupNotificationCustom.showMessgae(
      title: 'titile_permission_popup'.tr(),
      message: 'message_camera_permission_popup'.tr(),
      pressButtonLeft: () async {
        await openAppSettings();
      },
    );
    return null;
  }
}

Future<List<File>?> _pickMutilpe(BuildContext context) async {
  final permissionCamera = await Permission.photos.request();
  if (permissionCamera.isGranted ||
      permissionCamera.isLimited ||
      Platform.isAndroid) {
    final picker = ImagePicker();
    final fileImageProfile = await picker.pickMultiImage(
      // source: ImageSource.gallery,

      imageQuality: 90,
      requestFullMetadata: false,
    );
    if (fileImageProfile.length < 2) {
      return null;
    }
    List<File> f = [];
    for (int i = 0; i < fileImageProfile.length; i++) {
      f.add(File(fileImageProfile[i].path));
    }

    return f;
  } else {
    PopupNotificationCustom.showMessgae(
      title: 'title_permission_popup'.tr(),
      message: 'message_photos_permission_popup'.tr(),
      pressButtonLeft: () async {
        await openAppSettings();
      },
    );
    return null;
  }
}
