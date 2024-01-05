import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/team_model.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class TeamRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<TeamModel>?> getTeams(
      {Options? options, required int departmentId}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getTeam,
        options: options,
        params: {
          'department_id': departmentId,
        },
      );

      return BaseListResponse.fromJson(JSON(response), TeamModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TeamModel>?> addTeam({required TeamModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getTeam.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TeamModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TeamModel>?> updateTeam(
      {required TeamModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/team/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TeamModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TeamModel>?> getDetailBranch({required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getTeam,
        customURL: '/team/$id/',
      );
      return BaseResponse.fromJson(JSON(response), TeamModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteTeam({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/team/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
