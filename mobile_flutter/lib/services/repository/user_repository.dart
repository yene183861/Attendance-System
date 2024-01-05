import 'package:dio/dio.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/data/request_param/update_profile_param.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_model/create_user_param.dart';
import 'package:firefly/data/request_param/get_user_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';
import 'package:firefly/data/response_model/create_user_response_model.dart';

import '../api/barrel_api.dart';

class UserRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<UserWorkModel>?> getUsersWork(
      {Options? options, required GetUserParam? getUserParam}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getUsersWork,
          options: options, params: getUserParam?.toJson());

      return BaseListResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<CreateUserResponseModel>?> createUser(
      {required CreateUserModel model}) async {
    try {
      print('\n');
      print(model.toJson());
      final response = await apiDataStore.requestAPI(
        ApiURL.createUser,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), CreateUserResponseModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<UserModel>?> updateProfile(
      {required UpdateProfileParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateProfile,
        formData: param.toFormData(),
      );
      print(response);
      return BaseResponse.fromJson(JSON(response), UserModel.fromJson);
    } on DioError catch (e) {
      print(e);
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteUser({required int id}) async {
    try {
      await apiDataStore.requestAPI(
        ApiURL.deletedUser,
        customURL: '/user/delete/$id',
      );
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  // Future<void> deleteAllowance({required int id}) async {
  //   try {
  //     await apiDataStore.requestAPI(ApiURL.deleteOrganization,
  //         customURL: '/allowance/$id/');
  //     return;
  //   } on DioError catch (e) {
  //     throw ErrorFromServer(message: e.message);
  //   }
  // }

  Future<BaseListResponse<UserWorkModel>?> searchUserWorkByEmail(
      {required String email}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.searchUser,
        params: {'email': email},
      );
      return BaseListResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseListResponse<UserWorkModel>?> searchUserWorkByName(
      {required String name}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.searchUser,
        params: {'name': name},
      );
      return BaseListResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
