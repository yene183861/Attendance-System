import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/data/request_param/get_user_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';
import '../api/barrel_api.dart';

class UserWorkRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<UserWorkModel>?> getUserWorks(
      {Options? options, required GetUserParam? getUserParam}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getUserWorks,
          options: options, params: getUserParam?.toJson());

      return BaseListResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<UserWorkModel>?> updateUserWork(
      {required UserWorkModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/user-work/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<UserWorkModel>?> getDetailUserWork(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getUserWorks,
        customURL: '/user-work/$id/',
      );
      return BaseResponse.fromJson(JSON(response), UserWorkModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteUserWork({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/user-work/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

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
