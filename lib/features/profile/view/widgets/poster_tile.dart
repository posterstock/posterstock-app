import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PostGridItemWidget extends StatelessWidget {
  final PostMovieModel? poster;

  const PostGridItemWidget(this.poster, {super.key});

  @override
  Widget build(BuildContext context) {
    return poster == null ? const _PosterPlaceholder() : _PosterTile(poster!);
  }
}

class _PosterTile extends StatelessWidget {
  final PostMovieModel poster;

  const _PosterTile(this.poster, {super.key});

  @override
  Widget build(BuildContext context) {
    final shimmer = ShimmerLoader(
      loaded: false,
      child: Container(color: Colors.grey),
    );
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
            child: CachedNetworkImage(
              imageUrl: poster.imagePath,
              fit: BoxFit.cover,
              placeholderFadeInDuration: Durations.cachedDuration,
              fadeInDuration: Durations.cachedDuration,
              fadeOutDuration: Durations.cachedDuration,
              placeholder: (_, __) => shimmer,
              errorWidget: (_, __, ___) => shimmer,
            ),
          ),
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

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmer = ShimmerLoader(
      loaded: false,
      child: Container(color: Colors.grey),
    );
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
            child: CachedNetworkImage(
              imageUrl: '',
              fit: BoxFit.cover,
              placeholderFadeInDuration: Durations.cachedDuration,
              fadeInDuration: Durations.cachedDuration,
              fadeOutDuration: Durations.cachedDuration,
              placeholder: (_, __) => shimmer,
              errorWidget: (_, __, ___) => shimmer,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '',
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
