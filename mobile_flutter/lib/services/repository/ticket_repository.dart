import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/ticket_model.dart';
import 'package:firefly/data/request_param/get_ticket_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class TicketRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<TicketModel>?> getTickets(
      {Options? options, required GetTicketParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getTicket,
          options: options, params: param.toJson());

      return BaseListResponse.fromJson(JSON(response), TicketModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketModel>?> addTicket(
      {required TicketModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getTicket.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TicketModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketModel>?> updateTicket(
      {required TicketModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/ticket/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), TicketModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<TicketModel>?> getDetailTicket({required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getTicket,
        customURL: '/ticket/$id/',
      );
      return BaseResponse.fromJson(JSON(response), TicketModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<void> deleteTicket({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/ticket/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
