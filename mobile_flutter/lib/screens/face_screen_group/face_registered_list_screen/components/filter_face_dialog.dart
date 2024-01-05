import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/screens/face_screen_group/face_registered_list_screen/bloc/face_registered_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/data/arguments/common_argument.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../../custom_widget/dropdown_menu_button_function.dart';

class FilterFaceDialog extends StatelessWidget {
  const FilterFaceDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userType = Singleton.instance.userType!;
    return Container(
      padding: defaultPadding(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: COLOR_CONST.backgroundColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bộ lọc',
              style: FONT_CONST.bold(fontSize: 18),
            ),
            if (userType.type == UserType.ADMIN.type)
              const FilterByOrganization(),
            if (userType.type <= UserType.CEO.type) const FilterByBranch(),
            if (userType.type <= UserType.DIRECTOR.type)
              const FilterByDepartment(),
            if (userType.type <= UserType.MANAGER.type) const FilterByTeam(),
            PrimaryButton(
              title: 'Lọc',
              onPressed: () {
                final state = context.faceRegisteredListBloc.state;
                var selectedOrganization = state.selectedOrganization;
                var selectedBranch = !(state.selectedOrganization != null &&
                        state.selectedOrganization?.id != null)
                    ? null
                    : state.selectedBranch;
                var selectedDepartment = !(state.selectedBranch != null &&
                        state.selectedBranch?.id != null)
                    ? null
                    : state.selectedDepartment;
                var selectedTeam = !(state.selectedDepartment != null &&
                        state.selectedDepartment?.id != null)
                    ? null
                    : state.selectedTeam;

                final arg = CommonArgument(
                  organizationsList: state.organizationsList,
                  branchList: state.branchList,
                  departmentList: state.departmentList,
                  teamList: state.teamList,
                  selectedBranch: selectedBranch,
                  selectedOrganization: selectedOrganization,
                  selectedDepartment: selectedDepartment,
                  selectedTeam: selectedTeam,
                );
                log('${selectedOrganization}');
                Navigator.of(context).pop(arg);
              },
            ),
            const VerticalSpacing(of: 10),
            PrimaryBorderButton(
              title: 'Hủy',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterByOrganization extends StatelessWidget {
  const FilterByOrganization({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
      buildWhen: (p, c) =>
          p.organizationsList != c.organizationsList ||
          p.selectedOrganization != c.selectedOrganization,
      builder: (context, state) {
        return DropdownMenuButtonFuction(
          title: 'organization'.tr(),
          bottomWidget: const SizedBox.shrink(),
          // GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //       context.bonusDisciplineBloc.add(ChangeBranchOfficeEvent(
          //           model: BranchOfficeModel()));
          //       context.bonusDisciplineBloc.add(
          //           ChangeDepartmentEvent(model: DepartmentModel()));
          //       context.bonusDisciplineBloc
          //           .add(ChangeTeamEvent(model: TeamModel()));
          //     },
          //     child: Container(
          //       height: double.maxFinite,
          //       decoration: BoxDecoration(
          //         border: Border(
          //             top: BorderSide(
          //                 color:
          //                     COLOR_CONST.lineGrey.withOpacity(0.4))),
          //         color: COLOR_CONST.lineGrey.withOpacity(0.3),
          //       ),
          //       child: Center(
          //           child: Text(
          //         'Lọc trong toàn bộ tổ chức',
          //         style: FONT_CONST.regular(),
          //         maxLines: null,
          //       )),
          //     )),
          isFullwidthDropBox: false,
          marginTop: 0,
          datas: (state.organizationsList ?? [])
              .map((item) => ItemData(
                    index: item.id ?? 0,
                    title: item.name ?? '',
                    object: item,
                  ))
              .toList(),
          itemInit: ItemData(
            index: state.selectedOrganization?.id ?? 0,
            title: state.selectedOrganization?.name ?? "Chọn tổ chức",
            object: state.selectedOrganization,
          ),
          onClickIcon: (p0) {},
          onSelectionItem: (p0) {
            if (p0.object.id != state.selectedOrganization?.id) {
              context.faceRegisteredListBloc
                  .add(ChangeOrganizationEvent(model: p0.object));
            }
          },
        );
        // CustomDropdownButton(
        //   marginTop: 0,
        //   colorBorderFocused: COLOR_CONST.cloudBurst,
        //   title: 'organization'.tr(),
        //   datas: (state.organizationsList ?? [])
        //       .map((e) => DropdownMenuItem<OrganizationModel>(
        //             value: e,
        //             child: Text(
        //               e.name ?? '',
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               style: FONT_CONST.regular(),
        //             ),
        //           ))
        //       .toList(),
        //   selectedDefault: state.selectedOrganization,
        //   onSelectionChanged: (p0) {
        //     if (p0?.id != state.selectedOrganization?.id) {
        //       context.bonusDisciplineBloc
        //           .add(ChangeOrganizationEvent(model: p0));
        //     }
        //   },
        // );
      },
    );
  }
}

class FilterByBranch extends StatelessWidget {
  const FilterByBranch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
      buildWhen: (p, c) =>
          p.selectedOrganization != c.selectedOrganization ||
          p.branchList != c.branchList ||
          p.selectedBranch != c.selectedBranch,
      builder: (context, state) {
        return (state.selectedOrganization?.id != null &&
                state.branchList != null &&
                state.branchList!.isNotEmpty)
            ? DropdownMenuButtonFuction(
                title: 'branch'.tr(),
                bottomWidget: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.faceRegisteredListBloc.add(
                          ChangeBranchOfficeEvent(model: BranchOfficeModel()));
                      context.faceRegisteredListBloc
                          .add(ChangeDepartmentEvent(model: DepartmentModel()));
                      context.faceRegisteredListBloc
                          .add(ChangeTeamEvent(model: TeamModel()));
                    },
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: COLOR_CONST.lineGrey.withOpacity(0.4))),
                        color: COLOR_CONST.lineGrey.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        'Lọc trong toàn bộ tổ chức',
                        style: FONT_CONST.regular(),
                        maxLines: null,
                      )),
                    )),
                isFullwidthDropBox: false,
                marginTop: 0,
                datas: (state.branchList ?? [])
                    .map((item) => ItemData(
                          index: item.id ?? 0,
                          title: item.name ?? '',
                          object: item,
                        ))
                    .toList(),
                itemInit: ItemData(
                  index: state.selectedBranch?.id ?? 0,
                  title:
                      state.selectedBranch?.name ?? "Lọc trong toàn bộ tổ chức",
                  object: state.selectedBranch,
                ),
                onClickIcon: (p0) {},
                onSelectionItem: (p0) {
                  if (p0.object.id != state.selectedBranch?.id) {
                    context.faceRegisteredListBloc
                        .add(ChangeBranchOfficeEvent(model: p0.object));
                    context.faceRegisteredListBloc
                        .add(ChangeDepartmentEvent(model: DepartmentModel()));
                  }
                },
              )
            // CustomDropdownButton(
            //     marginTop: 0,
            //     colorBorderFocused: COLOR_CONST.cloudBurst,
            //     title: 'branch'.tr(),
            //     datas: (state.branchList ?? [])
            //         .map((e) => DropdownMenuItem<BranchOfficeModel>(
            //               value: e,
            //               child: Text(
            //                 e.name ?? '',
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: FONT_CONST.regular(),
            //               ),
            //             ))
            //         .toList(),
            //     selectedDefault: state.selectedBranch?.id != null
            //         ? state.selectedBranch
            //         : null,
            //     onSelectionChanged: (p0) {
            //       if (p0?.id != state.selectedBranch?.id) {
            //         context.bonusDisciplineBloc
            //             .add(ChangeBranchOfficeEvent(model: p0));
            //         context.bonusDisciplineBloc.add(
            //             ChangeDepartmentEvent(
            //                 model: DepartmentModel()));
            //       }
            //     },
            //   )
            : const SizedBox.shrink();
      },
    );
  }
}

