import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/organization_model.dart';
import 'package:firefly/data/request_param/edit_organization_param.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class OrganizationRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<OrganizationModel>?> getOrganization(
      {Options? options}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getOrganization,
          options: options);

      return BaseListResponse.fromJson(
          JSON(response), OrganizationModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<OrganizationModel>?> addOrganization(
      {required EditOrganizationParam param}) async {
    try {
      final paramm = param.toFormData();
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        formData: paramm,
      );
      return BaseResponse.fromJson(JSON(response), OrganizationModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<OrganizationModel>?> updateOrganization(
      {required EditOrganizationParam param, required int id}) async {
    try {
      final paramm = param.toFormData();
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/organization/update/$id/',
        formData: paramm,
      );
      return BaseResponse.fromJson(JSON(response), OrganizationModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<OrganizationModel>?> getDetailOrganization(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getOrganization,
        customURL: '/organization/$id/',
      );
      return BaseResponse.fromJson(JSON(response), OrganizationModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteOrganization({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/organization/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
