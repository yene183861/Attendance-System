import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';
import 'package:firefly/data/arguments/transfer_staff_argument.dart';

import 'package:firefly/screens/manage_staff_group/transfer_staff_screen/bloc/transfer_staff_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/enum_type/work_status.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

class TransferStaffScreen extends StatelessWidget {
  const TransferStaffScreen({super.key, required this.arg});
  final TransferStaffArgument arg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            TransferStaffBloc(arg: arg)..add(InitTransferStaffEvent()),
        child: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.paddingBottom),
          child: const BodyScreen(),
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
    final state = context.transferStaffBloc.state;
    final userWorkModel = state.userWorkModel;
    emailController =
        TextEditingController(text: userWorkModel.user?.email ?? '');
    fullnameController =
        TextEditingController(text: userWorkModel.user?.fullname ?? '');
    positionController =
        TextEditingController(text: userWorkModel.position ?? '');
    reasonController = TextEditingController(text: userWorkModel.reason ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<TransferStaffBloc, TransferStaffState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            LoadingShowAble.showLoading();
          } else if (state.status.isSubmissionSuccess) {
            LoadingShowAble.forceHide();
            if (state.message == 'Điều chuyển nhân sự thành công'.tr()) {
              ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: "Điều chuyển nhân sự thành công".tr(),
              );
              Navigator.of(context).pop(true);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarDefaultCustom(
                title: 'Điều chuyển nhân sự'.tr(), isCallBack: true),
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
                      hintText: 'email'.tr(),
                      enabled: false,
                      controller: emailController,
                    ),
                    const VerticalSpacing(of: 15),
                    TitleField(
                      title: 'Họ và tên'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 4),
                    CustomTextFormField(
                      hintText: 'fullname'.tr(),
                      enabled: false,
                      controller: fullnameController,
                    ),
                    const VerticalSpacing(of: 15),
                    BlocBuilder<TransferStaffBloc, TransferStaffState>(
                      buildWhen: (p, c) => p.userType != c.userType,
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleField(
                            title: 'Vai trò'.tr(),
                            isRequired: true,
                          ),
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
                                context.transferStaffBloc
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
                      title: 'Thay đổi',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.transferStaffBloc.add(
                            TransferUserWorkEvent(),
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
                      const OrganizationSection(),
                    if (userTypeLogin.type < UserType.DIRECTOR.type)
                      const BranchSection(),
                    if (userTypeLogin.type < UserType.MANAGER.type)
                      const DepartmentSection(),
                    if (userTypeLogin.type < UserType.LEADER.type)
                      const TeamSection(),
                    PositionSection(
                      controller: positionController,
                    ),
                    const WorkStatusSection(),
                    ReasonSection(controller: reasonController),
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
      buildWhen: (p, c) => p.workStatus != c.workStatus,
      builder: (context, state) {
        return Column(
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
                  'Lý do điều chuyển/ không làm việc nữa/ tạm hoãn làm việc'
                      .tr(),
              controller: controller,
              maxLines: null,
              maxLinesHintText: 2,
              validator: (p0) {
                final value = p0?.trim();
                if (value == null || value.isEmpty) {
                  return 'reason is required'.tr();
                }
                return null;
              },
            ),
          ],
        );
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
                              e.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedDefault: state.workStatus,
                    onSelectionChanged: (p0) {
                      context.transferStaffBloc
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
                    isRequired: (context.transferStaffBloc.state.userType !=
                                null &&
                            context.transferStaffBloc.state.userType!.type >=
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
                      context.transferStaffBloc
                          .add(ChangeTeamEvent(teamModel: p0));
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
                    isRequired: (context.transferStaffBloc.state.userType !=
                                null &&
                            context.transferStaffBloc.state.userType!.type >=
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
                      context.transferStaffBloc
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
    return BlocBuilder<TransferStaffBloc, TransferStaffState>(
      buildWhen: (p, c) =>
          p.branchsList != c.branchsList ||
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
                    isRequired: (context.transferStaffBloc.state.userType !=
                                null &&
                            context.transferStaffBloc.state.userType!.type >=
                                UserType.DIRECTOR.type)
                        ? true
                        : false,
                  ),
                  const VerticalSpacing(of: 3),
                  CustomDropdownButton(
                    marginTop: 0,
                    datas: (state.branchsList ?? [])
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
                      context.transferStaffBloc
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
        BlocBuilder<TransferStaffBloc, TransferStaffState>(
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
                context.transferStaffBloc
                    .add(ChangeOrganizationEvent(organizationModel: p0));
              },
            );
          },
        ),
      ],
    );
  }
}
