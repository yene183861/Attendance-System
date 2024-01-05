import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/model/payroll_model.dart';
import 'package:firefly/data/request_param/get_payroll_param.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:g_json/g_json.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class PayrollRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<PayrollModel>?> getPayrolls(
      {Options? options, required GetPayrollParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getAllowance,
          customURL: '/payroll/', options: options, params: param.toJson());

      return BaseListResponse.fromJson(JSON(response), PayrollModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<PayrollModel>?> createPayroll(
      {required int userId, required DateTime month}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: '/payroll/',
        body: {
          'user': userId,
          'month': Utils.formatDateTimeToString(
              time: month, dateFormat: DateFormat(DateTimePattern.dayType2))
        },
      );
      return BaseResponse.fromJson(JSON(response), PayrollModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  // Future<BaseResponse<PayrollModel>?> updatePayroll(
  //     {required int id, required PayrollModel model}) async {
  //   try {
  //     final response = await apiDataStore.requestAPI(
  //       ApiURL.updateOrganization,
  //       customURL: '/payroll/$id/',
  //       body: model.tọ,
  //     );
  //     return BaseResponse.fromJson(JSON(response), PayrollModel.fromJson);
  //   } on DioError catch (e) {
  //     throw ErrorFromServer(message: e.message);
  //   }
  // }

  Future<void> deleteAttendance({required int id}) async {
    try {
      await apiDataStore.requestAPI(ApiURL.deleteOrganization,
          customURL: '/attendance/$id/');
      return;
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }
}
