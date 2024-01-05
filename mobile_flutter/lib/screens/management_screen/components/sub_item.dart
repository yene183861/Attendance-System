import 'package:firefly/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../../configs/resources/font_const.dart';
import '../../../custom_widget/default_padding.dart';

class SubItem extends StatelessWidget {
  const SubItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final Widget icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 12,
      child: Ink(
        // height: getProportionateScreenHeight(130),
        padding: defaultPadding(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.orange.shade200),
              child: icon,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: FONT_CONST.regular(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
