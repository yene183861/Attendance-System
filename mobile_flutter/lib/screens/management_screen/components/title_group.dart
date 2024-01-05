import 'package:flutter/material.dart';

import '../../../configs/resources/barrel_const.dart';
import '../../../custom_widget/default_padding.dart';

class TitleGroup extends StatelessWidget {
  const TitleGroup({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: defaultPadding(),
      decoration: BoxDecoration(color: Colors.grey.shade100),
      child: Text(
        title,
        style: FONT_CONST.semoBold(
          color: Colors.black87,
        ),
      ),
    );
  }
}
