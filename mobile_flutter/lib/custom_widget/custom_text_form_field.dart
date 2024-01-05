import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../configs/resources/barrel_const.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.validator,
    this.hintStyle,
    this.contentPadding,
    this.focusNode,
    this.controller,
    this.textStyle,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    this.obscureText,
    this.keyboardType,
    this.onTapOutside,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.onEditingComplete,
    this.onTap,
    this.borderContainer = false,
    this.prefixIcon,
    this.enabled = true,
    this.counter,
    this.maxLinesHintText = 1,
  });
  final String hintText;

  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final int maxLinesHintText;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final Function? onEditingComplete;
  final void Function()? onTap;
  final bool borderContainer;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final Widget? counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: enabled
          ? null
          : BoxDecoration(
              color: COLOR_CONST.lineGrey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        focusNode: focusNode,
        maxLength: maxLength,
        maxLines: maxLines,
        enabled: enabled,
        inputFormatters: inputFormatters,
        style: textStyle ?? FONT_CONST.regular(),
        obscureText: obscureText ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        onTapOutside: onTapOutside,
        onChanged: (value) {
          if (onChanged != null) onChanged!(value);
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
          if (onFieldSubmitted != null) onFieldSubmitted!(value);
        },
        onTap: onTap,
        onSaved: (value) {
          FocusScope.of(context).unfocus();
          if (onSaved != null) onSaved!(value);
        },
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          if (onEditingComplete != null) onEditingComplete!();
        },
        decoration: InputDecoration(
          hintText: hintText,
          counter: counter,
          border: borderContainer ? InputBorder.none : outlineInputBorder,
          enabledBorder:
              borderContainer ? InputBorder.none : outlineInputBorder,
          focusedBorder:
              borderContainer ? InputBorder.none : outlineInputBorder,
          disabledBorder:
              borderContainer ? InputBorder.none : outlineInputBorder,
          errorBorder:
              borderContainer ? InputBorder.none : outlineInputBorderError,
          hintStyle: hintStyle ??
              FONT_CONST.regular(
                fontStyle: FontStyle.italic,
              ),
          hintMaxLines: maxLinesHintText,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          suffixIconConstraints: BoxConstraints(maxWidth: 50),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: COLOR_CONST.cloudBurst));

  OutlineInputBorder outlineInputBorderError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: COLOR_CONST.carnation));
}
