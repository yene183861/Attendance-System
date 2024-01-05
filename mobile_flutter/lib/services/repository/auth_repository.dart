import 'package:dio/dio.dart';
import 'package:firefly/data/model/attendance_statistics_model.dart';
import 'package:firefly/data/request_param/change_password_param.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:g_json/g_json.dart';

import '../../data/request_param/login_param.dart';
import '../../data/response_model/login_response_model.dart';
import '../api/barrel_api.dart';

class AuthRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<LoginResponseModel?> login(LoginParams loginParams) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.login,
        body: loginParams.toJson(),
      );
      return LoginResponseModel.fromJson(JSON(response['data']));
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  // Future<bool?> checkPhoneNumberSignUp(
  //     PhoneNumberCheckSignUpParam phoneNumberCheckSignUpParam) async {
  //   final response = await apiDataStore.requestAPI(
  //     ApiURL.checkPhoneNumberSignUp,
  //     params: phoneNumberCheckSignUpParam.toJson(),
  //   );
  //   return response["data"];
  // }

  // Future<AuthAccountModel?> register(RegisterParams params) async {
  //   final response = await apiDataStore.requestAPI(
  //     ApiURL.register,
  //     body: params.toJson(),
  //   );
  //   return AuthAccountModel.fromJson(JSON(response['data']));
  // }

  // Future<TokenForgotPassModel?> validateOtpResetPassword(
  //     ValidateOTPForgotPassParams params) async {
  //   final response = await apiDataStore.requestAPI(
  //     ApiURL.validateOtp,
  //     body: params.toJson(),
  //   );
  //   return TokenForgotPassModel.fromJson(JSON(response['data']));
  // }

  Future<BaseResponse<AttendanceStatisticsModel>> resetPassword(
      {required String email}) async {
    final response = await apiDataStore.requestAPI(
      ApiURL.forgotPassword,
      body: {'email': email},
    );
    return BaseResponse.fromJson(
        JSON(response), AttendanceStatisticsModel.fromJson);
  }

  Future<void> changePassword(ChangePasswordParam params) async {
    await apiDataStore.requestAPI(
      ApiURL.changePassword,
      body: params.toJson(),
    );
  }

  Future<bool?> logOutAccount() async {
    final response = await apiDataStore.requestAPI(
      ApiURL.logOut,
    );
    return response['data'];
  }

  Future<bool?> deleteAccount() async {
    final response = await apiDataStore.requestAPI(
      ApiURL.deleteAccount,
    );
    return response['data'];
  }
}
