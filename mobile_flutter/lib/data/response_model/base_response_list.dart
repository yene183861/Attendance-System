import 'package:g_json/g_json.dart';

class BaseListResponse<T> {
  int errorCode;
  String message;
  List<T>? data;

  BaseListResponse({
    required this.errorCode,
    required this.message,
    this.data,
  });

  /// param map: map key "data" response from api.
  /// param fromJsonModel:  object conver from json.
  ///
  factory BaseListResponse.fromJson(JSON map, Function fromJsonModel) {
    return BaseListResponse(
      errorCode: map['error_code'].integerValue,
      message: map['message'].stringValue,
      data: List<T>.from(map['data']
          .listValue
          .map((itemsJson) => fromJsonModel(itemsJson))
          .toList()),
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}
