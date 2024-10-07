import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/movie_card.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/poster/view/widgets/buy_nft_field.dart';
import 'package:poster_stock/features/poster/view/widgets/row_with_toninfo.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterPageAppBar extends StatelessWidget {
  const PosterPageAppBar({
    super.key,
    required this.posterController,
    required this.imageHeight,
    this.child,
  });

  final AnimationController? posterController;
  final double? imageHeight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: posterController!.value < imageHeight! * 0.5 &&
                Theme.of(context).brightness == Brightness.light
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: posterController!.value < imageHeight! * 0.5 &&
                Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      backgroundColor: context.colors.backgroundsPrimary,
      elevation: 0,
      collapsedHeight: 42,
      toolbarHeight: 42,
      expandedHeight: (posterController!.value < imageHeight!
                  ? imageHeight!
                  : posterController!.value) >
              imageHeight!
          ? imageHeight!
          : (posterController!.value < imageHeight!
              ? imageHeight!
              : posterController!.value),
      leading: const SizedBox(),
      flexibleSpace: FlexibleSpaceBarSettings(
        toolbarOpacity: 1,
        currentExtent: (posterController!.value < imageHeight!
                ? imageHeight!
                : posterController!.value) +
            MediaQuery.of(context).viewPadding.top,
        maxExtent: (posterController!.value < imageHeight!
                ? imageHeight!
                : posterController!.value) +
            MediaQuery.of(context).viewPadding.top,
        isScrolledUnder: false,
        minExtent: 42,
        child: child ?? const SizedBox(),
      ),
    );
  }
}

class PosterInfo extends ConsumerWidget {
  const PosterInfo({
    super.key,
    required this.likes,
    required this.comments,
    required this.liked,
  });

  final int likes;
  final int comments;
  final bool liked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PostMovieModel? post = ref.watch(posterStateHolderProvider);
    final comments = ref.watch(commentsStateHolderProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  post == null ? null : MediaQuery.of(context).size.width - 112,
              child: ShimmerLoader(
                loaded: post != null,
                child: TextOrContainer(
                  emptyWidth: 160,
                  emptyHeight: 20,
                  text: post?.name ?? '',
                  style: context.textStyles.title3,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        ShimmerLoader(
          loaded: post != null,
          child: TextOrContainer(
            emptyWidth: 100,
            emptyHeight: 20,
            text: post?.year.toString(),
            style: context.textStyles.subheadline!.copyWith(
              color: context.colors.textsSecondary,
            ),
          ),
        ),
        const Gap(16),
        Text(
          (post?.description ?? '').length > 280
              ? post!.description!.substring(0, 280)
              : (post?.description ?? ''),
          style: context.textStyles.callout!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const Gap(16),
        Row(
          children: [
            if (post?.isNft ?? false) TonInfo(post: post!),
            const Spacer(),
            LikeButton(
              liked: (post?.liked ?? liked),
              amount: (post?.likes == null ? likes : post!.likes),
              onTap: () {
                ref
                    .read(homePagePostsControllerProvider)
                    .setLikeId(post!.id, !(post.liked));
                ref.read(posterStateHolderProvider.notifier).updateState(
                      post.copyWith(
                        liked: !(post.liked),
                        likes: post.liked ? post.likes - 1 : post.likes + 1,
                      ),
                    );
              },
            ),
            const Gap(12),
            ReactionButton(
              iconPath: 'assets/icons/ic_comment2.svg',
              iconColor: context.colors.iconsDisabled!,
              amount: (comments?.length ?? this.comments),
              onTap: () {},
            ),
          ],
        ),
        if (post != null && post.isSale) BuyNftField(post: post),
      ],
    );
  }
}
