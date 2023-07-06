import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EmptyCollectionWidget extends StatelessWidget {
  const EmptyCollectionWidget({
    super.key,
    this.profileName,
  });

  final String? profileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/icons/empty_collection.svg'),
        const SizedBox(height: 16),
        Text(
          profileName != null ? "$profileName has not added any posters to the collection yet. " : "Press 􀁍 for add poster to your collection",
          style: context.textStyles.subheadlineBold!.copyWith(
            color: context.colors.textsDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
