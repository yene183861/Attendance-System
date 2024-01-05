import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../configs/resources/barrel_const.dart';
import '../../custom_widget/default_padding.dart';
import 'components/allowance_bonus_group.dart';
import 'components/attendance_management_group.dart';
import 'components/org_structure_group.dart';
import 'components/staff_management_group.dart';
import 'components/ticket_management_group.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementScreenBody();
  }
}

class ManagementScreenBody extends StatelessWidget {
  const ManagementScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: defaultPadding(),
            child: Text(
              'title_work'.tr(),
              style: FONT_CONST.semoBold(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          ),
          const OrganizationStructureGroup(),
          const AttendaceManagementCroup(),
          const TicketManagementGroup(),
          const StaffManagementGroup(),
          const AllowanceBonusGroup(),
        ],
      ),
    );
  }
}
