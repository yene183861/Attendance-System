import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/utils/size_config.dart';

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleField(
          title: 'description'.tr(),
        ),
        const VerticalSpacing(of: 6),
        CustomTextFormField(
          hintText: 'description'.tr(),
          controller: controller,
          maxLength: 255,
          maxLines: null,
        ),
      ],
    );
  }
}
