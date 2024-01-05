import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../configs/resources/barrel_const.dart';
import '../../../../custom_widget/default_padding.dart';
import '../../../../utils/size_config.dart';
import '../../../app_router.dart';

class LeaveStatisticsWidget extends StatelessWidget {
  const LeaveStatisticsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.DETAIL_LEAVE_SCREEN);
            },
            child: Text(
              'msg_see_detail'.tr(),
              style: FONT_CONST.regular(
                textDecoration: TextDecoration.underline,
                color: COLOR_CONST.portlandOrange,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const VerticalSpacing(of: 5),
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FixedColumnWidth(
                (SizeConfig.screenWidth - getProportionateScreenWidth(50)) *
                    0.33),
            1: FixedColumnWidth(
                (SizeConfig.screenWidth - getProportionateScreenWidth(50)) *
                    0.33),
            2: FixedColumnWidth(
                (SizeConfig.screenWidth - getProportionateScreenWidth(50)) *
                    0.33),
          },
          border: TableBorder.all(
              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Container(
                  padding: defaultPadding(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('msg_total_leaves'.tr()),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '12'),
                          TextSpan(text: ' '),
                          TextSpan(text: 'msg_days'.tr()),
                        ], style: FONT_CONST.semoBold()),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: defaultPadding(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('msg_used_leaves'.tr()),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '0'),
                          TextSpan(text: ' '),
                          TextSpan(text: 'msg_days'.tr()),
                        ], style: FONT_CONST.semoBold()),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: defaultPadding(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('msg_remaining_leaves'.tr()),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '12'),
                          TextSpan(text: ' '),
                          TextSpan(text: 'msg_days'.tr()),
                        ], style: FONT_CONST.semoBold()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
