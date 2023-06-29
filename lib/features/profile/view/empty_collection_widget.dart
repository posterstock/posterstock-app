import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EmptyCollectionWidget extends StatelessWidget {
  const EmptyCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/icons/empty_collection.svg'),
        const SizedBox(height: 16),
        Text(
          "Press 􀁍 for add poster to your collection",
          style: context.textStyles.subheadlineBold!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}
