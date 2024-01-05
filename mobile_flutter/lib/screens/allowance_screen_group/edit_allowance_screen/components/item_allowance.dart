import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/model/allowance_model.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';

class ItemAllowance extends StatelessWidget {
  const ItemAllowance({
    super.key,
    required this.allowance,
  });
  final AllowanceModel allowance;

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
                  child: Text(
                allowance.name,
                style: FONT_CONST.regular(
                  fontSize: 18,
                ),
              )),
              const HorizontalSpacing(of: 15),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                alignment: Alignment.centerRight,
                padding: defaultPadding(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: COLOR_CONST.cloudBurst.withOpacity(0.3),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: allowance.amount == 0
                            ? '0'
                            : allowance.amount >= 100000000
                                ? '${Utils.formatCurrency(amount: 1000000000, context: context, format: NumberFormatPattern.vnCurrency)} +'
                                : Utils.formatCurrency(
                                    amount: allowance.amount,
                                    context: context,
                                    format: NumberFormatPattern.vnCurrency),
                      ),
                      TextSpan(text: ' ${'currency'.tr()}'),
                    ],
                  ),
                  style: FONT_CONST.medium(),
                ),
              )
            ],
          ),
          if (allowance.description != null &&
              allowance.description!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (allowance.amount != allowance.maximumAmount)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'maximum'.tr()),
                          TextSpan(text: 'msg_format_easy_read'.tr()),
                          TextSpan(
                            text: allowance.maximumAmount >= 10000000000000
                                ? '${Utils.formatCurrency(amount: 10000000000000, context: context, format: NumberFormatPattern.vnCurrency)} +'
                                : Utils.formatCurrency(
                                    amount: allowance.maximumAmount,
                                    context: context,
                                    format: NumberFormatPattern.vnCurrency),
                          ),
                          TextSpan(text: ' ${'currency_1'.tr()}'),
                        ],
                        style: FONT_CONST.regular(),
                      ),
                    ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'note'.tr()),
                        TextSpan(text: 'msg_format_easy_read'.tr()),
                        TextSpan(text: allowance.description),
                      ],
                      style: FONT_CONST.regular(),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
