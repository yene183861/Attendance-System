import 'package:g_json/g_json.dart';

class BaseResponse<T> {
  int errorCode;
  String message;
  T? data;

  BaseResponse({
    required this.errorCode,
    required this.message,
    required this.data,
  });

  /// param map: map key "data" response from api.
  /// param fromJsonModel:  object conver from json.
  ///
  factory BaseResponse.fromJson(JSON map, Function fromJsonModel) {
    return BaseResponse(
      errorCode: map['error_code'].integerValue,
      message: map['message'].stringValue,
      data: fromJsonModel(map['data']),
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}
