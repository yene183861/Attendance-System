import 'package:flutter/material.dart';
import 'package:firefly/configs/resources/barrel_const.dart';

class TitleField extends StatelessWidget {
  const TitleField({super.key, required this.title, this.isRequired = false});
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: FONT_CONST.regular(
            color: COLOR_CONST.cloudBurst,
            fontSize: 16,
          ),
        ),
        if (isRequired)
          Text(
            ' (*)',
            style: FONT_CONST.regular(
              color: COLOR_CONST.portlandOrange,
              fontSize: 16,
            ),
          ),
      ],
    );
  }
}
