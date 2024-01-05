import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/session_manager.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<void> checkLogin() async {
    final user = await SessionManager.share.getUserProfile();
    final organization = await SessionManager.share.getOrganization();
    final branch = await SessionManager.share.getBranchOffice();
    final department = await SessionManager.share.getDepartment();
    final team = await SessionManager.share.getTeam();
    final userWork = UserWorkModel(
      organization: organization,
      branchOffice: branch,
      department: department,
      team: team,
    );

    final token = await SessionManager.share.getToken();
    Singleton.instance.userProfile = user;
    Singleton.instance.userType = user?.userType;
    Singleton.instance.tokenLogin = token;
    Singleton.instance.userWork = userWork;
    Singleton.instance.isAllowShowReview = true;

    await Future.delayed(const Duration(seconds: 2));
    final nextScreen = token == null || token.isEmpty
        ? AppRouter.LOGIN_SCREEN
        : AppRouter.DASHBOARD_SCREEN;
    Navigator.of(context).pushNamedAndRemoveUntil(nextScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLOR_CONST.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IMAGE_CONST.logoApp.path,
                      fit: BoxFit.contain,
                      height: 180,
                      width: double.infinity,
                    ),
                    const VerticalSpacing(of: 20),
                    Text(
                      "app_name".tr(),
                      style: FONT_CONST.bold(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpacing(of: 5),
                    Text(
                      "msg_splash".tr(),
                      style: FONT_CONST.medium(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              VerticalSpacing(of: SizeConfig.paddingBottom + 22),
            ],
          ),
        ),
      ),
    );
  }
}
