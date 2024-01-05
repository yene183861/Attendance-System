import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';

import '../../utils/size_config.dart';
import '../app_router.dart';
import 'components/setting_item.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppbarDefaultCustom(
            title: 'Cài đặt',
            isCallBack: true,
          ),
          Padding(
            padding: defaultPadding(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingItem(
                  title: 'Cập nhật hồ sơ',
                  iconPath: ICON_CONST.icProfileAccount.path,
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRouter.UPDATE_PROFILE_SCREEN);
                    // ignore: use_build_context_synchronously
                    // context.read<SettingBloc>().add(GetProfileEvent());
                  },
                ),
                SettingItem(
                  title: 'Thay đổi mật khẩu',
                  iconPath: ICON_CONST.icLogout.path,
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRouter.CHANGE_PASSWORD_SCREEN);
                  },
                ),
                SettingItem(
                  title: 'Thay đổi chủ đề',
                  iconPath: ICON_CONST.icColorBoard.path,
                  onTap: () {},
                ),
                SettingItem(
                  title: 'Hỗ trợ',
                  iconPath: ICON_CONST.icSupport.path,
                  onTap: () {
                    // Navigator.pushNamed(context, AppRouter.SUPPORT_SCREEN);
                  },
                ),
                SettingItem(
                  title: 'Thay đổi ngôn ngữ',
                  iconPath: ICON_CONST.icLanguage.path,
                  onTap: () async {
                    // final result = await Navigator.pushNamed(
                    //     context, AppRouter.CHANGE_LANGUAGE_SCREEN,
                    //     arguments: context.locale.languageCode);
                    // Singleton.instance.keyFormDaborad = UniqueKey();
                    // key = UniqueKey();
                  },
                  widthIcon: getProportionateScreenWidth(27),
                ),
                SettingItem(
                  title: 'Nhận thông báo',
                  isSwitch: true,
                  iconPath: ICON_CONST.icNotificationPermission.path,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
