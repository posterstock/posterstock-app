import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

abstract class BaseEmptyCollectionWidget extends StatelessWidget {
  const BaseEmptyCollectionWidget({super.key});

  abstract final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/empty_collection.svg',
          colorFilter: ColorFilter.mode(
            context.colors.iconsDisabled!,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: context.textStyles.subheadlineBold!.copyWith(
            color: context.colors.textsDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
