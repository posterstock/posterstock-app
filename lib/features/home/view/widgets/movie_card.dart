import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../models/post_movie_model.dart';
import '../helpers/custom_bounce_physic.dart';
import '../helpers/custom_elastic_curve.dart';
import '../helpers/page_holder.dart';
import 'current_post_shower.dart';

class MovieCard extends ConsumerStatefulWidget {
  const MovieCard({
    Key? key,
    this.index,
    this.poster,
    required this.pageHolder,
  }) : super(key: key);

  final PageHolder pageHolder;
  final int? index;
  final PostMovieModel? poster;

  @override
  ConsumerState<MovieCard> createState() => MovieCardState();
}

class MovieCardState extends ConsumerState<MovieCard>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController multiplePosterController;
  PageController? pageController;
  int currentPage = 0;
  double? textHeight;
  double? titleHeight;
  bool firstRun = true;
  bool disposed = false;
  late final ScrollPhysics physics;
  List<PostMovieModel>? movie;

  @override
  void dispose() {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    physics = const HorizontalBlockedScrollPhysics();
  }

  void animatePosterToSide() {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 700),
      curve: const CustomElasticCurve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == null) {
      movie = [widget.poster!];
    } else {
      movie = ref
          .watch(homePagePostsStateHolderProvider)?[widget.index!]
          .map((e) => e as PostMovieModel)
          .toList();
    }

    getInitData();
    widget.pageHolder.page = (pageController?.page ?? 0).round();
    return SizedBox(
      height: (textHeight ?? 0) +
          58 +
          31 +
          (TextInfoService.textSizeConstWidth(
            '',
            context.textStyles.subheadlineBold!,
            MediaQuery.of(context).size.width - 140,
          ).height),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          pageController = PageController(
            initialPage: 0,
            viewportFraction: 1 +
                ((16 - controller.value) *
                    9 /
                    MediaQuery.of(context).size.width),
          )..addListener(() {
              widget.pageHolder.page = (pageController?.page ?? 0).round();
              if (pageController?.page == null) {
                return;
              }
              Future(() {
                try {
                  multiplePosterController.animateTo(
                      (pageController?.page?.toInt() ?? 0) +
                          (((pageController!.page ?? 0) * 100).toInt() % 100) /
                              100);
                } catch (e) {
                  return;
                }
              });
            });

          return Stack(
            children: [
              OverflowBox(
                maxWidth: MediaQuery.of(context).size.width +
                    72 * (controller.value < 0 ? 0 : controller.value) / 16,
                alignment: Alignment.centerLeft,
                child: PageView.builder(
                  physics: physics,
                  controller: pageController,
                  itemCount: movie?.length ?? 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: controller.value < 0 ? 0 : controller.value,
                      ),
                      child: _MovieCardPageViewContent(
                        likeCommentController: multiplePosterController,
                        onPosterTap: () {},
                        textHeight: textHeight!,
                        titleHeight: TextInfoService.textSize(
                          '',
                          context.textStyles.subheadlineBold!,
                        ).height,
                        description:
                            (movie?[index].description ?? '').length > 280
                                ? (movie?[index].description ?? '')
                                    .substring(0, 280)
                                : (movie?[index].description ?? ''),
                        movie: movie?[index],
                      ),
                    );
                  },
                ),
              ),
              if (movie != null && movie!.length > 1)
                AnimatedBuilder(
                    animation: multiplePosterController,
                    builder: (context, child) {
                      int page = multiplePosterController.value.toInt();
                      if (multiplePosterController.value -
                              multiplePosterController.value.toInt() >
                          0.5) page++;
                      return Positioned(
                        top: 0,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: context.colors.backgroundsSecondary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text('${page + 1}/${movie?.length}'),
                        ),
                      );
                    }),
              if (movie != null && movie!.length > 1)
                AnimatedBuilder(
                    animation: multiplePosterController,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 27,
                        left: 68,
                        child: CurrentPostShower(
                          length: movie!.length,
                          current: (multiplePosterController.value -
                                      multiplePosterController.value.toInt()) >
                                  0.5
                              ? multiplePosterController.value.toInt() + 1
                              : multiplePosterController.value.toInt(),
                        ),
                      );
                    })
            ],
          );
        },
      ),
    );
  }

  void getInitData() {
    if (firstRun) {
      firstRun = false;
      multiplePosterController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0),
        lowerBound: 0.0,
        upperBound: movie?.length.toDouble() ?? 1.0,
      );
      controller = AnimationController(
        vsync: this,
        lowerBound: -16.0,
        upperBound: 16.0,
        duration: const Duration(milliseconds: 300),
      );
      controller.animateTo(16.0, duration: Duration.zero);
      if (movie != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!disposed) animatePosterToSide();
        });
      }
      var description = (movie?[0].description ?? '').length > 280
          ? (movie?[0].description ?? '').substring(0, 280)
          : (movie?[0].description ?? '');
      textHeight = TextInfoService.textSizeConstWidth(
                      description,
                      context.textStyles.subheadline!,
                      MediaQuery.of(context).size.width - 84)
                  .height <
              100
          ? 100
          : TextInfoService.textSizeConstWidth(
                  description,
                  context.textStyles.subheadline!,
                  MediaQuery.of(context).size.width - 84)
              .height;
      if ((movie?.length ?? 1) > 1) {
        for (PostMovieModel i in movie!) {
          var size = TextInfoService.textSizeConstWidth(
              (i.description ?? '').length > 280
                  ? (i.description?.substring(0, 280) ?? '')
                  : (i.description ?? ''),
              context.textStyles.subheadline!,
              MediaQuery.of(context).size.width - 84);
          if (size.height > textHeight!) {
            textHeight = size.height;
          }
          if (textHeight! < 140) textHeight = 140;
        }
      }
    }
    titleHeight = TextInfoService.textSize(
      movie?[0].name ?? '',
      context.textStyles.subheadlineBold!,
    ).height;
  }
}

