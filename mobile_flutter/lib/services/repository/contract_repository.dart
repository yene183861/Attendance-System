import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/contract_model.dart';
import 'package:firefly/data/request_param/get_contract_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class ContractRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<ContractModel>?> getContract(
      {Options? options, required GetContractParam getContractParam}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getContract,
          options: options, params: getContractParam.toJson());

      return BaseListResponse.fromJson(JSON(response), ContractModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<ContractModel>?> addContract(
      {required ContractModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getContract.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), ContractModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<ContractModel>?> updateContract(
      {required ContractModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/contract/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), ContractModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<ContractModel>?> getDetailContract(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getContract,
        customURL: '/contract/$id/',
      );
      return BaseResponse.fromJson(JSON(response), ContractModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteContract({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/contract/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
