import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_circle_avatar_from_network.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/screens/app_router.dart';
import 'package:firefly/utils/session_manager.dart';
import 'package:firefly/utils/singleton.dart';

import 'package:firefly/utils/size_config.dart';

import '../../configs/resources/barrel_const.dart';
import 'bloc/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
      ],
      child: DashboardBody(),
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late List<Map<String, dynamic>> items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final role = Singleton.instance.userType!;
    items = [
      if (role != UserType.STAFF)
        {
          'title': 'Danh sách nhân sự',
          'icon': const Icon(
            Icons.groups_2,
            size: 22,
            color: COLOR_CONST.cloudBurst,
          ),
          'onTap': () {
            Navigator.of(context).pushNamed(AppRouter.MANAGE_STAFF_SCREEN);
          },
        },
      {
        'title': 'title_list_contracts'.tr(),
        'icon': const Icon(
          Icons.receipt_long_outlined,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context).pushNamed(AppRouter.CONTRACT_SCREEN);
        },
      },
      // {
      //   'title': 'title_rate_staff'.tr(),
      //   'icon': const Icon(
      //     Icons.rate_review_outlined,
      //     size: 22,
      //     color: COLOR_CONST.cloudBurst,
      //   ),
      //   'onTap': () {},
      // },
      if (role != UserType.STAFF)
        {
          'title': 'Đăng ký gương mặt'.tr(),
          'icon': const Icon(
            Icons.fact_check_outlined,
            size: 22,
            color: COLOR_CONST.cloudBurst,
          ),
          'onTap': () {
            Navigator.of(context)
                .pushNamed(AppRouter.FACE_REGISTERED_LIST_SCREEN);
          },
        },
      {
        'title': 'Quản lý chấm công'.tr(),
        'icon': const Icon(
          Icons.perm_contact_calendar_sharp,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          // Navigator.of(context).pushNamed(AppRouter.ATTENDANCE_FACE_SCREEN);
          Navigator.of(context).pushNamed(AppRouter.ATTENDANCE_SHEET_SCREEN);
        },
      },
      {
        'title': 'Đơn từ'.tr(),
        'icon': const Icon(
          Icons.insert_drive_file,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context)
              .pushNamed(AppRouter.TICKET_SCREEN, arguments: false);
        },
      },
      if (role.type <= UserType.CEO.type)
        {
          'title': 'title_ticket_reason'.tr(),
          'icon': const Icon(
            Icons.note_add_outlined,
            size: 22,
            color: COLOR_CONST.cloudBurst,
          ),
          'onTap': () {
            Navigator.of(context).pushNamed(AppRouter.TICKET_REASON_SCREEN);
          },
        },
      {
        'title': 'Bảng lương'.tr(),
        'icon': const Icon(
          Icons.groups_2,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context).pushNamed(AppRouter.PAYROLL_SCREEN);
        },
      },
      {
        'title': 'title_allowance'.tr(),
        'icon': const Icon(
          Icons.receipt_long_outlined,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context).pushNamed(AppRouter.ALLOWANCE_SCREEN);
        },
      },
      {
        'title': 'Thưởng, phạt'.tr(),
        'icon': const Icon(
          Icons.pending_actions,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context).pushNamed(AppRouter.BONUS_DISCRIPLINE_SCREEN);
        },
      },
      {
        'title': 'Cơ cấu tổ chức'.tr(),
        'icon': const Icon(
          Icons.account_tree_outlined,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          final userType = Singleton.instance.userType;
          if (userType == UserType.ADMIN) {
            Navigator.of(context).pushNamed(AppRouter.ORGANIZATION_SCREEN);
          } else {
            log('${Singleton.instance.userWork!.organization}');
            Navigator.of(context).pushNamed(AppRouter.BRANCH_OFFICE_SCREEN,
                arguments: Singleton.instance.userWork!.organization!.id!);
          }
        },
      },
      {
        'title': 'Cài đặt'.tr(),
        'icon': const Icon(
          Icons.settings,
          size: 22,
          color: COLOR_CONST.cloudBurst,
        ),
        'onTap': () {
          Navigator.of(context).pushNamed(AppRouter.SETTINGS_SCREEN);
        },
      },
      // {
      //   'title': 'Chấm công'.tr(),
      //   'icon': const Icon(
      //     Icons.account_tree_outlined,
      //     size: 22,
      //     color: COLOR_CONST.cloudBurst,
      //   ),
      //   'onTap': () {
      //     Navigator.of(context).pushNamed(AppRouter.ATTENDANCE_FACE_SCREEN);
      //   },
      // },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Singleton.instance.userProfile;
    // final userWork = Singleton.instance.userWork;
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarDefaultCustom(
              title: 'app_name'.tr(),
              leading: Container(
                margin: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {},
                  splashColor: COLOR_CONST.gray.withOpacity(0.2),
                  child: Ink(
                    padding: defaultPadding(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      size: 24,
                      color: COLOR_CONST.cloudBurst,
                    ),
                  ),
                ),
              ),
              textStyleTitle: FONT_CONST.bold(
                fontSize: 30,
                fontFamily: 'LumanosimoRegular',
              ),
              actions: GestureDetector(
                onTap: () async {
                  await SessionManager.share.removeAll();
                  // await SessionManager.share.saveIsFirstOpenApp();

                  Singleton.instance.userProfile = null;
                  Singleton.instance.tokenLogin = null;
                  Singleton.instance.userWork = null;
                  Singleton.instance.userType = null;

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.LOGIN_SCREEN, (route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 24,
                      color: COLOR_CONST.cloudBurst,
                    ),
                    Text(
                      'Thoát',
                      style: FONT_CONST.regular(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Xin chào, ',
                        style: FONT_CONST.regular(),
                      ),
                      // const HorizontalSpacing(),
                      Text(
                        userProfile?.fullname ?? '',
                        style: FONT_CONST.bold(),
                      ),
                    ],
                  ),
                  const VerticalSpacing(of: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCircleAvatarFromNetwork(
                          urlImage: userProfile?.avatarThumb ?? ''),
                      const HorizontalSpacing(of: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile?.email ?? '',
                              style: FONT_CONST.regular(),
                            ),
                            const VerticalSpacing(of: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'title_position'.tr(),
                                  style: FONT_CONST.regular(),
                                ),
                                Text(
                                  'msg_format_easy_read'.tr(),
                                  style: FONT_CONST.regular(),
                                ),
                                Expanded(
                                  child: Text(
                                    userProfile?.userType.value ?? '',
                                    style: FONT_CONST.regular(),
                                  ),
                                )
                              ],
                            ),
                            const VerticalSpacing(of: 5),
                            if (Singleton.instance.userType!.type >=
                                UserType.DIRECTOR.type)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mã nhân viên'.tr(),
                                    style: FONT_CONST.regular(),
                                  ),
                                  Text(
                                    'msg_format_easy_read'.tr(),
                                    style: FONT_CONST.regular(),
                                  ),
                                  Expanded(
                                    child: Text(
                                      userProfile?.staffId ?? '',
                                      style: FONT_CONST.regular(),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpacing(of: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) => FuctionButton(
                      title: items[index]['title'],
                      icon: items[index]['icon'],
                      onTap: items[index]['onTap'],
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      // childAspectRatio: 0.6,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FuctionButton extends StatelessWidget {
  const FuctionButton({
    super.key,
    required this.title,
    this.onTap,
    required this.icon,
  });
  final String title;
  final Function? onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: SizeConfig.screenWidth * 0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(2, 2),
                      blurRadius: 5),
                ],
                borderRadius: BorderRadius.circular(12),
                color: COLOR_CONST.white.withOpacity(0.8),
              ),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: FONT_CONST.medium(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DashboardBody extends StatefulWidget {
//   const DashboardBody({super.key});

//   @override
//   State<DashboardBody> createState() => _DashboardBodyState();
// }

// class _DashboardBodyState extends State<DashboardBody> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   int _currentIndex = 0;
//   UserModel? userProfile;

//   final List<Widget> _pageList =
//       BottomBarItemType.values.map((e) => e.widget).toList();

//   void _indexChange(int toIndex) {
//     setState(() {
//       _currentIndex = toIndex;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: COLOR_CONST.backgroundColor,
//       drawer: Drawer(
//         width: SizeConfig.screenWidth / 1.4,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             CustomDrawerHeader(profile: Singleton.instance.userProfile),
//             // DrawerItem(
//             //   scaffoldKey: _scaffoldKey,
//             //   icon: SvgPicture.asset(
//             //     ICON_CONST.icHome.path,
//             //     color: COLOR_CONST.cloudBurst,
//             //   ),
//             //   title: 'title_home'.tr(),
//             //   onTap: () {
//             //     _indexChange(0);
//             //   },
//             //   isSelected: _currentIndex == 0,
//             // ),
//             // const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: Image.asset(
//                     ICON_CONST.icCalendar.path,
//                     color: COLOR_CONST.cloudBurst,
//                   )),
//               title: 'title_attendance_sheet'.tr(),
//               onTap: () {
//                 _indexChange(0);
//               },
//               isSelected: _currentIndex == 0,
//             ),
//             const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: Image.asset(
//                     ICON_CONST.icTicket.path,
//                     color: COLOR_CONST.cloudBurst,
//                   )),
//               title: 'title_ticket'.tr(),
//               onTap: () {
//                 _indexChange(1);
//               },
//               isSelected: _currentIndex == 1,
//             ),
//             const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: Image.asset(
//                     ICON_CONST.icPayroll.path,
//                     color: COLOR_CONST.cloudBurst,
//                   )),
//               title: 'title_payroll'.tr(),
//               onTap: () {
//                 _indexChange(2);
//               },
//               isSelected: _currentIndex == 2,
//             ),
//             const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: Image.asset(
//                     ICON_CONST.icManage.path,
//                     color: COLOR_CONST.cloudBurst,
//                   )),
//               title: 'title_manage'.tr(),
//               onTap: () {
//                 _indexChange(3);
//               },
//               isSelected: _currentIndex == 3,
//             ),
//             const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SizedBox(
//                 height: 22,
//                 width: 22,
//                 child: SvgPicture.asset(
//                   ICON_CONST.icSetting.path,
//                   color: COLOR_CONST.cloudBurst,
//                 ),
//               ),
//               title: 'title_setting'.tr(),
//               onTap: () {
//                 _indexChange(4);
//               },
//               isSelected: _currentIndex == 4,
//             ),
//             const Divider(height: 1),
//             DrawerItem(
//               scaffoldKey: _scaffoldKey,
//               icon: SvgPicture.asset(
//                 ICON_CONST.icLogout.path,
//                 color: COLOR_CONST.cloudBurst,
//               ),
//               title: 'title_logout'.tr(),
//               onTap: () async {
//                 await SessionManager.share.removeAll();
//                 // await SessionManager.share.saveIsFirstOpenApp();

//                 Singleton.instance.userProfile = null;
//                 Singleton.instance.tokenLogin = null;
//                 Singleton.instance.userWork = null;
//                 Singleton.instance.userType = null;

//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     AppRouter.LOGIN_SCREEN, (route) => false);
//               },
//             ),
//           ],
//         ),
//       ),
//       extendBody: true,
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//                 left: getProportionateScreenWidth(20),
//                 right: getProportionateScreenWidth(20),
//                 top: SizeConfig.paddingTop),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     _scaffoldKey.currentState!.openDrawer();
//                   },
//                   borderRadius: BorderRadius.circular(12),
//                   child: Ink(
//                     padding: EdgeInsets.all(getProportionateScreenWidth(5)),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: SizedBox(
//                         width: 30,
//                         height: 30,
//                         child: SvgPicture.asset(ICON_CONST.icMenu.path)),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     'app_name'.tr(),
//                     textAlign: TextAlign.center,
//                     style: FONT_CONST.bold(
//                         fontSize: 30, fontFamily: 'LumanosimoRegular'),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {},
//                   borderRadius: BorderRadius.circular(12),
//                   child: Ink(
//                     padding: EdgeInsets.all(getProportionateScreenWidth(5)),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: SizedBox(
//                         width: 25,
//                         height: 25,
//                         child: SvgPicture.asset(
//                           ICON_CONST.icNotification.path,
//                         )),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: IndexedStack(
//               index: _currentIndex,
//               children: _pageList,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
