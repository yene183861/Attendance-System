import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/search_user_field.dart';

import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';

import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc/face_registered_list_bloc.dart';
import 'components/face_item.dart';
import 'components/filter_face_dialog.dart';

class FaceRegisteredListScreen extends StatelessWidget {
  const FaceRegisteredListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => FaceRegisteredListBloc(),
          child: const RegisterFaceBodyScreen()),
    );
  }
}

class RegisterFaceBodyScreen extends StatefulWidget {
  const RegisterFaceBodyScreen({
    super.key,
  });

  @override
  State<RegisterFaceBodyScreen> createState() => _RegisterFaceBodyScreenState();
}

class _RegisterFaceBodyScreenState extends State<RegisterFaceBodyScreen> {
  late TextEditingController nameCtrol;
  // late TextfieldTagsController tagController;

  final textSearchChange = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    nameCtrol = TextEditingController();
    context.faceRegisteredListBloc.add(InitEvent());

    nameCtrol.addListener(() {
      textSearchChange.value = nameCtrol.text;
    });

    textSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();

      context.faceRegisteredListBloc.add(SearchUserWorkEvent(name: textSearch));
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrol.removeListener(() {});
    nameCtrol.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Singleton.instance.userType!;
    return BlocListener<FaceRegisteredListBloc, FaceRegisteredListState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.hideLoading();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? '',
            hiddenButtonLeft: true,
          );
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.hideLoading();
          if (state.message != null && state.message!.isNotEmpty) {
            if (state.message != null && state.message!.isNotEmpty) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '',
              );
            }
          }
        } else {
          LoadingShowAble.hideLoading();
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Padding(
            padding: defaultPadding(horizontal: 20, vertical: 0),
            child: Column(
              children: [
                const AppbarDefaultCustom(
                    title: 'Quản lý việc đăng ký\nchấm công', isCallBack: true),
                const VerticalSpacing(of: 20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (userType.type <= UserType.MANAGER.type)
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final state =
                                        context.faceRegisteredListBloc.state;
                                    final arg = CommonArgument(
                                      organizationsList:
                                          state.organizationsList,
                                      branchList: state.branchList,
                                      departmentList: state.departmentList,
                                      teamList: state.teamList,
                                      selectedBranch: state.selectedBranch,
                                      selectedOrganization:
                                          state.selectedOrganization,
                                      selectedDepartment:
                                          state.selectedDepartment,
                                      selectedTeam: state.selectedTeam,
                                    );
                                    final res = await showDialog(
                                        context: context,
                                        builder: (mContext) => BlocProvider(
                                              create: (context) =>
                                                  FaceRegisteredListBloc(
                                                commonArgument: arg,
                                              )
                                                    ..add(
                                                        GetBranchOfficeEvent())
                                                    ..add(GetDepartmentEvent())
                                                    ..add(GetTeamEvent()),
                                              child: const Dialog(
                                                child: FilterFaceDialog(),
                                              ),
                                            ));
                                    if (res is CommonArgument) {
                                      context.faceRegisteredListBloc.add(
                                          SelectUserEvent(
                                              user: UserWorkModel()));

                                      context.faceRegisteredListBloc
                                          .add(CopyStateEvent(arg: res));
                                    }
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      ICON_CONST.icFilter1.path,
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const HorizontalSpacing(of: 8),
                              ],
                            ),
                          if (userType.type <= UserType.LEADER.type)
                            Expanded(
                              child: BlocBuilder<FaceRegisteredListBloc,
                                      FaceRegisteredListState>(
                                  buildWhen: (p, c) =>
                                      p.users != c.users ||
                                      p.selectedUser != c.selectedUser,
                                  builder: (context, state) {
                                    return SearchUserField(
                                      onSelectedUser: (UserWorkModel) {
                                        context.faceRegisteredListBloc.add(
                                            SelectUserEvent(
                                                user: UserWorkModel));
                                      },
                                      textController: nameCtrol,
                                      users: state.users ?? [],
                                      userWorkModel: state.selectedUser,
                                      textSearchChange: (String) {
                                        nameCtrol.notifyListeners();
                                      },
                                    );
                                  }),
                            ),
                        ],
                      ),
                      const VerticalSpacing(),
                      BlocBuilder<FaceRegisteredListBloc,
                          FaceRegisteredListState>(
                        buildWhen: (p, c) => p.selectedUser != c.selectedUser,
                        builder: (context, state) => state.selectedUser?.id !=
                                null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nhân viên: ',
                                    style: FONT_CONST.medium(),
                                  ),
                                  UserItem(
                                    userWorkModel: state.selectedUser!,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            : Text(
                                'Danh sách nhân viên đã đăng ký',
                                textAlign: TextAlign.center,
                                style: FONT_CONST.medium(),
                              ),
                      ),
                      const VerticalSpacing(),
                      BlocBuilder<FaceRegisteredListBloc,
                          FaceRegisteredListState>(
                        buildWhen: (p, c) =>
                            p.facesList != c.facesList ||
                            p.selectedUser != c.selectedUser,
                        builder: (context, state) {
                          if (state.facesList != null &&
                              state.facesList!.isNotEmpty) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.facesList!.length,
                              itemBuilder: (context, index) =>
                                  FaceItem(model: state.facesList![index]),
                              separatorBuilder: (context, index) =>
                                  VerticalSpacing(of: 5),
                            );
                          }
                          return state.selectedUser?.id == null
                              ? Padding(
                                  padding: defaultPadding(
                                      vertical: 20, horizontal: 0),
                                  child: Text(
                                    'Không có dữ liệu',
                                    style: FONT_CONST.regular(
                                        color: COLOR_CONST.silverChalice),
                                  ),
                                )
                              : Padding(
                                  padding: defaultPadding(
                                      vertical: 20, horizontal: 0),
                                  child: Text(
                                      'Nhân viên này chưa đăng ký chấm công',
                                      style: FONT_CONST.medium(
                                          color: COLOR_CONST.portlandOrange)),
                                );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (Singleton.instance.userType!.type <= UserType.LEADER.type)
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: defaultPadding(horizontal: 25),
                  decoration: BoxDecoration(
                      color: COLOR_CONST.backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: COLOR_CONST.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(-2, -2),
                        ),
                      ]),
                  child: PrimaryButton(
                    title: 'Đăng ký'.tr(),
                    onPressed: () async {
                      final res = await showDialog(
                        context: context,
                        builder: (mContext) => BlocProvider.value(
                          value: context.faceRegisteredListBloc,
                          child: Dialog(
                              child: DialogRegisterFace(mContext: context)),
                        ),
                      );
                      // final org =
                      //     context.allowanceBloc.state.selectedOrganization;
                      // if (org != null) {
                      //   final value = await Navigator.of(context).pushNamed(
                      //     AppRouter.EDIT_ALLOWANCE_SCREEN,
                      //     arguments: EditAllowanceArgument(
                      //       idOrganization: org.id!,
                      //     ),
                      //   );
                      //   if (value == true) {
                      //     context.allowanceBloc.add(GetAllowanceEvent());
                      //   }
                      // } else {
                      //   PopupNotificationCustom.showMessgae(
                      //     title: "title_error".tr(),
                      //     message: "",
                      //     hiddenButtonLeft: true,
                      //   );
                      // }
                    },
                  ),
                )),
        ],
      ),
    );
  }
}

