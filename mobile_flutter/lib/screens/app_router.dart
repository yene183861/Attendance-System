import 'package:firefly/data/arguments/transfer_staff_argument.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/screens/attendance_screen_group/attendance_face_screen/attendance_face_screen.dart';
import 'package:firefly/screens/attendance_screen_group/yourself_attendance_sheet/yourself_attendance_sheet_screen.dart';
import 'package:firefly/screens/change_profile_group/change_password_screen/change_password_screen.dart';
import 'package:firefly/screens/change_profile_group/update_profile_screen/update_profile_screen.dart';
import 'package:firefly/screens/face_screen_group/face_registered_list_screen/face_registered_list_screen.dart';
import 'package:firefly/screens/manage_staff_group/transfer_staff_screen/transfer_staff_screen.dart';
import 'package:firefly/screens/payroll_screen/payroll_screen.dart';
import 'package:firefly/screens/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:firefly/data/arguments/create_user_arguments.dart';
import 'package:firefly/data/arguments/edit_allowance_arguments.dart';
import 'package:firefly/data/arguments/edit_bonus_param.dart';
import 'package:firefly/data/arguments/edit_branch_argument.dart';
import 'package:firefly/data/arguments/edit_ticket_reason_arguments.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/screens/allowance_screen_group/allowance_screen/allowance_screen.dart';
import 'package:firefly/screens/allowance_screen_group/edit_allowance_screen/edit_allowance_screen.dart';
import 'package:firefly/screens/manage_staff_group/add_new_user_screen/add_new_user_screen.dart';
import 'package:firefly/screens/dashboard_screen/dashboard_screen.dart';
import 'package:firefly/screens/manage_staff_group/manage_staff_screen/manage_staff_screen.dart';
import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/branch_office_screen/branch_office_screen.dart';
import 'package:firefly/screens/organization_structure_group_screen/branch_office_screen_group/edit_branch_screen/edit_branch_screen.dart';
import 'package:firefly/screens/organization_structure_group_screen/department_screen/department_screen.dart';
import 'package:firefly/screens/organization_structure_group_screen/organization_screen_group/edit_organization_screen/edit_organization_screen.dart';
import 'package:firefly/screens/organization_structure_group_screen/team_screen/team_screen.dart';
import 'package:firefly/screens/ticket_group_screen/detail_ticket_screen/detail_ticket_screen.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/edit_ticket_screen.dart';
import 'package:firefly/screens/scan_face_screen/scan_face_screen.dart';
import 'package:firefly/screens/ticket_group_screen/ticket_screen/ticket_screen.dart';

import '../data/arguments/edit_contract_argument.dart';
import 'auth_group_screen/login_screen/login_screen.dart';
import 'bonus_discipline_screen_group/bonus_discripline_screen/bonus_discipline_screen.dart';
import 'bonus_discipline_screen_group/edit_bonus_discipline_screen/edit_bonus_discipline_screen.dart';
import 'contract_screen_group/contract_screen/contract_screen.dart';
import 'contract_screen_group/edit_contract_screen/edit_contract_screen.dart';
import 'auth_group_screen/forgot_password_screen/forgot_password_screen.dart';
import 'organization_structure_group_screen/organization_screen_group/organization_management_screen/organization_screen.dart';
import 'ticket_group_screen/edit_ticket_reason_screen/edit_ticket_reason_screen.dart';
import 'ticket_group_screen/ticket_reason_screen/ticket_reason_screen.dart';

class AppRouter {
  static const String SPLASH_SCREEN = 'splash_screen';
  static const String INTRODUCTION_SCREEN = 'instroduction_screen';
  static const String ATTENDANCE_SHEET_SCREEN = 'attendance_sheet_screen';
  static const String PAYROLL_SCREEN = 'payroll_screen';

  static const String LOGIN_SCREEN = 'login_screen';

  static const String ORGANIZATION_SCREEN = 'organization_screen';
  static const String EDIT_ORGANIZATION_SCREEN = 'edit_organization_screen';

  static const String BRANCH_OFFICE_SCREEN = 'branch_office_screen';
  static const String EDIT_BRANCH_OFFICE_SCREEN = 'edit_branch_office_screen';

  static const String DEPARTMENT_SCREEN = 'department_screen';
  static const String TEAM_SCREEN = 'team_screen';

  static const String CONTRACT_SCREEN = 'contract_creen';
  static const String EDIT_CONTRACT_SCREEN = 'edit_contract_creen';
  static const String ALLOWANCE_SCREEN = 'allowance_screen';
  static const String EDIT_ALLOWANCE_SCREEN = 'edit_allowance_screen';

  static const String MANAGE_STAFF_SCREEN = 'manage_staff_screen';
  static const String ADD_NEW_USER_SCREEN = 'add_new_user_screen';
  static const String TRANSFER_STAFF_SCREEN = 'transfer_staff_screen';

  static const String TICKET_REASON_SCREEN = 'ticket_reason_screen';
  static const String EDIT_TICKET_REASON_SCREEN = 'edit_ticket_reason_screen';

  static const String TICKET_SCREEN = 'ticket_screen';
  static const String EDIT_TICKET_SCREEN = 'edit_ticket_screen';

  static const String FORGOT_PASSWORD_SCREEN = 'forgot_password_screen';
  static const String CHANGE_PASSWORD_SCREEN = 'change_password_screen';
  static const String SETTINGS_SCREEN = 'setting_screen';
  static const String UPDATE_PROFILE_SCREEN = 'update_profile_screen';

