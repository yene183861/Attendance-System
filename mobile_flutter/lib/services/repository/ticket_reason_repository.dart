import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/ticket_reason_model.dart';
import 'package:firefly/data/request_param/get_ticket_reason_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class TicketReasonRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<TicketReasonModel>?> getTicketReasons(
      {Options? options, required GetTicketReasonParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getTicketReasons,
          options: options, params: param.toJson());

      return BaseListResponse.fromJson(
          JSON(response), TicketReasonModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketReasonModel>?> addTicketReason(
      {required TicketReasonModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getTicketReasons.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TicketReasonModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketReasonModel>?> updateTicketReason(
      {required TicketReasonModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/ticket-reason/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TicketReasonModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketReasonModel>?> getDetailTicketReason(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getTicketReasons,
        customURL: '/ticket-reason/$id/',
      );
      return BaseResponse.fromJson(JSON(response), TicketReasonModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteTicketReason({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/ticket-reason/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