class FilterByTeam extends StatelessWidget {
  const FilterByTeam({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
      buildWhen: (p, c) =>
          p.selectedDepartment != c.selectedDepartment ||
          p.teamList != c.teamList ||
          p.selectedTeam != c.selectedTeam,
      builder: (context, state) {
        return (state.selectedDepartment?.id != null &&
                state.teamList != null &&
                state.teamList!.isNotEmpty)
            ? DropdownMenuButtonFuction(
                title: 'team'.tr(),
                bottomWidget: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.faceRegisteredListBloc
                          .add(ChangeTeamEvent(model: TeamModel()));
                    },
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: COLOR_CONST.lineGrey.withOpacity(0.4))),
                        color: COLOR_CONST.lineGrey.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        'Lọc trong toàn bộ phòng ban',
                        style: FONT_CONST.regular(),
                        maxLines: null,
                      )),
                    )),
                isFullwidthDropBox: false,
                marginTop: 0,
                datas: (state.teamList ?? [])
                    .map((item) => ItemData(
                          index: item.id ?? 0,
                          title: item.name ?? '',
                          object: item,
                        ))
                    .toList(),
                itemInit: ItemData(
                  index: state.selectedTeam?.id ?? 0,
                  title:
                      state.selectedTeam?.name ?? "Lọc trong toàn bộ phòng ban",
                  object: state.selectedTeam,
                ),
                onClickIcon: (p0) {},
                onSelectionItem: (p0) {
                  context.faceRegisteredListBloc
                      .add(ChangeTeamEvent(model: p0.object));
                },
              )
            // CustomDropdownButton(
            //     marginTop: 0,
            //     colorBorderFocused: COLOR_CONST.cloudBurst,
            //     title: 'team'.tr(),
            //     datas: (state.teamList ?? [])
            //         .map((e) => DropdownMenuItem<TeamModel>(
            //               value: e,
            //               child: Text(
            //                 e.name ?? '',
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: FONT_CONST.regular(),
            //               ),
            //             ))
            //         .toList(),
            //     selectedDefault: state.selectedTeam?.id != null
            //         ? state.selectedTeam
            //         : null,
            //     onSelectionChanged: (p0) {
            //       context.bonusDisciplineBloc
            //           .add(ChangeTeamEvent(model: p0));
            //     },
            //   )
            : const SizedBox.shrink();
      },
    );
  }
}

