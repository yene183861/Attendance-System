import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/utils/singleton.dart';

import '../../../custom_widget/default_padding.dart';
import '../../app_router.dart';
import 'sub_item.dart';
import 'title_group.dart';

class OrganizationStructureGroup extends StatelessWidget {
  const OrganizationStructureGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGroup(
          title: 'title_organizational_structure'.tr(),
        ),
        Padding(
          padding: defaultPadding(),
          child: SubItem(
            title: 'title_organizational_chart'.tr(),
            icon: const Icon(
              Icons.account_tree_outlined,
            ),
            onTap: () {
              final userType = Singleton.instance.userType;
              if (userType == UserType.ADMIN) {
                Navigator.of(context).pushNamed(AppRouter.ORGANIZATION_SCREEN);
              } else {
                Navigator.of(context).pushNamed(AppRouter.BRANCH_OFFICE_SCREEN,
                    arguments: Singleton.instance.userWork!.organization!.id!);
              }
            },
          ),
        ),
      ],
    );
  }
}
