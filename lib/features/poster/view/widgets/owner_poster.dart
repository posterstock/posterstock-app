import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/features/NFT/models/nft_owners.dart';
import 'package:poster_stock/features/user/user_page.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterOwnerWidget extends StatelessWidget {
  final PosterOwner posterOwner;

  const PosterOwnerWidget({
    super.key,
    required this.posterOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: posterOwner.collectionOwnerImage.isEmpty ||
                        !posterOwner.collectionOwnerImage
                            .startsWith(RegExp(r'https?://'))
                    ? Container(
                        width: 40.0,
                        height: 40.0,
                        color: Colors.grey,
                      )
                    : CachedNetworkImage(
                        width: 40.0,
                        height: 40.0,
                        imageUrl: posterOwner.collectionOwnerImage,
                        errorWidget: (c, o, t) => shimmer,
                        placeholderFadeInDuration:
                            CustomDurations.cachedDuration,
                        fadeInDuration: CustomDurations.cachedDuration,
                        fadeOutDuration: CustomDurations.cachedDuration,
                      ),
              ),
              const Gap(5),
              Text(
                posterOwner.collectionOwnerName,
                style: context.textStyles.bodyBold,
              ),
              const Gap(5),
              SvgPicture.asset('assets/icons/art.svg'),
            ],
          ),
          const Gap(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                posterOwner.title,
                style: context.textStyles.caption2!.copyWith(
                  color: context.colors.textsSecondary,
                ),
              ),
              const Gap(4),
              Text(
                ' \u00B7 ${posterOwner.startYear}${posterOwner.endYear != 0 ? ' - ${posterOwner.endYear}' : ''}',
                style: context.textStyles.caption2!.copyWith(
                  color: context.colors.textsSecondary,
                ),
              ),
            ],
          ),
          // const Gap(16),
        ],
      ),
    );
  }
}