class _MovieCardPageViewContent extends ConsumerWidget {
  const _MovieCardPageViewContent({
    Key? key,
    required this.likeCommentController,
    required this.onPosterTap,
    this.movie,
    required this.textHeight,
    required this.titleHeight,
    required this.description,
  }) : super(key: key);
  final AnimationController likeCommentController;
  final void Function() onPosterTap;
  final PostMovieModel? movie;

  final double textHeight;
  final double titleHeight;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shimmer = ShimmerLoader(
      loaded: false,
      child: Container(
        color: Colors.grey,
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            width: 128,
            height: 193,
            child: movie?.imagePath != null
                ? CachedNetworkImage(
                    imageUrl: movie!.imagePath,
                    fit: BoxFit.cover,
                    placeholderFadeInDuration: CustomDurations.cachedDuration,
                    fadeInDuration: CustomDurations.cachedDuration,
                    fadeOutDuration: CustomDurations.cachedDuration,
                    placeholder: (context, child) {
                      return shimmer;
                    },
                    errorWidget: (context, obj, trace) {
                      return shimmer;
                    },
                  )
                : shimmer,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextOrContainer(
              text: movie?.name,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.subheadlineBold!,
              emptyWidth: 146,
              emptyHeight: 17,
              width: MediaQuery.of(context).size.width - 140,
            ),
            SizedBox(
              height: movie != null ? 5 : 8,
            ),
            TextOrContainer(
              text: movie?.year.toString(),
              style: context.textStyles.caption1!.copyWith(
                color: context.colors.textsSecondary,
              ),
              emptyWidth: 120,
              emptyHeight: 12,
            ),
            SizedBox(
              height: movie != null ? 10 : 8,
            ),
            if (movie != null)
              SizedBox(
                height: textHeight +
                    titleHeight -
                    TextInfoService.textSize(
                      movie?.name ?? '',
                      context.textStyles.subheadlineBold!,
                    ).height,
                width: MediaQuery.of(context).size.width - 84,
                child: Text(
                  description,
                  style: context.textStyles.subheadline!,
                ),
              ),
            const SizedBox(
              height: 14,
            ),
            if (movie != null)
              AnimatedBuilder(
                animation: likeCommentController,
                builder: (context, child) {
                  double opacity = (1 -
                      (likeCommentController.value -
                              likeCommentController.value.toInt()) *
                          4);
                  if ((likeCommentController.value -
                          likeCommentController.value.toInt()) >
                      0.8) {
                    opacity = ((likeCommentController.value -
                                likeCommentController.value.toInt()) -
                            0.8) *
                        6;
                  }
                  if (opacity < 0) opacity = 0;
                  if (opacity > 1) opacity = 1;
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 84,
                  child: Row(
                    children: [
                      const Spacer(),
                      LikeButton(
                        liked: movie?.liked ?? false,
                        amount: movie?.likes ?? 0,
                        onTap: () {
                          if (movie != null) {
                            ref
                                .read(homePagePostsControllerProvider)
                                .setLikeId(movie!.id, !movie!.liked);
                            ref
                                .read(searchPostsStateHolderProvider.notifier)
                                .setLikeId(movie!.id, !movie!.liked);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ReactionButton(
                        iconPath: 'assets/icons/ic_comment2.svg',
                        iconColor: context.colors.iconsDisabled!,
                        amount: movie?.comments,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class LikeButton extends ConsumerWidget {
  const LikeButton({
    super.key,
    required this.liked,
    required this.amount,
    required this.onTap,
  });

  final bool liked;
  final int amount;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReactionButton(
      iconPath: liked
          ? 'assets/icons/ic_heart_filled.svg'
          : 'assets/icons/ic_heart.svg',
      iconColor:
          liked ? context.colors.buttonsError! : context.colors.iconsDisabled!,
      amount: amount,
      onTap: onTap,
    );
  }
}
