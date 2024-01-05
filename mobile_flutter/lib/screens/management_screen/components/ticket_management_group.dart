import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/screens/app_router.dart';

import '../../../custom_widget/default_padding.dart';
import '../../../utils/size_config.dart';
import 'sub_item.dart';
import 'title_group.dart';

class TicketManagementGroup extends StatelessWidget {
  const TicketManagementGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGroup(
          title: 'title_ticket_management'.tr(),
        ),
        Padding(
          padding: defaultPadding(),
          child: Row(
            children: [
              SubItem(
                title: 'title_list_tickets'.tr(),
                icon: const Icon(
                  Icons.insert_drive_file,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.TICKET_SCREEN, arguments: false);
                },
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_ticket_reason'.tr(),
                icon: const Icon(
                  Icons.note_add_outlined,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.TICKET_REASON_SCREEN);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
