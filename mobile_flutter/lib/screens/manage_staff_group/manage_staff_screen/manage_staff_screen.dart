import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/transfer_staff_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/create_user_arguments.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/bloc/manage_staff_bloc.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/components/branch_office_select.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/components/department_select.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/components/organization_select.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/components/team_select.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class ManageStaffScreen extends StatelessWidget {
  const ManageStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => ManageStaffBloc(),
          child: const ManageStaffBodyScreen()),
      appBar: AppbarDefaultCustom(
          title: Singleton.instance.userType == UserType.ADMIN
              ? "Quản lý người dùng".tr()
              : 'Quản lý nhân viên'.tr(),
          isCallBack: true),
    );
  }
}

class ManageStaffBodyScreen extends StatefulWidget {
  const ManageStaffBodyScreen({super.key});

  @override
  State<ManageStaffBodyScreen> createState() => _ManageStaffBodyScreenState();
}

class _ManageStaffBodyScreenState extends State<ManageStaffBodyScreen> {
  @override
  void initState() {
    super.initState();
    context.manageStaffBloc.add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageStaffBloc, ManageStaffState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionInProgress) {
          LoadingShowAble.forceHide();
          if (state.message != null && state.message!.isNotEmpty) {
            ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '');
            context.manageStaffBloc.add(GetUserEvent());
          }
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.forceHide();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonLeft: true,
          );
        } else {
          LoadingShowAble.forceHide();
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: defaultPadding(horizontal: 20, vertical: 0),
                  child: Row(
                    children: [
                      if (Singleton.instance.userType == UserType.ADMIN)
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(15),
                          ),
                          child: const OrganizationSelect(),
                        )),
                      if (Singleton.instance.userType!.type <=
                          UserType.CEO.type)
                        const Expanded(child: BranchOfficeSelect()),
                    ],
                  ),
                ),
                Padding(
                  padding: defaultPadding(horizontal: 20, vertical: 0),
                  child: Row(
                    children: [
                      if (Singleton.instance.userType!.type <=
                          UserType.DIRECTOR.type)
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(15),
                          ),
                          child: DepartmentSelect(),
                        )),
                      if (Singleton.instance.userType!.type <=
                          UserType.MANAGER.type)
                        Expanded(child: TeamSelect()),
                    ],
                  ),
                ),
                BlocBuilder<ManageStaffBloc, ManageStaffState>(
                    buildWhen: (p, c) => p.users != c.users,
                    builder: (context, state) {
                      if (state.users != null && state.users!.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(130)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return UserItem(
                                      userWorkModel: state.users![index],
                                      color: index % 2 == 0
                                          ? Colors.grey.shade200
                                          : COLOR_CONST.backgroundColor);
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemCount: state.users!.length,
                              ),
                              const Divider(height: 1)
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 150),
                          child: Center(child: Text('Không có dữ liệu')),
                        );
                      }
                    }),
              ],
            ),
          ),
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
                  title: 'Thêm nhân sự'.tr(),
                  onPressed: () async {
                    final state = context.manageStaffBloc.state;
                    final value = await Navigator.of(context).pushNamed(
                        AppRouter.ADD_NEW_USER_SCREEN,
                        arguments: CreateUserArgument(
                            organization: state.selectedOrganization,
                            branch: state.selectedBranch,
                            department: state.selectedDepartment,
                            team: state.selectedTeam));
                    if (value == true) {
                      context.manageStaffBloc.add(GetUserEvent());
                    }
                  },
                ),
              )),
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
        padding: defaultPadding(horizontal: 25, vertical: 15),
        color: color,
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  user?.avatarThumb ?? '',
                ),
              ),
            ),
            Flexible(
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
                            : const TextSpan(text: ''),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final state = context.manageStaffBloc.state;
                          final arg = TransferStaffArgument(
                            organizationsList: state.organizationsList,
                            selectedOrganization: state.selectedOrganization,
                            branchList: state.branchesList,
                            selectedBranch: state.selectedBranch,
                            departmentList: state.departmentsList,
                            selectedDepartment: state.selectedDepartment,
                            teamList: state.teamsList,
                            selectedTeam: state.selectedTeam,
                            userWorkModel: userWorkModel,
                          );
                          final res = await Navigator.of(context).pushNamed(
                              AppRouter.TRANSFER_STAFF_SCREEN,
                              arguments: arg);
                          if (res == true) {
                            context.manageStaffBloc.add(GetUserEvent());
                          }
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: COLOR_CONST.cloudBurst,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'update'.tr(),
                            style: FONT_CONST.regular(
                                color: COLOR_CONST.backgroundColor,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const HorizontalSpacing(),
                      InkWell(
                        onTap: () async {
                          final userType = Singleton.instance.userType!;
                          var text =
                              'Bạn có chắc chắn muốn xóa người dùng này trong hệ thống?';
                          var text2 = '';
                          if (userType.type >= UserType.DIRECTOR.type) {
                            text2 =
                                'Nếu chưa được sự cho phép của cấp trên, bạn sẽ phải chiu trách nhiệm trước hành động này';
                          }
                          PopupNotificationCustom.showMessgae(
                            title: 'Xác nhận xóa',
                            message: text + text2,
                            pressButtonRight: () {
                              context.manageStaffBloc
                                  .add(DeleteUserEvent(user: user!));
                            },
                          );
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: COLOR_CONST.portlandOrange,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            'Xóa'.tr(),
                            style: FONT_CONST.regular(
                                color: COLOR_CONST.backgroundColor,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
