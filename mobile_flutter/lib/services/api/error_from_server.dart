import 'package:g_json/g_json.dart';

class ErrorFromServer implements Exception {
  // final bool? status;
  final int? errorCode;
  final String? message;

  // Init
  ErrorFromServer({
    // this.status,
    this.errorCode,
    this.message,
  });

  // Error from Server
  factory ErrorFromServer.fromJson(Map<String, dynamic> json) {
    try {
      final jsonParser = JSON(json);
      return ErrorFromServer(
        // status: jsonParser['data'].booleanValue,
        errorCode: jsonParser['error_code'].integerValue,
        message: jsonParser['message'].stringValue,
      );
    } catch (e) {
      return ErrorFromServer.unknownError(customMessage: e.toString());
    }
  }

  factory ErrorFromServer.unknownError({String? customMessage}) {
    return ErrorFromServer(
        // status: false,
        errorCode: -1,
        message: customMessage ?? 'unknown_error');
  }

  factory ErrorFromServer.noInternetConnection() {
    return ErrorFromServer(
        // status: false,
        errorCode: -2,
        message: 'no_internet_connection');
  }
}
