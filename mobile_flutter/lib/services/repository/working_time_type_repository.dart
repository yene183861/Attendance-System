import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/working_time_type_model.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class WorkingTimeTypeRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<WorkingTimeTypeModel>?> getWorkingTimeType(
      {Options? options, required int organizationId}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getWorkingTimeType,
          options: options, params: {'organization_id': organizationId});

      return BaseListResponse.fromJson(
          JSON(response), WorkingTimeTypeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeTypeModel>?> addWorkingTimeType(
      {required WorkingTimeTypeModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getWorkingTimeType.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeTypeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeTypeModel>?> updateWorkingTimeType(
      {required WorkingTimeTypeModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/working-time-type/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeTypeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<WorkingTimeTypeModel>?> getDetailWorkingTimeType(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getWorkingTimeType,
        customURL: '/working-time-type/$id/',
      );
      return BaseResponse.fromJson(
          JSON(response), WorkingTimeTypeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteWorkingTimeType({required int id}) async {
    try {
      await apiDataStore.requestAPI(
        ApiURL.deleteOrganization,
        customURL: '/working-time-type/$id/',
      );
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
