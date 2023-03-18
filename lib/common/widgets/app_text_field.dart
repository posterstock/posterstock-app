import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../themes/constants.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.hint,
    this.onSubmitted,
    this.controller,
  }) : super(key: key);
  final String hint;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final defaultBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: context.colors.fieldsDefault!,
      ),
      borderRadius: BorderRadius.circular(
        Constants.borderRadiusField,
      ),
    );
    return SizedBox(
      height: Constants.fieldsAndButtonsHeight,
      child: TextField(
        cursorColor: context.colors.textsPrimary!,
        style:
            context.textStyles.callout!.copyWith(color: context.colors.textsPrimary!),
        onSubmitted: onSubmitted,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.colors.backgroundsSecondary,
          enabledBorder: defaultBorder,
          focusedBorder: defaultBorder,
          border: defaultBorder,
          hintText: hint,
          hintStyle: context.textStyles.callout,
        ),
      ),
    );
  }
}
