import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/data/model/organization_model.dart';

class DropdownSelectOrganization extends StatelessWidget {
  const DropdownSelectOrganization(
      {super.key,
      required this.organizations,
      required this.onSelectionChanged,
      this.selectedOrganization});
  final List<OrganizationModel> organizations;
  final Function(dynamic) onSelectionChanged;
  final OrganizationModel? selectedOrganization;

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton(
      marginTop: 0,
      colorBorderFocused: COLOR_CONST.cloudBurst,
      title: 'organization'.tr(),
      datas: organizations
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
      selectedDefault: selectedOrganization,
      onSelectionChanged: onSelectionChanged,
    );
  }
}