class DialogRegisterFace extends StatefulWidget {
  const DialogRegisterFace({
    super.key,
    required this.mContext,
  });

  final BuildContext mContext;

  @override
  State<DialogRegisterFace> createState() => _DialogRegisterFaceState();
}

class _DialogRegisterFaceState extends State<DialogRegisterFace> {
  late TextEditingController searchController;

  final nameSearchChange = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    searchController.addListener(() {
      nameSearchChange.value = searchController.text;
    });

    nameSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();

      widget.mContext.faceRegisteredListBloc
          .add(SearchUserWorkEvent(name: textSearch));
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultPadding(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chọn nhân viên',
            style: FONT_CONST.bold(fontSize: 20),
          ),
          const VerticalSpacing(of: 10),
          BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
              buildWhen: (p, c) =>
                  p.users != c.users || p.selectedUser != c.selectedUser,
              builder: (context, state) {
                return SearchUserField(
                  onSelectedUser: (UserWorkModel) {
                    widget.mContext.faceRegisteredListBloc
                        .add(SelectUserEvent(user: UserWorkModel));
                  },
                  textController: searchController,
                  users: state.users ?? [],
                  userWorkModel: state.selectedUser,
                  textSearchChange: (String) {
                    searchController.notifyListeners();
                  },
                );
              }),
          const VerticalSpacing(of: 10),
          BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
              buildWhen: (p, c) => p.selectedUser != c.selectedUser,
              builder: (context, state) {
                return state.selectedUser?.id != null
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhân viên:',
                              style: FONT_CONST.regular(),
                            ),
                            Text(
                                'Họ và tên: ${state.selectedUser!.user!.fullname}'),
                            Text('Email: ${state.selectedUser!.user!.email}'),
                            Text('Email: ${state.selectedUser!.user!.email}'),
                          ],
                        ),
                      )
                    : Text(
                        'Bạn chưa chọn nhân viên',
                        style: FONT_CONST.medium(
                            color: COLOR_CONST.portlandOrange),
                      );
              }),
          BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
              buildWhen: (p, c) =>
                  p.facesList != c.facesList ||
                  p.selectedUser != c.selectedUser,
              builder: (context, state) {
                return state.selectedUser?.user?.id != null
                    ? (state.facesList != null && state.facesList!.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Nhân viên này đã được đăng ký gương mặt',
                              style: FONT_CONST.regular(
                                  color: COLOR_CONST.portlandOrange,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink()
                    : const SizedBox.shrink();
              }),
          const VerticalSpacing(of: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                    padding: defaultPadding(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: COLOR_CONST.athensGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hủy',
                      style: FONT_CONST.medium(),
                    )),
              ),
              const HorizontalSpacing(),
              InkWell(
                onTap: () async {
                  final user = widget
                      .mContext.faceRegisteredListBloc.state.selectedUser?.user;
                  if (user?.id != null) {
                    final listFaces =
                        widget.mContext.faceRegisteredListBloc.state.facesList;
                    if (listFaces != null && listFaces.isNotEmpty) {
                      return;
                    } else {
                      Navigator.of(context).pop();
                      final res = await Navigator.of(widget.mContext).pushNamed(
                          AppRouter.SCAN_FACE_SCREEN,
                          arguments: user);
                      if (res == true) {
                        widget.mContext.faceRegisteredListBloc
                            .add(GetListFaceEvent());
                      }
                    }
                  } else {
                    return;
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                    padding: defaultPadding(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: COLOR_CONST.cloudBurst,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Đăng ký',
                      style:
                          FONT_CONST.medium(color: COLOR_CONST.backgroundColor),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.userWorkModel,
    required this.color,
  });

  final UserWorkModel userWorkModel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final user = userWorkModel.user;
    final position = userWorkModel.position;
    return InkWell(
      onTap: () {},
      child: Ink(
        padding: defaultPadding(horizontal: 15, vertical: 10),
        color: color,
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenHeight(50),
              child: CachedNetworkImage(
                imageUrl: userWorkModel.user?.avatarThumb ?? '',
                placeholder: (context, url) => CircleAvatar(
                  backgroundImage: AssetImage(
                    IMAGE_CONST.imgDefaultAvatar.path,
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundImage: AssetImage(
                    IMAGE_CONST.imgDefaultAvatar.path,
                  ),
                ),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              ),
            ),
            const HorizontalSpacing(of: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: user?.fullname ?? ''),
                        (user?.username != null && user!.username!.isNotEmpty)
                            ? TextSpan(text: '( ${user.username} )')
                            : TextSpan(text: ''),
                      ],
                      style: FONT_CONST.extraBold(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 16,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${'Email liên hệ'.tr()}: ",
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: user?.email ?? '',
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      style: FONT_CONST.regular(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${'Vị trí'.tr()}: ",
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: position,
                          style: FONT_CONST.medium(
                            color: COLOR_CONST.cloudBurst,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      style: FONT_CONST.regular(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: getProportionateScreenHeight(50),
            //   width: getProportionateScreenHeight(50),
            //   child: CachedNetworkImage(
            //     imageUrl: userWorkModel.user?.avatarThumb ?? '',
            //     placeholder: (context, url) => Image.(
            //       backgroundImage: AssetImage(
            //         IMAGE_CONST.imgDefaultAvatar.path,
            //       ),
            //     ),
            //     errorWidget: (context, url, error) => CircleAvatar(
            //       backgroundImage: AssetImage(
            //         IMAGE_CONST.imgDefaultAvatar.path,
            //       ),
            //     ),
            //     imageBuilder: (context, imageProvider) => CircleAvatar(
            //       backgroundImage: imageProvider,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class Testttt extends StatelessWidget {
  const Testttt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FaceCapture example app'),
        ),
        body:
            // if (_capturedImage != null) {
            //   return Center(
            //     child: Stack(
            //       alignment: Alignment.bottomCenter,
            //       children: [
            //         Image.file(
            //           _capturedImage!,
            //           width: double.maxFinite,
            //           fit: BoxFit.fitWidth,
            //         ),
            //         ElevatedButton(
            //             onPressed: () => setState(() => _capturedImage = null),
            //             child: const Text(
            //               'Capture Again',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                   fontSize: 14, fontWeight: FontWeight.w700),
            //             ))
            //       ],
            //     ),
            //   );
            // }
            BlocProvider(
                create: (context) => FaceRegisteredListBloc(),
                child: Content()));
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // if (_capturedImage != null) {
      //   return Center(
      //     child: Stack(
      //       alignment: Alignment.bottomCenter,
      //       children: [
      //         Image.file(
      //           _capturedImage!,
      //           width: double.maxFinite,
      //           fit: BoxFit.fitWidth,
      //         ),
      //         ElevatedButton(
      //             onPressed: () => setState(() => _capturedImage = null),
      //             child: const Text(
      //               'Capture Again',
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                   fontSize: 14, fontWeight: FontWeight.w700),
      //             ))
      //       ],
      //     ),
      //   );
      // }
      return SmartFaceCamera(
          autoCapture: false,
          autoRecord: true,
          enableAudio: false,
          defaultCameraLens: CameraLens.front,
          onCapture: (File? image) {
            // setState(() => _capturedImage = image);
          },
          onFaceDetected: (Face? face) {
            //Do something
          },
          onRecordDone: (File? file) {
            print('DONEWWEWR ');
            print(file?.path);
            if (file != null) {
              // File convertFile = File(file.path);
              // print('convert done');

              context.faceRegisteredListBloc
                  .add(CreateFaceRegisteredListEvent(video: file));
            } else {
              print('dâdasdada');
            }
          },
          messageBuilder: (context, face) {
            if (face == null) {
              return _message('Place your face in the camera');
            }
            if (!face.wellPositioned) {
              return _message('Center your face in the square');
            }
            return const SizedBox.shrink();
          });
    });
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
      );
}
