import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firefly/data/request_param/common_param.dart';
import 'package:g_json/g_json.dart';
import 'package:firefly/data/model/face_model.dart';
import 'package:firefly/data/request_param/register_face_param.dart';

import 'package:firefly/data/response_model/base_response.dart';
import 'package:firefly/data/response_model/base_response_list.dart';

import '../api/barrel_api.dart';

class FaceRepository {
  APIDataStore apiDataStore = APIDataStore();

  Future<BaseListResponse<FaceModel>?> getListFaces(
      {Options? options, CommonParam? param}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.getFace,
          options: options, params: param?.toJson());

      return BaseListResponse.fromJson(JSON(response), FaceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<FaceModel>?> registerFace(
      {required RegisterFaceParam registerFaceParam}) async {
    try {
      final response = await apiDataStore.requestAPI(ApiURL.registerFace,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'multipart/form-data',
            },
          ),
          formData: registerFaceParam.toFormData());
      return BaseResponse.fromJson(JSON(response), FaceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  Future<BaseResponse<FaceModel>?> attendanceFace(
      {required List<File> files}) async {
    try {
      var imageFileList = [];
      for (int i = 0; i < files.length; i++) {
        imageFileList.add(MultipartFile.fromFileSync(files[i].path));
      }
      final response = await apiDataStore.requestAPI(ApiURL.attendanceFace,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'multipart/form-data',
            },
          ),
          formData: FormData.fromMap({'images': imageFileList}));
      return BaseResponse.fromJson(JSON(response), FaceModel.fromJson);
    } on DioError catch (e) {
      throw ErrorFromServer(message: e.message);
    }
  }

  // Future<BaseResponse<AllowanceModel>?> getDetailAllowance(
  //     {required int id}) async {
  //   try {
  //     final response = await apiDataStore.requestAPI(
  //       ApiURL.getAllowance,
  //       customURL: '/allowance/$id/',
  //     );
  //     return BaseResponse.fromJson(JSON(response), AllowanceModel.fromJson);
  //   } on DioError catch (e) {
  //     throw ErrorFromServer(message: e.message);
  //   }
  // }

  // Future<void> deleteAllowance({required int id}) async {
  //   try {
  //     await apiDataStore.requestAPI(ApiURL.deleteOrganization,
  //         customURL: '/allowance/$id/');
  //     return;
  //   } on DioError catch (e) {
  //     throw ErrorFromServer(message: e.message);
  //   }
  // }
}
