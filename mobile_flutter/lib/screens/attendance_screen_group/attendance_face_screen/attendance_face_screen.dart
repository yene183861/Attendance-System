import 'dart:developer';
import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/screens/attendance_screen_group/attendance_face_screen/bloc/attendance_face_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AttendanceFaceScreen extends StatelessWidget {
  const AttendanceFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (context) => AttendanceFaceBloc(),
            child: const CustomSmartFaceCamera()));
  }
}

class CustomSmartFaceCamera extends StatefulWidget {
  const CustomSmartFaceCamera({super.key});

  @override
  State<CustomSmartFaceCamera> createState() => _CustomSmartFaceCameraState();
}

class _CustomSmartFaceCameraState extends State<CustomSmartFaceCamera> {
  int countFile = 0;
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppbarDefaultCustom(title: 'Chấm công', isCallBack: true),
        Expanded(
          child: BlocListener<AttendanceFaceBloc, AttendanceFaceState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status.isSubmissionInProgress) {
                LoadingShowAble.showLoading();
                // if (state.message != null && state.message!.isNotEmpty) {
                //   ToastShowAble.show(
                //       toastType: ToastMessageType.INFO,
                //       message: state.message ?? '');
                // }
              } else if (state.status.isSubmissionSuccess) {
                LoadingShowAble.forceHide();

                if (state.message != null && state.message!.isNotEmpty) {
                  ToastShowAble.show(
                      toastType: ToastMessageType.SUCCESS,
                      message: state.message ?? '');

                  Navigator.of(context).pop();
                }
                countFile = 0;
                files = [];
              } else if (state.status.isSubmissionFailure) {
                LoadingShowAble.forceHide();
                countFile = 0;
                files = [];
                ToastShowAble.show(
                    toastType: ToastMessageType.ERROR,
                    message: state.message ?? '');
                Navigator.of(context).pop();
              } else {
                LoadingShowAble.forceHide();
              }
            },
            child: SmartFaceCamera(
                autoCapture: true,
                autoRecord: false,
                enableAudio: false,
                defaultCameraLens: CameraLens.front,
                onCapture: (File? image) {
                  log('CAPTURE DONE ${countFile}');
                  if (image != null) {
                    if (countFile < 1) {
                      countFile = countFile + 1;
                      files.add(image);

                      if (countFile == 1) {
                        context.attendanceFaceBloc
                            .add(AttendanceByFaceEvent(files: files));
                      }
                    }
                  }
                },
                onFaceDetected: (Face? face) {},
                onRecordDone: (File? file) {},
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
