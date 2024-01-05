import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/create_user_arguments.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/enum_type/work_status.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/screens/manage_staff_group/add_new_user_screen/bloc/new_user_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class AddNewUserScreen extends StatelessWidget {
  const AddNewUserScreen({super.key, required this.createUserArgument});
  final CreateUserArgument createUserArgument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            NewUserBloc()..add(InitNewUserEvent(createUserArgument)),
        child: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.paddingBottom),
          child: BodyScreen(),
        ),
      ),
    );
  }
}

class BodyScreen extends StatefulWidget {
  const BodyScreen({super.key});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  late TextEditingController emailController,
      fullnameController,
      positionController,
      reasonController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    fullnameController = TextEditingController();
    positionController = TextEditingController();
    reasonController = TextEditingController();
    // context.newUserBloc.add(InitNewUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<NewUserBloc, NewUserState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            LoadingShowAble.showLoading();
          } else if (state.status.isSubmissionSuccess) {
            LoadingShowAble.hideLoading();
            if (state.message == 'Tạo người dùng thành công'.tr()) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: "Tạo người dùng thành công".tr(),
              );
              Navigator.of(context).pop(true);
            }
          } else if (state.status.isSubmissionFailure) {
            LoadingShowAble.hideLoading();

            PopupNotificationCustom.showMessgae(
              title: "title_error".tr(),
              message: state.message ?? "",
              hiddenButtonLeft: true,
            );
          } else {
            LoadingShowAble.hideLoading();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarDefaultCustom(title: 'Thêm nhân sự'.tr(), isCallBack: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleField(
                      title: 'Email người dùng'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'email'.tr(),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      // focusNode: nameFocusNode,
                      validator: (p0) {
                        final email = p0?.trim();
                        if (email == null || email.isEmpty) {
                          context.newUserBloc.add(CheckValidEmailEvent(false));
                          return 'required_email'.tr();
                        } else {
                          final isValid =
                              RegexPattern.emailRegExp.hasMatch(email);
                          if (!isValid) {
                            context.newUserBloc
                                .add(CheckValidEmailEvent(false));
                            return 'error_invalid_email'.tr();
                          }
                          context.newUserBloc.add(CheckValidEmailEvent(true));
                          return null;
                        }
                      },
                      suffixIcon: BlocBuilder<NewUserBloc, NewUserState>(
                        buildWhen: (p, c) => p.isValidEmail != c.isValidEmail,
                        builder: (context, state) {
                          if (state.isValidEmail != null &&
                              state.isValidEmail!) {
                            return Container(
                              alignment: Alignment.center,
                              width: 0,
                              child: SvgPicture.asset(
                                ICON_CONST.icCheckAccept.path,
                                width: 15,
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    const VerticalSpacing(of: 6),
                    TitleField(
                      title: 'Họ và tên'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 4),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'fullname'.tr(),
                      controller: fullnameController,
                      // focusNode: nameFocusNode,

                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'fullname is required'.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpacing(of: 6),
                    BlocBuilder<NewUserBloc, NewUserState>(
                      buildWhen: (p, c) => p.userType != c.userType,
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleField(
                            title: 'Vai trò'.tr(),
                            isRequired: true,
                          ),
                          const VerticalSpacing(of: 6),
                          CustomDropdownButton(
                            marginTop: 0,
                            datas: (Singleton.instance.userType !=
                                        UserType.ADMIN
                                    ? UserType.values
                                        .where((element) =>
                                            element.type >
                                            Singleton.instance.userType!.type)
                                        .toList()
                                    : UserType.values)
                                .map(
                                  (e) => DropdownMenuItem<UserType>(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            selectedDefault: state.userType,
                            onSelectionChanged: (p0) {
                              if (p0 is UserType) {
                                context.newUserBloc
                                    .add(ChangeUserTypeEvent(userType: p0));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpacing(of: 6),
                    UserWorkWidget(
                      positionController: positionController,
                      reasonController: reasonController,
                    ),
                    const VerticalSpacing(of: 15),
                    PrimaryButton(
                      title: 'Tạo',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.newUserBloc.add(
                            CreateUserEvent(
                              email: emailController.text.trim(),
                              fullName: fullnameController.text.trim(),
                              position: positionController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                    const VerticalSpacing(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserWorkWidget extends StatelessWidget {
  const UserWorkWidget({
    super.key,
    required this.positionController,
    required this.reasonController,
  });
  final TextEditingController positionController, reasonController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
        buildWhen: (p, c) => p.userType != c.userType,
        builder: (context, state) {
          final userTypeLogin = Singleton.instance.userType;

          return state.userType == UserType.ADMIN
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Công việc',
                      style: FONT_CONST.bold(fontSize: 22),
                    ),
                    const VerticalSpacing(of: 8),
                    if (userTypeLogin!.type < UserType.CEO.type)
                      OrganizationSection(),
                    if (userTypeLogin.type < UserType.DIRECTOR.type)
                      BranchSection(),
                    if (userTypeLogin.type < UserType.MANAGER.type)
                      DepartmentSection(),
                    if (userTypeLogin.type < UserType.LEADER.type)
                      TeamSection(),
                    PositionSection(
                      controller: positionController,
                    ),
                    // WorkStatusSection(),
                    // ReasonSection(controller: reasonController),
                  ],
                );
        });
  }
}

class ReasonSection extends StatelessWidget {
  const ReasonSection({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) => p.workStatus != c.workStatus,
      builder: (context, state) {
        return (state.workStatus != WorkStatus.WORKING)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Lý do'.tr(),
                    isRequired: true,
                  ),
                  const VerticalSpacing(of: 4),
                  CustomTextFormField(
                    maxLength: 255,
                    hintText:
                        'Lý do không làm việc nữa/ tạm hoãn làm việc'.tr(),
                    controller: controller,
                    validator: (p0) {
                      final value = p0?.trim();
                      if (value == null || value.isEmpty) {
                        return 'reason is required'.tr();
                      }
                      return null;
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class PositionSection extends StatelessWidget {
  const PositionSection({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) => p.userType != c.userType,
      builder: (context, state) {
        return (state.userType != null &&
                state.userType!.type == UserType.STAFF.type)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Vị trí'.tr(),
                    isRequired: true,
                  ),
                  const VerticalSpacing(of: 4),
                  CustomTextFormField(
                    maxLength: 255,
                    hintText: 'Software Engineer/ BA....'.tr(),
                    controller: controller,
                    validator: (p0) {
                      final value = p0?.trim();
                      if (value == null || value.isEmpty) {
                        return 'position is required'.tr();
                      }
                      return null;
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class WorkStatusSection extends StatelessWidget {
  const WorkStatusSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) => p.userType != c.userType,
      builder: (context, state) {
        return (state.userType != null &&
                state.userType!.type >= UserType.DIRECTOR.type)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Trạng thái làm việc'.tr(),
                  ),
                  const VerticalSpacing(of: 3),
                  CustomDropdownButton(
                    marginTop: 0,
                    datas: WorkStatus.values
                        .map(
                          (e) => DropdownMenuItem<WorkStatus>(
                            value: e,
                            child: Text(
                              e.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedDefault: state.workStatus,
                    onSelectionChanged: (p0) {
                      context.newUserBloc
                          .add(ChangeWorkStatusEvent(workStatus: p0));
                    },
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class TeamSection extends StatelessWidget {
  const TeamSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) =>
          p.teamsList != c.teamsList ||
          p.userType != c.userType ||
          p.selectedTeam != c.selectedTeam,
      builder: (context, state) {
        return (state.userType != null &&
                state.userType!.type >= UserType.LEADER.type)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Team'.tr(),
                    isRequired: (context.newUserBloc.state.userType != null &&
                            context.newUserBloc.state.userType!.type >=
                                UserType.LEADER.type)
                        ? true
                        : false,
                  ),
                  const VerticalSpacing(of: 3),
                  CustomDropdownButton(
                    marginTop: 0,
                    datas: (state.teamsList ?? [])
                        .map(
                          (e) => DropdownMenuItem<TeamModel>(
                            value: e,
                            child: Text(
                              e.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedDefault: state.selectedTeam,
                    onSelectionChanged: (p0) {
                      context.newUserBloc.add(ChangeTeamEvent(teamModel: p0));
                    },
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class DepartmentSection extends StatelessWidget {
  const DepartmentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) =>
          p.departmentsList != c.departmentsList ||
          p.userType != c.userType ||
          p.selectedDepartment != c.selectedDepartment,
      builder: (context, state) {
        return (state.userType != null &&
                state.userType!.type >= UserType.MANAGER.type)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Phòng ban'.tr(),
                    isRequired: (context.newUserBloc.state.userType != null &&
                            context.newUserBloc.state.userType!.type >=
                                UserType.MANAGER.type)
                        ? true
                        : false,
                  ),
                  const VerticalSpacing(of: 3),
                  CustomDropdownButton(
                    marginTop: 0,
                    datas: (state.departmentsList ?? [])
                        .map(
                          (e) => DropdownMenuItem<DepartmentModel>(
                            value: e,
                            child: Text(
                              e.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedDefault: state.selectedDepartment,
                    onSelectionChanged: (p0) {
                      context.newUserBloc
                          .add(ChangeDepartmentEvent(departmentModel: p0));
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class BranchSection extends StatelessWidget {
  const BranchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewUserBloc, NewUserState>(
      buildWhen: (p, c) =>
          p.branchesList != c.branchesList ||
          p.userType != c.userType ||
          p.selectedBranch != c.selectedBranch,
      builder: (context, state) {
        return (state.userType != null &&
                state.userType!.type >= UserType.DIRECTOR.type)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleField(
                    title: 'Chi nhánh'.tr(),
                    isRequired: (context.newUserBloc.state.userType != null &&
                            context.newUserBloc.state.userType!.type >=
                                UserType.DIRECTOR.type)
                        ? true
                        : false,
                  ),
                  const VerticalSpacing(of: 3),
                  CustomDropdownButton(
                    marginTop: 0,
                    datas: (state.branchesList ?? [])
                        .map(
                          (e) => DropdownMenuItem<BranchOfficeModel>(
                            value: e,
                            child: Text(
                              e.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedDefault: state.selectedBranch,
                    onSelectionChanged: (p0) {
                      context.newUserBloc
                          .add(ChangeBranchOfficeEvent(branchOfficeModel: p0));
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class OrganizationSection extends StatelessWidget {
  const OrganizationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleField(
          title: 'Tổ chức'.tr(),
          isRequired: true,
        ),
        const VerticalSpacing(of: 3),
        BlocBuilder<NewUserBloc, NewUserState>(
          buildWhen: (p, c) =>
              p.organizationsList != c.organizationsList ||
              p.selectedOrganization != c.selectedOrganization,
          builder: (context, state) {
            return CustomDropdownButton(
              marginTop: 0,
              datas: (state.organizationsList ?? [])
                  .map(
                    (e) => DropdownMenuItem<OrganizationModel>(
                      value: e,
                      child: Text(
                        e.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              selectedDefault: state.selectedOrganization,
              onSelectionChanged: (p0) {
                context.newUserBloc
                    .add(ChangeOrganizationEvent(organizationModel: p0));
              },
            );
          },
        ),
      ],
    );
  }
}
