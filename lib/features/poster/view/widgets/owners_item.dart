import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/features/NFT/models/nft_owners.dart';
import 'package:poster_stock/features/user/user_page.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class OwnersItem extends StatelessWidget {
  final NFTOwner owner;

  const OwnersItem({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => null,
      //  context.pushRoute(
      //   UserRoute(args: UserArgs(owner.posterId, owner.ownerName)),
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 37,
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              '#${owner.index}',
              style: context.textStyles.subheadline!.copyWith(
                color: context.colors.textsSecondary,
              ),
            ),
          ),
          ClipOval(
            child: owner.ownerImage.isEmpty ||
                    !owner.ownerImage.startsWith(RegExp(r'https?://'))
                ? Container(
                    width: 22.0,
                    height: 22.0,
                    color: Colors.grey,
                  )
                : CachedNetworkImage(
                    width: 22.0,
                    height: 22.0,
                    imageUrl: owner.ownerImage,
                    errorWidget: (c, o, t) => shimmer,
                    placeholderFadeInDuration: CustomDurations.cachedDuration,
                    fadeInDuration: CustomDurations.cachedDuration,
                    fadeOutDuration: CustomDurations.cachedDuration,
                  ),
          ),
          const Gap(8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colors.fieldsDefault!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    owner.ownerName,
                    style: context.textStyles.subheadline!.copyWith(
                      color: context.colors.textsPrimary,
                    ),
                  ),
                  owner.price != null
                      ? Row(
                          children: [
                            Text(owner.price?.price.toString() ?? ' ',
                                style: context.textStyles.caption2!.copyWith(
                                  color: context.colors.textsPrimary,
                                )),
                            SvgPicture.asset('assets/icons/ton.svg'),
                          ],
                        )
                      : const Gap(10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
