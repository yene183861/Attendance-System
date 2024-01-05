enum HTTPRequestMethods { get, post, put, patch, delete }

enum ApiURL {
  login,
  logOut,
  deletedUser,

  getOrganization,
  createOrganizaion,
  updateOrganization,
  deleteOrganization,

  getBranchOffice,
  getDepartment,
  getTeam,

  getAllowance,
  getWorkingTimeType,
  getWorkingTimeSetting,
  getContractType,
  getContract,

  createUser,
  getUsersWork,
  getUserWorks,
  registerFace,
  getFace,
  searchUser,
  getBonus,
  getRating,

  getTicketReasons,
  getTicket,

  attendanceFace,
  getAttendance,
  forgotPassword,
  changePassword,
  updateProfile,

  getListCountry,
  getListProvince,
  getUserProfile,
  checkPhoneNumberSignUp,
  register,

  validateOtp,
  sendLinkResetPass,
  resetPassword,
  activationUser,
  getBooking,
  booking,
  updateBooking,
  deleteBooking,
  getCategory,
  getDetailCategory,
  addNewCategory,
  updateCategory,
  deleteCategory,
  getMeetingRoom,
  addMeetingRoom,
  updateMeetingRoom,
  deleteMeetingRoom,

  getUserOrganization,
  deleteUserOrganization,
  addUserOrganization,
  updateUserOrganization,
  registerFcmDevice,
  getTotalNewMessage,
  getListNotification,
  postSupport,
  getAnalyticOverview,
  getStatistics,
  markSeenAllNotification,
  deleteAllNotification,
  updateStatusPushNotification,
  deleteAccount,
}

// Handle this case.
extension ApiURLState on ApiURL {
  String get path {
    switch (this) {
      case ApiURL.login:
        return '/auth/login/';
      case ApiURL.logOut:
        return '/auth/logout/';
      case ApiURL.deletedUser:
        return '/user/delete/';

      case ApiURL.getOrganization:
      case ApiURL.deleteOrganization:
        return '/organization/';
      case ApiURL.createOrganizaion:
        return '/organization/create/';

      case ApiURL.getBranchOffice:
        return '/branch-office/';

      case ApiURL.getDepartment:
        return '/department/';

      case ApiURL.getTeam:
        return '/team/';

      case ApiURL.getWorkingTimeType:
        return '/working-time-type/';

      case ApiURL.getAllowance:
        return '/allowance/';
      case ApiURL.getWorkingTimeSetting:
        return '/working-time-setting/';
      case ApiURL.getContractType:
        return '/contract-type/';
      case ApiURL.getContract:
        return '/contract/';
      case ApiURL.getBonus:
        return '/reward-and-discipline/';
      case ApiURL.getRating:
        return '/personnel-evaluation/';
      case ApiURL.attendanceFace:
        return '/attendance/face/create/';

      case ApiURL.createUser:
        return '/create-user/';
      case ApiURL.getUsersWork:
        return '/user-work/';
      case ApiURL.getUserWorks:
        return '/user-work/';
      case ApiURL.registerFace:
        return '/register-face/create/';
      case ApiURL.getFace:
        return '/register-face/';
      case ApiURL.searchUser:
        return '/search/staff/';

      case ApiURL.getTicketReasons:
        return '/ticket-reason/';
      case ApiURL.getTicket:
        return '/ticket/';

      case ApiURL.getAttendance:
        return '/attendance/';
      case ApiURL.forgotPassword:
        return '/auth/reset-password/';
      case ApiURL.changePassword:
        return '/change-password/';
      case ApiURL.updateProfile:
        return '/update-profile/';

      case ApiURL.getListCountry:
        return '/general/v1/country/';
      case ApiURL.getListProvince:
        return '/general/v1/country/province/';
      case ApiURL.getUserProfile:
        return '/account/v1/account/';
      case ApiURL.checkPhoneNumberSignUp:
        return '/auth/v1/register/check-phone-number/';
      case ApiURL.register:
        return '/auth/v1/register/';
      case ApiURL.validateOtp:
        return '/auth/v1/forgot-password/validate-otp/';

      case ApiURL.sendLinkResetPass:
        return '/account/v1/account/send-link-reset-password/';
      case ApiURL.resetPassword:
        return '/account/v1/account/reset-password/';
      case ApiURL.activationUser:
        return '/account/v1/account/activation-user/';

      case ApiURL.getBranchOffice:
        return '/branch-office/v1/';
      case ApiURL.getUserOrganization:
        return '/user-organization/v1/';
      case ApiURL.deleteUserOrganization:
        return '/user-organization/v1/';
      case ApiURL.addUserOrganization:
        return '/user-organization/v1/';
      case ApiURL.updateUserOrganization:
        return '/user-organization/v1/';
      case ApiURL.registerFcmDevice:
        return '/fcm/v1/';
      case ApiURL.getTotalNewMessage:
        return '/notification/v1/total-new-message/';
      case ApiURL.getListNotification:
        return '/notification/v1/';
      case ApiURL.postSupport:
        return '/customer-support/v1/';
      case ApiURL.getAnalyticOverview:
        return '/overview-analytics-admin/v1/overview/';
      case ApiURL.getStatistics:
        return '/statistics-manager-admin/v1/time-booking/';
      case ApiURL.markSeenAllNotification:
        return '/notification/v1/mark-seen-all/';
      case ApiURL.deleteAllNotification:
        return '/notification/v1/delete-all-message/';
      case ApiURL.updateStatusPushNotification:
        return '/fcm/v1/unregister/';
      case ApiURL.deleteAccount:
        return '/account/v1/account/delete_user/';
      default:
        return 'undefine';
    }
  }

