import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ReactionButton extends StatelessWidget {
  const ReactionButton({
    super.key,
    required this.iconPath,
    required this.iconColor,
    this.amount,
    this.onTap,
  });

  final String iconPath;
  final Color iconColor;
  final int? amount;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Material(
        color: context.colors.backgroundsSecondary!,
        child: InkWell(
          highlightColor: context.colors.textsDisabled!.withOpacity(0.2),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 20,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                if (amount != null && amount != 0)
                  const SizedBox(
                    width: 4,
                  ),
                if (amount != null && amount != 0)
                  Text(
                    amount.toString(),
                    style: context.textStyles.footNote!.copyWith(
                      color: context.colors.textsDisabled,
                    ),
                  ),
                if (amount != null && amount != 0)
                  const SizedBox(
                    width: 2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
