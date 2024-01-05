import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/utils/size_config.dart';

class ReasonTextField extends StatelessWidget {
  const ReasonTextField({
    super.key,
    required this.controller,
    required this.formKey,
  });
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleField(
          title: 'reason'.tr(),
          isRequired: true,
        ),
        const VerticalSpacing(of: 6),
        CustomTextFormField(
          hintText: 'reason'.tr().toLowerCase(),
          controller: controller,
          maxLength: 255,
          maxLines: null,
          validator: (p0) {
            final value = p0?.trim();
            if (value == null || value.isEmpty) {
              return 'msg_required_field'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
