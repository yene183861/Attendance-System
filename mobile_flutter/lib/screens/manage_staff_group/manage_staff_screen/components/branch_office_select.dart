import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_menu_function.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/bloc/manage_staff_bloc.dart';

class BranchOfficeSelect extends StatelessWidget {
  const BranchOfficeSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageStaffBloc, ManageStaffState>(
      buildWhen: (p, c) =>
          p.branchesList != c.branchesList ||
          p.selectedBranch != c.selectedBranch,
      builder: (context, state) {
        return CustomDropdownMenuFunction(
          title: 'branch'.tr(),
          titleButton: 'see all'.tr(),
          bottomWidget: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                context.manageStaffBloc.add(ChangeBranchOfficeEvent());
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
                  'Xem toàn bộ',
                  style: FONT_CONST.regular(),
                )),
              )),
          isFullwidthDropBox: false,
          marginTop: 0,
          datas: (state.branchesList ?? [])
              .map((item) => ItemData(
                    index: item.id ?? 0,
                    title: item.name ?? '',
                    object: item,
                  ))
              .toList(),
          itemInit: ItemData(
            index: state.selectedBranch?.id ?? 0,
            title: state.selectedBranch?.name ?? "",
            object: state.selectedBranch,
          ),
          onClickIcon: (p0) {
            // updateOrg(org: p0.object);
          },
          onSelectionItem: (p0) {
            context.manageStaffBloc
                .add(ChangeBranchOfficeEvent(branchOfficeModel: p0.object));
          },
          onTapButtonBottom: () {},
        );
      },
    );
  }
}
