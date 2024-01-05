enum IMAGE_CONST {
  logoApp,
  imgOffice,
  imgDefaultAvatar,
  imgAttendanceTimesheet,
  imgLoadingAvatar
}

// ignore: camel_case_extensions
extension IMAGE_CONST_VALUE on IMAGE_CONST {
  String get path {
    switch (this) {
      case IMAGE_CONST.logoApp:
        return 'assets/images/logo_app.png';
      case IMAGE_CONST.imgOffice:
        return 'assets/images/img_office.png';
      case IMAGE_CONST.imgDefaultAvatar:
        return 'assets/images/img_default_avatar.png';
      case IMAGE_CONST.imgAttendanceTimesheet:
        return 'assets/images/img_attendance_timesheet.jpg';
      case IMAGE_CONST.imgLoadingAvatar:
        return 'assets/images/img_loading_avatar.png';
      default:
        return '';
    }
  }
}
