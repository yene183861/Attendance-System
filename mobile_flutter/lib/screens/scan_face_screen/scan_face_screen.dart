import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:firefly/screens/scan_face_screen/bloc/scan_face_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ScanFaceScreen extends StatelessWidget {
  const ScanFaceScreen({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => ScanFaceBloc(user: user),
            child: const CustomSmartFaceCamera()));
  }
}

class CustomSmartFaceCamera extends StatelessWidget {
  const CustomSmartFaceCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const VerticalSpacing(of: 30),
        const AppbarDefaultCustom(title: 'Đăng ký gương mặt', isCallBack: true),
        Expanded(
          child: BlocListener<ScanFaceBloc, ScanFaceState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status.isSubmissionInProgress) {
                if (state.message != null && state.message!.isNotEmpty) {
                  ToastShowAble.show(
                      toastType: ToastMessageType.INFO,
                      message: state.message ?? '');
                }
              } else if (state.status.isSubmissionSuccess) {
                if (state.message != null && state.message!.isNotEmpty) {
                  ToastShowAble.show(
                      toastType: ToastMessageType.SUCCESS,
                      message: state.message ?? '');
                  Navigator.of(context).pop(true);
                }
              } else if (state.status.isSubmissionSuccess) {
                PopupNotificationCustom.showMessgae(
                    title: 'error', message: state.message ?? '');
              }
            },
            child: SmartFaceCamera(
                autoCapture: false,
                autoRecord: true,
                enableAudio: false,
                defaultCameraLens: CameraLens.front,
                onCapture: (File? image) {},
                onFaceDetected: (Face? face) {},
                onRecordDone: (File? file) {
                  context.scanFaceBloc.add(RegisterFaceEvent(video: file));
                },
                textStyle: FONT_CONST.medium(
                    fontSize: 18, color: COLOR_CONST.backgroundColor),
                messageBuilder: (context, face) {
                  if (face == null) {
                    return _message('Place your face in the camera');
                  }
                  if (!face.wellPositioned) {
                    return _message('Center your face in the square');
                  }
                  return const SizedBox.shrink();
                }),
          ),
        ),
      ],
    );
  }

  Widget _message(String msg) => Padding(
        padding: defaultPadding(horizontal: 30, vertical: 50),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: FONT_CONST.bold(
                color: COLOR_CONST.backgroundColor, fontSize: 18)),
      );
}