class FilterByDepartment extends StatelessWidget {
  const FilterByDepartment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaceRegisteredListBloc, FaceRegisteredListState>(
      buildWhen: (p, c) =>
          p.selectedBranch != c.selectedBranch ||
          p.departmentList != c.departmentList ||
          p.selectedDepartment != c.selectedDepartment,
      builder: (context, state) {
        return (state.selectedBranch?.id != null &&
                state.departmentList != null &&
                state.departmentList!.isNotEmpty)
            ? DropdownMenuButtonFuction(
                title: 'department'.tr(),
                bottomWidget: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.faceRegisteredListBloc
                          .add(ChangeDepartmentEvent(model: DepartmentModel()));
                      context.faceRegisteredListBloc
                          .add(ChangeTeamEvent(model: TeamModel()));
                    },
                    child: Container(
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: COLOR_CONST.lineGrey.withOpacity(0.4))),
                        color: COLOR_CONST.lineGrey.withOpacity(0.3),
                      ),
                      child: Center(
                          child: Text(
                        'Lọc trong toàn bộ chi nhánh',
                        style: FONT_CONST.regular(),
                        maxLines: null,
                      )),
                    )),
                isFullwidthDropBox: false,
                marginTop: 0,
                datas: (state.departmentList ?? [])
                    .map((item) => ItemData(
                          index: item.id ?? 0,
                          title: item.name ?? '',
                          object: item,
                        ))
                    .toList(),
                itemInit: ItemData(
                  index: state.selectedDepartment?.id ?? 0,
                  title: state.selectedDepartment?.name ??
                      "Lọc trong toàn bộ chi nhánh",
                  object: state.selectedDepartment,
                ),
                onClickIcon: (p0) {},
                onSelectionItem: (p0) {
                  if (p0.object.id != state.selectedDepartment?.id) {
                    context.faceRegisteredListBloc
                        .add(ChangeDepartmentEvent(model: p0.object));
                    context.faceRegisteredListBloc
                        .add(ChangeTeamEvent(model: TeamModel()));
                  }
                },
              )
            // CustomDropdownButton(
            //     marginTop: 0,
            //     colorBorderFocused: COLOR_CONST.cloudBurst,
            //     title: 'department'.tr(),
            //     datas: (state.departmentList ?? [])
            //         .map((e) => DropdownMenuItem<DepartmentModel>(
            //               value: e,
            //               child: Text(
            //                 e.name ?? '',
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: FONT_CONST.regular(),
            //               ),
            //             ))
            //         .toList(),
            //     selectedDefault: state.selectedDepartment?.id != null
            //         ? state.selectedDepartment
            //         : null,
            //     onSelectionChanged: (p0) {
            //       if (p0?.id != state.selectedDepartment?.id) {
            //         context.bonusDisciplineBloc
            //             .add(ChangeDepartmentEvent(model: p0));
            //         context.bonusDisciplineBloc
            //             .add(ChangeTeamEvent(model: TeamModel()));
            //       }
            //     },
            //   )

            : const SizedBox.shrink();
      },
    );
  }
}
