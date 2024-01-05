import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/size_config.dart';

import '../../../custom_widget/default_padding.dart';
import 'sub_item.dart';
import 'title_group.dart';

class AllowanceBonusGroup extends StatelessWidget {
  const AllowanceBonusGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGroup(
          title: 'title_allowance_bonus_management'.tr(),
        ),
        Padding(
          padding: defaultPadding(),
          child: Row(
            children: [
              SubItem(
                title: 'title_allowance'.tr(),
                icon: const Icon(
                  Icons.receipt_long_outlined,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.ALLOWANCE_SCREEN);
                },
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_bonus_discipline'.tr(),
                icon: const Icon(
                  Icons.pending_actions,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.BONUS_DISCRIPLINE_SCREEN);
                },
              ),
              // const HorizontalSpacing(),
              // SubItem(
              //   bookmark_outline_sharp
              //   title: 'title_violation'.tr(),
              //   icon: const Icon(
              //     Icons.pending_actions,
              //   ),
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