  HTTPRequestMethods? get methods {
    switch (this) {
      //- API Using Get Method

      case ApiURL.getOrganization:
      case ApiURL.getBranchOffice:
      case ApiURL.getDepartment:
      case ApiURL.getTeam:
      case ApiURL.getAllowance:
      case ApiURL.getWorkingTimeType:
      case ApiURL.getWorkingTimeSetting:
      case ApiURL.getContractType:
      case ApiURL.getContract:
      case ApiURL.getUsersWork:
      case ApiURL.getUserWorks:
      case ApiURL.searchUser:
      case ApiURL.getTicketReasons:
      case ApiURL.getTicket:
      case ApiURL.getBonus:
      case ApiURL.getRating:
      case ApiURL.getAttendance:
      case ApiURL.getFace:

      //
      case ApiURL.getListCountry:
      case ApiURL.getListProvince:
      case ApiURL.getUserProfile:
      case ApiURL.checkPhoneNumberSignUp:
      case ApiURL.getBooking:
      case ApiURL.getCategory:
      case ApiURL.getDetailCategory:
      case ApiURL.getMeetingRoom:
      case ApiURL.getUserOrganization:
      case ApiURL.getTotalNewMessage:
      case ApiURL.getListNotification:
      case ApiURL.getAnalyticOverview:
      case ApiURL.getStatistics:
        return HTTPRequestMethods.get;

      //- API Using Post Method
      case ApiURL.login:
      case ApiURL.logOut:
      case ApiURL.createOrganizaion:
      case ApiURL.createUser:
      case ApiURL.registerFace:
      case ApiURL.attendanceFace:
      case ApiURL.forgotPassword:
      case ApiURL.changePassword:
      case ApiURL.updateProfile:
      //
      case ApiURL.register:
      case ApiURL.validateOtp:
      case ApiURL.sendLinkResetPass:
      case ApiURL.activationUser:
      case ApiURL.addNewCategory:
      case ApiURL.addUserOrganization:
      case ApiURL.addMeetingRoom:
      case ApiURL.booking:
      case ApiURL.registerFcmDevice:
      case ApiURL.postSupport:
      case ApiURL.markSeenAllNotification:
      case ApiURL.updateStatusPushNotification:
        return HTTPRequestMethods.post;

      // - API Using patch Method
      case ApiURL.updateOrganization:
      //
      case ApiURL.resetPassword:
      case ApiURL.updateCategory:
      case ApiURL.updateMeetingRoom:
      case ApiURL.updateBooking:
      case ApiURL.updateUserOrganization:
        return HTTPRequestMethods.patch;

      case ApiURL.deleteOrganization:
      case ApiURL.deletedUser:
      //
      case ApiURL.deleteUserOrganization:
      case ApiURL.deleteCategory:
      case ApiURL.deleteBooking:
      case ApiURL.deleteMeetingRoom:
      case ApiURL.deleteAllNotification:
      case ApiURL.deleteAccount:
        return HTTPRequestMethods.delete;
      default:
        return null;
    }
  }
}
