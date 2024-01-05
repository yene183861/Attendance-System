import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/screens/app_router.dart';

import '../../../custom_widget/default_padding.dart';
import '../../../utils/size_config.dart';
import 'sub_item.dart';
import 'title_group.dart';

class StaffManagementGroup extends StatelessWidget {
  const StaffManagementGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleGroup(
          title: 'title_hrm'.tr(),
        ),
        Padding(
          padding: defaultPadding(),
          child: Row(
            children: [
              SubItem(
                title: 'title_list_staffs'.tr(),
                icon: const Icon(
                  Icons.groups_2,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.MANAGE_STAFF_SCREEN);
                },
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_rate_staff'.tr(),
                icon: const Icon(
                  Icons.groups_2,
                ),
                onTap: () {},
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_list_contracts'.tr(),
                icon: const Icon(
                  Icons.receipt_long_outlined,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.CONTRACT_SCREEN);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
