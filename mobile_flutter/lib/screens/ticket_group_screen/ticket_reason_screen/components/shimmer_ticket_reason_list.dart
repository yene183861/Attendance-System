import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTicketReasonList extends StatelessWidget {
  const ShimmerTicketReasonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: COLOR_CONST.gray.withOpacity(0.5),
      highlightColor: COLOR_CONST.gray,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: defaultPadding(horizontal: 25, vertical: 0),
        itemCount: 4,
        itemBuilder: (context, index) => const _ShimmerItem(),
        separatorBuilder: (context, index) => Divider(
          color: COLOR_CONST.gray.withOpacity(0.5),
          height: 1,
        ),
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultPadding(horizontal: 0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: color ?? COLOR_CONST.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    '',
                    style: FONT_CONST.regular(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const HorizontalSpacing(of: 15),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                alignment: Alignment.centerRight,
                padding: defaultPadding(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: COLOR_CONST.cloudBurst.withOpacity(0.3),
                ),
                child: Text(
                  '',
                  style: FONT_CONST.regular(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: getProportionateScreenWidth(150),
                  decoration: BoxDecoration(
                      color: color ?? COLOR_CONST.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    '',
                    style: FONT_CONST.regular(),
                  ),
                ),
                const VerticalSpacing(of: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: color ?? COLOR_CONST.gray.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3)),
                  child: Text(
                    '',
                    style: FONT_CONST.regular(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