  static const String SEND_LINK_RESET_PASS_SCREEN =
      'send_link_reset_pass_screen';
  static const String ACTIVATION_USER_SCREEN = 'activation_user_screen';
  static const String RESET_PASS_SCREEN = 'reset_pass_screen';
  static const String DASHBOARD_SCREEN = 'dashboard_screen';
  static const String HOME_SCREEN = 'home_screen';
  static const String USER_AND_PERMISSION_SCREEN = 'user_and_permission_screen';
  static const String BOOKING_SCREEN = 'booking_screen';

  static const String CATEGORY_SETTING_SCREEN = 'category_setting_screen';
  static const String ADD_USER_ORGANIZATION_SCREEN =
      'add_user_organization_screen';
  static const String EDIT_ROOM_SCREEN = 'edit_room_screen';
  static const String UPDATE_USER_ORGANIZATION_SCREEN =
      'update_user_organization_screen';
  static const String SUPPORT_SCREEN = 'support_screen';
  static const String REPORT_SCREEN = 'report_screen';
  static const String CHANGE_LANGUAGE_SCREEN = 'change_language_screen';
  static const String DETAIL_TICKET_SCREEN = 'detail_ticket_screen';
  static const String DETAIL_LEAVE_SCREEN = 'detail_leave_screen';
  static const String SCAN_FACE_SCREEN = 'scan_face_screen';
  static const String FACE_REGISTERED_LIST_SCREEN =
      'face_registered_list _screen';
  static const String ATTENDANCE_FACE_SCREEN = 'attendance_face _screen';

  static const String BONUS_DISCRIPLINE_SCREEN = 'bonus_discripline_screen';
  static const String EDIT_BONUS_DISCRIPLINE_SCREEN =
      'edit_bonus_discripline_screen';

  // Generate Router
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case INTRODUCTION_SCREEN:
      //   return MaterialPageRoute(builder: (_) => IntroductionScreen());
      case DASHBOARD_SCREEN:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case ATTENDANCE_SHEET_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const YourselfAttendanceSheetScreen());
      case PAYROLL_SCREEN:
        return MaterialPageRoute(builder: (_) => const PayrollScreen());
      case LOGIN_SCREEN:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case FORGOT_PASSWORD_SCREEN:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case ORGANIZATION_SCREEN:
        return MaterialPageRoute(builder: (_) => const OrganizationScreen());
      case EDIT_ORGANIZATION_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditOrganizationScreen(
                organizationModel: settings.arguments as OrganizationModel?));
      case BRANCH_OFFICE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => BranchOfficeScreen(
                  organizationId: settings.arguments as int,
                ));
      case EDIT_BRANCH_OFFICE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditBranchScreen(
                editBranchArgument: settings.arguments as EditBranchArgument));
      case CONTRACT_SCREEN:
        return MaterialPageRoute(
            builder: (_) => ContractScreen(
                  isOpenFromDashboard: settings.arguments as bool?,
                ));
      case EDIT_CONTRACT_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditContractScreen(
                  arg: settings.arguments as EditContractArgument?,
                ));
      case ALLOWANCE_SCREEN:
        return MaterialPageRoute(builder: (_) => const AllowanceScreen());
      case EDIT_ALLOWANCE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditAllowanceScreen(
                arg: settings.arguments as EditAllowanceArgument));

      case BONUS_DISCRIPLINE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const BonusDiscriplineScreen());
      case EDIT_BONUS_DISCRIPLINE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditBonusDiscriplineScreen(
                  arg: settings.arguments as EditBonusArgument,
                ));

      case DEPARTMENT_SCREEN:
        return MaterialPageRoute(
            builder: (_) => DepartmentScreen(
                  branchId: settings.arguments as int,
                ));
      case TEAM_SCREEN:
        return MaterialPageRoute(
            builder: (_) => TeamScreen(
                  departmentId: settings.arguments as int,
                ));
      case MANAGE_STAFF_SCREEN:
        return MaterialPageRoute(builder: (_) => const ManageStaffScreen());
      case ADD_NEW_USER_SCREEN:
        return MaterialPageRoute(
            builder: (_) => AddNewUserScreen(
                  createUserArgument: settings.arguments as CreateUserArgument,
                ));
      case TRANSFER_STAFF_SCREEN:
        return MaterialPageRoute(
            builder: (_) => TransferStaffScreen(
                  arg: settings.arguments as TransferStaffArgument,
                ));
      //ticket reason
      case TICKET_REASON_SCREEN:
        return MaterialPageRoute(builder: (_) => const TicketReasonScreen());
      case EDIT_TICKET_REASON_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditTicketReasonScreen(
                  editTicketReasonArgument:
                      settings.arguments as EditTicketReasonArgument,
                ));

      //ticket
      case TICKET_SCREEN:
        return MaterialPageRoute(builder: (_) => const TicketScreen());
      case EDIT_TICKET_SCREEN:
        return MaterialPageRoute(
            builder: (_) => EditTicketScreen(
                  ticket: settings.arguments as TicketModel?,
                ));
      case DETAIL_TICKET_SCREEN:
        return MaterialPageRoute(
            builder: (_) =>
                DetailTicketScreen(ticket: settings.arguments as TicketModel));

      case SCAN_FACE_SCREEN:
        return MaterialPageRoute(
            builder: (_) => ScanFaceScreen(
                  user: settings.arguments as UserModel?,
                ));
      case FACE_REGISTERED_LIST_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const FaceRegisteredListScreen());
      case ATTENDANCE_FACE_SCREEN:
        return MaterialPageRoute(builder: (_) => const AttendanceFaceScreen());
      case CHANGE_PASSWORD_SCREEN:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case SETTINGS_SCREEN:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case UPDATE_PROFILE_SCREEN:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
