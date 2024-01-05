import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firefly/screens/dashboard_screen/dashboard_screen.dart';

import 'data/enum_type/language_type.dart';
import 'firefly.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'package:face_camera/face_camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await FaceCamera.initialize();

  runApp(EasyLocalization(
    path: 'assets/translations',
    supportedLocales: [
      LanguageType.VIETNAM.locale,
      LanguageType.ENGLISH.locale,
      LanguageType.KOREAN.locale,
      LanguageType.JAPAN.locale,
    ],
    fallbackLocale: LanguageType.ENGLISH.locale,
    saveLocale: true,
    startLocale: Locale('vi'),
    child: const OfficeApp(
      firstScreen: SplashScreen(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}
