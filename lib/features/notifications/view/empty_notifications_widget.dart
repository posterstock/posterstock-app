import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_empty_nots.svg',
            colorFilter: ColorFilter.mode(
              context.colors.iconsDisabled!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'At the moment,\nyou have no notifications',
            style: context.textStyles.subheadlineBold!.copyWith(
              color: context.colors.textsDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
