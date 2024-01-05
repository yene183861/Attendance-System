import 'package:firefly/screens/attendance_screen_group/yourself_attendance_sheet/yourself_attendance_sheet_screen.dart';
import 'package:firefly/screens/payroll_screen/payroll_screen.dart';
import 'package:flutter/material.dart';
import 'package:firefly/screens/management_screen/management_screen.dart';
import 'package:firefly/screens/setting_screen/setting_screen.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/ticket_screen.dart';

enum BottomBarItemType {
  // home,
  attendance_sheet,
  ticket,
  payroll,
  manage,
  setting,
}

extension BottomBarItemTypeX on BottomBarItemType {
  // ignore: missing_return
  Widget get widget {
    switch (this) {
      // case BottomBarItemType.home:
      //   return const HomeScreen();
      case BottomBarItemType.attendance_sheet:
        return const YourselfAttendanceSheetScreen();
      case BottomBarItemType.ticket:
        return const TicketScreen();
      case BottomBarItemType.payroll:
        return const PayrollScreen();
      case BottomBarItemType.manage:
        return const ManagementScreen();
      case BottomBarItemType.setting:
        return const SettingScreen();
    }
  }
}
