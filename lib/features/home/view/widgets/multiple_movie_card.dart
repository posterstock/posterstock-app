import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/view/widgets/movie_card.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class MultipleMovieCard extends ConsumerWidget {
  const MultipleMovieCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final MultiplePostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shimmer = ShimmerLoader(
      child: Container(
        color: context.colors.backgroundsSecondary,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 68.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: SizedBox(
              height: 163,
              width: double.infinity,
              child: Image.network(
                post.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, obj, trace) {
                  return shimmer;
                },
                loadingBuilder: (context, child, event) {
                  if (event?.cumulativeBytesLoaded !=
                      event?.expectedTotalBytes) {
                    return shimmer;
                  }
                  return child;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              post.name,
              style: context.textStyles.calloutBold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            (post.description ?? '').length > 140
                ? post.description!.substring(0, 140)
                : (post.description ?? ''),
            style: context.textStyles.callout!.copyWith(
              color: context.colors.textsPrimary,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Spacer(),
              LikeButton(
                liked: post.liked,
                amount: post.likes,
                onTap: () {
                  ref
                      .read(homePagePostsControllerProvider)
                      .setLikeIdList(post.id, !(post.liked));
                },
              ),
              const SizedBox(
                width: 12,
              ),
              ReactionButton(
                iconPath: 'assets/icons/ic_comment2.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: post.comments,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
