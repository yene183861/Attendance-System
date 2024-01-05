import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/reward_discipline_model.dart';
import 'package:firefly/data/request_param/get_reward_and_discipline_param.dart';
import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class BonusDisciplineRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<RewardOrDisciplineModel>?> getBonusOrDiscipline(
      {Options? options, required GetRewardAndDisciplineParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getBonus,
        options: options,
        params: param.toJson(),
      );

      return BaseListResponse.fromJson(
          JSON(response), RewardOrDisciplineModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<RewardOrDisciplineModel>?> addBonusOrDiscipline(
      {required RewardOrDisciplineModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getBonus.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), RewardOrDisciplineModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<RewardOrDisciplineModel>?> updateBonusOrDiscipline(
      {required RewardOrDisciplineModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/reward-and-discipline/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(
          JSON(response), RewardOrDisciplineModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<RewardOrDisciplineModel>?> getDetailBonusOrDiscipline(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getTeam,
        customURL: '/reward-and-discipline/$id/',
      );
      return BaseResponse.fromJson(
          JSON(response), RewardOrDisciplineModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteBonusOrDiscipline({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/reward-and-discipline/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
