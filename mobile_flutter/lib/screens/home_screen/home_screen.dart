// import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:firefly/utils/size_config.dart';

import '../../configs/resources/barrel_const.dart';

import 'components/today_attendance.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: getProportionateScreenHeight(20),
                bottom: getProportionateScreenHeight(50)),
            padding: EdgeInsets.only(
                right: getProportionateScreenWidth(20),
                left: getProportionateScreenWidth(25)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'title_welcome '),
                          TextSpan(
                              text: Singleton.instance.userProfile!.fullname,
                              style: FONT_CONST.semoBold()),
                        ],
                        style: FONT_CONST.medium(),
                      ),
                    ),
                    // Text(
                    //   'Let\'s get to work!',
                    //   style: FONT_CONST.bold(color: Colors.black, fontSize: 20),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: getProportionateScreenHeight(130),
            child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -getProportionateScreenHeight(65),
                    child: const TodayAttendance(),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
