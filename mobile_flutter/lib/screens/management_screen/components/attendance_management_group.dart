import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/show_picker_image.dart';
import 'package:firefly/services/api/error_from_server.dart';
import 'package:firefly/services/repository/face_repository.dart';
// import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:firefly/custom_widget/default_padding.dart';

import '../../../utils/size_config.dart';
import '../../app_router.dart';
import 'sub_item.dart';
import 'title_group.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AttendaceManagementCroup extends StatelessWidget {
  const AttendaceManagementCroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGroup(
          title: 'title_staff_attendance_and_salary_management'.tr(),
        ),
        Padding(
          padding: defaultPadding(),
          child: Row(
            children: [
              SubItem(
                title: 'Quản lý việc\nđăng ký\nchấm công'.tr(),
                icon: const Icon(
                  Icons.perm_contact_calendar_sharp,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.FACE_REGISTERED_LIST_SCREEN);
                },
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_attendance_sheet1'.tr(),
                icon: const Icon(
                  Icons.perm_contact_calendar_sharp,
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.ATTENDANCE_FACE_SCREEN);
                },
              ),
              const HorizontalSpacing(),
              SubItem(
                title: 'title_payroll_sheet'.tr(),
                icon: const Icon(
                  Icons.perm_contact_calendar_sharp,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
