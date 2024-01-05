import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'api_url.dart';
import 'dio_provider.dart';
import 'error_from_server.dart';

class APIDataStore {
  Dio dio = DioProvider.instance();

  APIDataStore();

  // Public Request API
  Future<dynamic> requestAPI(
    ApiURL apiURL, {
    Map<String, dynamic>? params,
    body,
    FormData? formData,
    String? customURL,
    bool tryAgain = true,
    Options? options,
  }) async {
    dynamic bodyRequest = '{}';
    if (body != null) {
      bodyRequest = jsonEncode(body);
    }
    if (formData != null) {
      log('formData != null');
      bodyRequest = formData;
    }
    try {
      Response? response;
      switch (apiURL.methods) {
        case HTTPRequestMethods.get:
          response = await dio.get(
            customURL ?? apiURL.path,
            queryParameters: params,
            options: options,
          );
          break;
        case HTTPRequestMethods.post:
          Options? _options;
          if (bodyRequest == null || bodyRequest is String) {
            _options = Options(
              headers: {
                Headers.contentTypeHeader: ContentType.json.value,
              },
            );
          }
          if (bodyRequest is FormData) {
            log('bodyRequest is FormData');
            _options = options ??
                Options(
                  headers: {
                    Headers.acceptHeader: ContentType.json.value,
                  },
                );
            log('_options: ${_options}');
          }

          response = await dio.post(customURL ?? apiURL.path,
              queryParameters: params, data: bodyRequest, options: _options);
          break;
        case HTTPRequestMethods.put:
          response = await dio.put(customURL ?? apiURL.path,
              queryParameters: params, data: bodyRequest);
          break;
        case HTTPRequestMethods.patch:
          response = await dio.patch(
            customURL ?? apiURL.path,
            queryParameters: params,
            data: bodyRequest,
          );
          break;
        case HTTPRequestMethods.delete:
          response = await dio.delete(customURL ?? apiURL.path,
              queryParameters: params, data: bodyRequest);
          break;
        default:
          log('Không có methods được tạo');
          break;
      }

      if (response?.data['error_code'] == 0) {
        return response?.data;
      } else {
        throw ErrorFromServer.fromJson(response?.data);
      }
    } on SocketException catch (_) {
      throw ErrorFromServer.noInternetConnection();
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.response && e.response!.data is! String) {
        // throw ErrorFromServer(
        //     errorCode: e.response!.data['error_code'],
        //     message: e.response!.data['message']);
        //Token user expired
        // if (e.response!.data['error_code'] == 41) {
        //   final token =
        //       Singleton.instance.tokenLogin ?? SessionManager.share.getToken();
        //   // ignore: unnecessary_null_comparison
        //   if (token != null) {
        //     // Utils.cleanAllToken();
        //     OneContext.instance.navigator.pushNamedAndRemoveUntil(
        //         AppRouter.LOGIN_SCREEN, (route) => false);
        //   }
        // }

        throw ErrorFromServer.fromJson(e.response?.data);
      } else if (e.type == DioErrorType.other) {
        throw ErrorFromServer.noInternetConnection();
      } else {
        print(e);
        throw ErrorFromServer.unknownError();
      }
    }
  }
}
