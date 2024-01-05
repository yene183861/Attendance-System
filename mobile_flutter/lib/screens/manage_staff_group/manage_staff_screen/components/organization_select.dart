import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/bloc/manage_staff_bloc.dart';

class OrganizationSelect extends StatelessWidget {
  const OrganizationSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageStaffBloc, ManageStaffState>(
      buildWhen: (p, c) =>
          p.organizationsList != c.organizationsList ||
          p.selectedOrganization != c.selectedOrganization,
      builder: (context, state) {
        return CustomDropdownButton(
          marginTop: 0,
          colorBorderFocused: COLOR_CONST.cloudBurst,
          title: 'organization'.tr(),
          datas: (state.organizationsList ?? [])
              .map((e) => DropdownMenuItem<OrganizationModel>(
                    value: e,
                    child: Text(
                      e.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FONT_CONST.regular(),
                    ),
                  ))
              .toList(),
          selectedDefault: state.selectedOrganization,
          onSelectionChanged: (p0) {
            context.manageStaffBloc
                .add(ChangeOrganizationEvent(organizationModel: p0));
          },
        );
      },
    );
  }
}
