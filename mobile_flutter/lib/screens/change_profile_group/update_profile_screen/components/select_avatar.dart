import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/utils/image_convert.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/update_profile_bloc.dart';

class SelectAvatar extends StatefulWidget {
  @override
  _SelectAvatarState createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  File? _file;
  final userInfo = Singleton.instance.userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
          buildWhen: (previous, current) =>
              current.avatarPath != previous.avatarPath,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Stack(
                children: [
                  BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 100,
                        width: 100,
                        child: _file != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(_file!),
                              )
                            : CachedNetworkImage(
                                imageUrl: userInfo?.avatarThumb ?? '',
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundImage: AssetImage(
                                    IMAGE_CONST.imgLoadingAvatar.path,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundImage: AssetImage(
                                    IMAGE_CONST.imgLoadingAvatar.path,
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
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
      if (fileImageProfile == null) return;
      File? img = File(fileImageProfile.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _file = img;
        context.updateProfileBloc.add(ChangAvatarEvent(avatarPath: _file!));
      });
    } else {
      PopupNotificationCustom.showMessgae(
        title: 'titile_permission_popup'.tr(),
        message: 'message_photos_permission_popup'.tr(),
        pressButtonLeft: () async {
          await openAppSettings();
        },
      );
    }
  }

  Future<void> _pickCamera(BuildContext context) async {
    final permissionCamera = await Permission.camera.request();
    if (permissionCamera.isGranted) {
      final picker = ImagePicker();
      final fileImageProfile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (fileImageProfile == null) return;
      LoadingShowAble.showLoading();
      await Future.delayed(const Duration(milliseconds: 100), () {});
      File? img = await ImageConvert().fixExifRotation(fileImageProfile.path);
      LoadingShowAble.forceHide();
      img = await _cropImage(imageFile: img);
      _file = img;
      // ignore: use_build_context_synchronously
      context.updateProfileBloc.add(ChangAvatarEvent(avatarPath: img!));
    } else {
      PopupNotificationCustom.showMessgae(
        title: 'titile_permission_popup'.tr(),
        message: 'message_camera_permission_popup'.tr(),
        pressButtonLeft: () async {
          await openAppSettings();
        },
      );
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    'camera'.tr(),
                    style: FONT_CONST.extraBold(fontSize: 15),
                  ),
                  onTap: () {
                    _pickCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('photo_library'.tr(),
                      style: FONT_CONST.extraBold(fontSize: 15)),
                  onTap: () {
                    _pickImage(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
