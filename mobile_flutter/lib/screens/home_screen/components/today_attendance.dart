import 'package:flutter/material.dart';

import '../../../configs/resources/barrel_const.dart';
import '../../../custom_widget/custom_line_vertical.dart';
import '../../../utils/size_config.dart';

class TodayAttendance extends StatelessWidget {
  const TodayAttendance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth - getProportionateScreenWidth(60),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ca làm việc'),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '08:00',
                    ),
                    TextSpan(
                      text: ' - ',
                    ),
                    TextSpan(
                      text: '17:30',
                    ),
                  ],
                ),
                style: FONT_CONST.regular(),
              ),
            ],
          ),
          lineVertical(
            margin: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Check-in',
                  ),
                  Text(
                    '--:--',
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.login,
                    color: Colors.grey.shade400,
                  ),
                  lineVertical(
                    width: getProportionateScreenWidth(50),
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10),
                    ),
                  ),
                  Icon(
                    Icons.logout,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Check-in',
                  ),
                  Text(
                    '--:--',
                  ),
                ],
              ),
            ],
          ),
          const VerticalSpacing(of: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Số giờ làm việc: '),
                TextSpan(text: '8'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
