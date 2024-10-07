import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/peek_pop/peek_and_pop_dialog.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PostGridItemWidget extends StatelessWidget {
  final PostMovieModel? poster;
  final VoidCallback? callback;

  const PostGridItemWidget(this.poster, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return poster == null
        ? const PosterPlaceholder()
        : PeekAndPopDialog(
            onTap: () => callback?.call(),
            dialog: Material(
              color: Colors.transparent,
              child: PosterImageDialog(
                imagePath: poster!.imagePath,
                name: poster!.name,
                year: poster!.year.toString(),
                description: poster!.description,
              ),
            ),
            child: _PosterTile(poster!),
          );
  }
}

class _PosterTile extends StatelessWidget {
  final PostMovieModel poster;

  const _PosterTile(this.poster);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: poster.isNft ? nftGradientBoxBorder() : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  color: context.colors.backgroundsSecondary,
                  width: double.infinity,
                  height:
                      ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) /
                              3) /
                          2 *
                          3,
                  child: CachedNetworkImage(
                    imageUrl: poster.imagePath,
                    fit: BoxFit.cover,
                    placeholderFadeInDuration: CustomDurations.cachedDuration,
                    fadeInDuration: CustomDurations.cachedDuration,
                    fadeOutDuration: CustomDurations.cachedDuration,
                    placeholder: (_, __) => _shimmer,
                    errorWidget: (_, __, ___) => _shimmer,
                  ),
                ),
              ),
            ),
            if (poster.isNft)
              Positioned(
                bottom: 5,
                left: 5,
                child: SvgPicture.asset(
                  'assets/icons/ton.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            if (poster.isSale)
              Positioned(
                top: 5,
                right: 5,
                child: SvgPicture.asset(
                  'assets/icons/sale.svg',
                  width: 16,
                  height: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          poster.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          poster.year,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}

class PosterPlaceholder extends StatelessWidget {
  const PosterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: context.colors.backgroundsSecondary,
            width: double.infinity,
            height:
                ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) / 3) /
                    2 *
                    3,
            child: _shimmer,
          ),
        ),
        const SizedBox(height: 8),
        Text('', style: context.textStyles.caption2),
        const SizedBox(height: 4),
        Text('', style: context.textStyles.caption1),
      ],
    );
  }
}

class AdaptivePosterPlaceholder extends StatelessWidget {
  const AdaptivePosterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ShimmerLoader(
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('', style: context.textStyles.caption2),
        const SizedBox(height: 4),
        Text('', style: context.textStyles.caption1),
      ],
    );
  }
}

final _shimmer = ShimmerLoader(
  loaded: false,
  child: Container(color: Colors.grey),
);
