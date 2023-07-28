import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class EmptyCollectionWidget extends StatelessWidget {
  const EmptyCollectionWidget({
    super.key,
    this.profileName,
    this.bookmark = false,
  });

  final String? profileName;
  final bool bookmark;

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
          !bookmark ? (profileName != null
              ? "$profileName has not added any posters to the collection yet. "
              : "Press 􀁍 for add poster to your collection") : "Press 􀁍 to add\na bookmark",
          style: context.textStyles.subheadlineBold!.copyWith(
            color: context.colors.textsDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
