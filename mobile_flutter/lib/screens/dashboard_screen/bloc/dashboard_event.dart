part of 'dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class RegisterFcmDeviceEvent extends DashboardEvent {
  final String tokenFireBase;

  const RegisterFcmDeviceEvent({required this.tokenFireBase});
}
