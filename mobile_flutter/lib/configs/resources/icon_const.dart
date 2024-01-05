enum ICON_CONST {
  icHome,
  icMenu,
  icCalendar1,
  icFilter,
  icFilter1,
  icSetting,
  icEyeHidden,
  icEyeShow,
  icCheckAccept,
  icPayroll,
  icCalendar,
  icTicket,
  icManage,
  icHomeActivate,
  icMeetingRoom,
  icAccount,
  icNotification,
  icNotificationActivate,
  icSuccess,
  icFailure,
  icColorBoard,
  icClose,
  icEdit,
  icMoreVertical,
  icTimeSquare,
  icLink,
  icProfileAccount,
  icLogout,
  icSupport,
  icDeleteAccount,
  icNotificationPermission,
  icArrowNext,
  icUserAndPermission,
  icCategorySetting,
  icReport,
  icDelete,
  icSelectAvatar,
  icArrowOpen,
  icArrowClose,
  icChange,
  icSearch,

  icLanguage,
}

// ignore: camel_case_extensions
extension ICON_CONST_VALUE on ICON_CONST {
  String get path {
    switch (this) {
      case ICON_CONST.icHome:
        return 'assets/icons/ic_home.svg';
      case ICON_CONST.icFilter:
        return 'assets/icons/ic_filter.svg';
      case ICON_CONST.icCalendar1:
        return 'assets/icons/ic_calendar1.png';
      case ICON_CONST.icFilter1:
        return 'assets/icons/ic_filter.png';
      case ICON_CONST.icSetting:
        return 'assets/icons/ic_setting.svg';
      case ICON_CONST.icEyeHidden:
        return 'assets/icons/ic_eye_hidden.svg';
      case ICON_CONST.icEyeShow:
        return 'assets/icons/ic_eye_show.svg';
      case ICON_CONST.icCheckAccept:
        return 'assets/icons/ic_check_accept.svg';
      case ICON_CONST.icMenu:
        return 'assets/icons/ic_menu.svg';
      case ICON_CONST.icPayroll:
        return 'assets/icons/ic_payroll.png';
      case ICON_CONST.icCalendar:
        return 'assets/icons/ic_calendar.png';
      case ICON_CONST.icTicket:
        return 'assets/icons/ic_ticket.png';
      case ICON_CONST.icManage:
        return 'assets/icons/ic_manage.png';
      case ICON_CONST.icHomeActivate:
        return 'assets/icons/ic_home_activate.svg';
      case ICON_CONST.icMeetingRoom:
        return 'assets/icons/ic_meeting_room.svg';
      case ICON_CONST.icAccount:
        return 'assets/icons/ic_account.svg';
      case ICON_CONST.icNotification:
        return 'assets/icons/ic_notification.svg';
      case ICON_CONST.icNotificationActivate:
        return 'assets/icons/ic_notification_activate.svg';
      case ICON_CONST.icSuccess:
        return 'assets/icons/ic_success.svg';
      case ICON_CONST.icFailure:
        return 'assets/icons/ic_failure.svg';

      case ICON_CONST.icColorBoard:
        return 'assets/icons/ic_color_board.svg';
      case ICON_CONST.icClose:
        return 'assets/icons/ic_close.svg';
      case ICON_CONST.icEdit:
        return 'assets/icons/ic_edit.png';
      case ICON_CONST.icMoreVertical:
        return 'assets/icons/ic_more_vertical.svg';
      case ICON_CONST.icTimeSquare:
        return 'assets/icons/ic_time_square.svg';
      case ICON_CONST.icLink:
        return 'assets/icons/ic_link.svg';
      case ICON_CONST.icProfileAccount:
        return 'assets/icons/ic_profile_account.svg';
      case ICON_CONST.icLogout:
        return 'assets/icons/ic_logout.svg';
      case ICON_CONST.icSupport:
        return 'assets/icons/ic_support.svg';
      case ICON_CONST.icDeleteAccount:
        return 'assets/icons/ic_delete_account.svg';
      case ICON_CONST.icNotificationPermission:
        return 'assets/icons/ic_notification_permission.svg';
      case ICON_CONST.icArrowNext:
        return 'assets/icons/ic_arrow_next.svg';
      case ICON_CONST.icUserAndPermission:
        return 'assets/icons/ic_user_and_permission.svg';
      case ICON_CONST.icCategorySetting:
        return 'assets/icons/ic_classification_setting.svg';
      case ICON_CONST.icReport:
        return 'assets/icons/ic_report.svg';
      case ICON_CONST.icDelete:
        return 'assets/icons/ic_delete.png';
      case ICON_CONST.icSelectAvatar:
        return 'assets/icons/ic_select_avatar.svg';
      case ICON_CONST.icArrowOpen:
        return 'assets/icons/ic_arrow_open.svg';
      case ICON_CONST.icArrowClose:
        return 'assets/icons/ic_arrow_close.svg';
      case ICON_CONST.icChange:
        return 'assets/icons/ic_change.svg';
      case ICON_CONST.icSearch:
        return 'assets/icons/ic_search.svg';

      case ICON_CONST.icLanguage:
        return 'assets/icons/ic_language.svg';
      default:
        return '';
    }
  }
}
