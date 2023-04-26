import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({Key? key, required this.text, this.disabled = false, this.onTap,}) : super(key: key);
  final String text;
  final bool disabled;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(33),
      child: Material(
        color: disabled ? context.colors.buttonsDisabled!.withOpacity(0.4) : context.colors.buttonsPrimary,
        child: InkWell(
          highlightColor: context.colors.textsPrimary!.withOpacity(0.2),
          onTap: disabled ? null : (onTap ?? () {}),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.5,
            ),
            child: Text(
              text,
              style: context.textStyles.calloutBold!.copyWith(
                color: context.colors.textsBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
