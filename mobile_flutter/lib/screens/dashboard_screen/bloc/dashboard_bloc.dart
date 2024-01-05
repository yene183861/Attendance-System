// ignore: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';
part 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    // on<RegisterFcmDeviceEvent>(_registerFcmDeviceEvent);
  }

  // Future<void> _registerFcmDeviceEvent(
  //     RegisterFcmDeviceEvent event, Emitter<DashboardState> emit) async {
  //   try {
  //     var type = "";
  //     if (Platform.isIOS) {
  //       type = 'ios';
  //     } else if (Platform.isAndroid) {
  //       type = 'android';
  //     }

  //     final userInformation = Singleton.instance.userProfile ??
  //         await SessionManager.share.getUserProfile();
  //     final deviceParams = DeviceParams(
  //         name: 'device',
  //         registrationId: event.tokenFireBase,
  //         deviceId: '',
  //         active: userInformation?.isNotification ?? false,
  //         type: type);

  //     final deviceModel =
  //         await notificationRepository.registerFcmDevice(deviceParams);
  //     await SessionManager.share
  //         .saveFirebaseToken(firebaseToken: event.tokenFireBase);
  //   } on ErrorFromServer catch (e) {
  //     print("${e.message}");
  //   }
  // }
}
