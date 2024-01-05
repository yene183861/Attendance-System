import 'package:flutter/cupertino.dart';

class NavigationService {
  /// Creating the first instance
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();

  /// With this factory setup, any time  NavigationService() is called
  /// within the application _instance will be returned and not a new instance
  factory NavigationService() => _instance;

  ///This would allow the app to monitor the current screen state during navigation.
  ///
  ///This is where the singleton setup we did
  ///would help as the state is internally maintained
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  dynamic goBack([dynamic popValue]) {
    return navigationKey.currentState!.pop(popValue);
  }

  Future<dynamic> navigateToScreen(String route, {arguments}) async => navigationKey.currentState?.pushNamed(
      route, arguments: arguments
  );

  Future<dynamic> pushNamedAndRemoveUntil(String route) async => navigationKey.currentState?.pushNamedAndRemoveUntil(
      route, (route) => false
  );

}