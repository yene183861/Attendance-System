import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/utils/size_config.dart';

class MaximumTextfield extends StatelessWidget {
  const MaximumTextfield({
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
          title: 'maximum_days'.tr(),
          isRequired: true,
        ),
        const VerticalSpacing(of: 6),
        CustomTextFormField(
          hintText: 'maximum'.tr(),
          controller: controller,
          maxLength: 3,
          maxLines: 1,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: (p0) {
            final value = p0?.trim();
            if (value == null || value.isEmpty) {
              return 'msg_required_field'.tr();
            }
            final amount = int.parse(value);
            if (amount == 0) {
              return 'min_days'.tr();
            }

            return null;
          },
        ),
      ],
    );
  }
}
