import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ProfileAppbar extends StatelessWidget {
  // final UserDetailsModel profile;
  final String title;
  final VoidCallback? onMenuClick;
  final VoidCallback? onBack;
  //TODO: remove after migration
  final Color? bg;

  const ProfileAppbar(
    this.title, {
    this.onMenuClick,
    this.onBack,
    this.bg = Colors.transparent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 65,
          child: onBack == null
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack?.call,
                    child: Container(
                      // color: Colors.transparent,
                      color: bg,
                      padding: const EdgeInsets.only(
                        left: 7,
                        right: 31,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/back_icon.svg',
                        width: 18,
                        colorFilter: ColorFilter.mode(
                          context.colors.iconsDefault!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        const Spacer(),
        Text(
          title,
          style: context.textStyles.bodyBold,
        ),
        const Spacer(),
        GestureDetector(
          onTap: onMenuClick?.call,
          child: Container(
            width: 65,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  'assets/icons/ic_dots_vertical.svg',
                  width: 12,
                  colorFilter: ColorFilter.mode(
                    context.colors.iconsDefault!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
