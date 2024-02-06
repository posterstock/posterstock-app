import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CountIndicator extends StatelessWidget {
  final String description;
  final int count;

  const CountIndicator(this.description, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextOrContainer(
          text: count.toString(),
          style: context.textStyles.headline,
          emptyWidth: 35,
          emptyHeight: 20,
        ),
        const SizedBox(height: 3),
        Text(
          description,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsSecondary,
          ),
        ),
      ],
    );
  }
}

class IconCountIndicator extends StatelessWidget {
  final String asset;
  final int count;

  const IconCountIndicator(this.asset, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          asset,
          colorFilter: ColorFilter.mode(
            context.colors.iconsDefault!,
            BlendMode.srcIn,
          ),
          width: 16,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: context.textStyles.caption1!
              .copyWith(color: context.colors.textsPrimary),
        ),
      ],
    );
  }
}
