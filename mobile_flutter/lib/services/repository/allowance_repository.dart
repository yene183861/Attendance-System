import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/allowance_model.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class AllowanceRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<AllowanceModel>?> getAllowance(
      {Options? options, required int organizationId}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getAllowance,
          options: options, params: {'organization_id': organizationId});

      return BaseListResponse.fromJson(JSON(response), AllowanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AllowanceModel>?> addAllowance(
      {required AllowanceModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getAllowance.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), AllowanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AllowanceModel>?> updateAllowance(
      {required AllowanceModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/allowance/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), AllowanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AllowanceModel>?> getDetailAllowance(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getAllowance,
        customURL: '/allowance/$id/',
      );
      return BaseResponse.fromJson(JSON(response), AllowanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteAllowance({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/allowance/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
