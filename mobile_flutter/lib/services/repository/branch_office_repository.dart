import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/branch_office_model.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class BranchOfficeRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<BranchOfficeModel>?> getBranches(
      {Options? options, required int organizationId}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getBranchOffice,
          params: {
            'organization_id': organizationId,
          },
          options: options);

      return BaseListResponse.fromJson(
          JSON(response), BranchOfficeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<BranchOfficeModel>?> addBranch(
      {required BranchOfficeModel branchModel}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getBranchOffice.path,
        body: branchModel.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), BranchOfficeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<BranchOfficeModel>?> updateBranch(
      {required BranchOfficeModel branchModel, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/branch-office/$id/',
        body: branchModel.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), BranchOfficeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<BranchOfficeModel>?> getDetailBranch(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getBranchOffice,
        customURL: '/branch-office/$id/',
      );
      return BaseResponse.fromJson(JSON(response), BranchOfficeModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteBranch({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/branch-office/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
