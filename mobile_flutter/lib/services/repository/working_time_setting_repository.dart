import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/working_time_setting_model.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class WorkingTimeSettingRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<WorkingTimeSettingModel>?> getWorkingTimeSetting(
      {Options? options, required int organizationId}) async {
    try {
      final response = await apiDataStore.requestAPI(
          ApiURL.getWorkingTimeSetting,
          options: options,
          params: {'organization_id': organizationId});

      return BaseListResponse.fromJson(
          JSON(response), WorkingTimeSettingModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeSettingModel>?> addWorkingTimeSetting(
      {required WorkingTimeSettingModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getWorkingTimeSetting.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeSettingModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeSettingModel>?> updateWorkingTimeSetting(
      {required WorkingTimeSettingModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/working-time-setting/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeSettingModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeSettingModel>?> getDetailWorkingTimeSetting(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getWorkingTimeSetting,
        customURL: '/working-time-setting/$id/',
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeSettingModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteWorkingTimeSetting({required int id}) async {
    try {
      await apiDataStore.requestAPI(
        ApiURL.deleteOrganization,
        customURL: '/working-time-setting/$id/',
      );
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
