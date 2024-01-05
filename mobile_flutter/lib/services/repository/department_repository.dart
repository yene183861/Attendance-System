import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/department_model.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class DepartmentRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<DepartmentModel>?> getDepartments(
      {Options? options, required int branchId}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getDepartment,
        options: options,
        params: {
          'branch_office_id': branchId,
        },
      );

      return BaseListResponse.fromJson(
          JSON(response), DepartmentModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<DepartmentModel>?> addDepartment(
      {required DepartmentModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getDepartment.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), DepartmentModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<DepartmentModel>?> updateDepartment(
      {required DepartmentModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/department/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), DepartmentModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<DepartmentModel>?> getDetailBranch(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getDepartment,
        customURL: '/department/$id/',
      );
      return BaseResponse.fromJson(JSON(response), DepartmentModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteDepartment({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/department/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
