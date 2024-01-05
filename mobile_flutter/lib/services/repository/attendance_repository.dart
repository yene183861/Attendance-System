import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/data/model/attendance_statistics_model.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/utils.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/attendance_model.dart';
import 'package:firefly/data/request_param/get_attendance_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class AttendanceRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<AttendanceModel>?> getAttendancesList(
      {Options? options, required GetAttendanceParam param}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getAttendance,
          options: options, params: param.toJson());

      return BaseListResponse.fromJson(
          JSON(response), AttendanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AttendanceStatisticsModel>?> getAttendancesStatistics(
      {Options? options, required int userId, required DateTime month}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getAttendance,
          customURL: '/attendance/attendance-statistics-month/',
          options: options,
          params: {
            'user_id': userId,
            'month': Utils.formatDateTimeToString(
                time: month, dateFormat: DateFormat(DateTimePattern.dayType2))
          });

      return BaseResponse.fromJson(
          JSON(response), AttendanceStatisticsModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AttendanceModel>?> addAttendance(
      {required AttendanceModel model}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.createOrganizaion,
        customURL: ApiURL.getAttendance.path,
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), AttendanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AttendanceModel>?> faceAttendance(
      {required AttendanceModel model, required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.updateOrganization,
        customURL: '/allowance/$id/',
        body: model.toJson(),
      );
      return BaseResponse.fromJson(JSON(response), AttendanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<AttendanceModel>?> getDetailAttendance(
      {required int id}) async {
    try {
      final response = await apiDataStore.requestAPI(
        ApiURL.getAttendance,
        customURL: '/attendance/$id/',
      );
      return BaseResponse.fromJson(JSON(response), AttendanceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

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
