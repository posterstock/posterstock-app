import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class MenuItemList extends StatelessWidget {
  final String text;
  final String image;
  final Function() onTap;
  final bool isRed;

  const MenuItemList({
    super.key,
    required this.text,
    required this.image,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        const Gap(15),
        InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              children: [
                const Gap(20),
                SvgPicture.asset(
                  'assets/icons/$image.svg',
                  width: 22,
                  colorFilter: ColorFilter.mode(
                    isRed
                        ? context.colors.textsError!
                        : context.colors.textsPrimary!,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(15),
                Text(
                  text,
                  style: context.textStyles.bodyRegular!.copyWith(
                    color: isRed
                        ? context.colors.textsError
                        : context.colors.textsPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(15),
        if (!isRed)
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
      ]),
    );
  }
}
