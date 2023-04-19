import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PosterPage extends StatefulWidget {
  const PosterPage({Key? key, required this.post}) : super(key: key);

  final PostMovieModel post;

  @override
  State<PosterPage> createState() => _PosterPageState();
}

class _PosterPageState extends State<PosterPage> with TickerProviderStateMixin {
  AnimationController? posterController;
  late final AnimationController iconsController = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 34,
    duration: Duration.zero,
  );
  bool animating = false;
  final ScrollController scrollController = ScrollController();
  double? imageHeight;

  @override
  Widget build(BuildContext context) {
    if (posterController == null) {
      imageHeight = MediaQuery.of(context).size.height * 0.66;
      posterController = AnimationController(
          vsync: this,
          duration: Duration.zero,
          lowerBound: 36,
          upperBound: 2000);
      posterController!.animateTo(imageHeight!);
    }
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            iconsController
                .animateTo(notification.metrics.pixels - imageHeight! + 18);
            if (notification.metrics.pixels < 0) {
              posterController!
                  .animateTo(imageHeight! - notification.metrics.pixels);
            } else {
              posterController!
                  .animateTo(imageHeight! - notification.metrics.pixels);
            }
          }
          if (notification is ScrollEndNotification) {
            if (notification.metrics.pixels > imageHeight!) return true;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                int durationValue = (400 *
                        (1 -
                            (posterController!.value - imageHeight! / 2).abs() /
                                (imageHeight! / 2)))
                    .round();
                if (durationValue < 50) durationValue = 50;
                if (posterController!.value > imageHeight! * 0.5) {
                  scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: durationValue),
                    curve: Curves.linear,
                  );
                } else {
                  scrollController.animateTo(
                    imageHeight! - 18,
                    duration: Duration(milliseconds: durationValue),
                    curve: Curves.linear,
                  );
                }
              },
            );
            if (posterController!.value > imageHeight! * 0.5) {
              posterController!.animateTo(
                imageHeight!,
                duration: const Duration(milliseconds: 300),
              );
            } else {
              posterController!.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                AnimatedBuilder(
                  animation: posterController!,
                  builder: (context, child) {
                    return PosterPageAppBar(
                      posterController: posterController,
                      imageHeight: imageHeight,
                      child: child,
                    );
                  },
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              24.0,
                              16.0,
                              16.0,
                            ),
                            child: AnimatedBuilder(
                              animation: posterController!,
                              builder: (context, child) {
                                return PosterInfo(post: widget.post);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              ReactionButton(
                                iconPath: 'assets/icons/ic_heart.svg',
                                iconColor: context.colors.iconsDisabled!,
                                amount: widget.post.likes.length,
                              ),
                              const SizedBox(width: 12),
                              ReactionButton(
                                iconPath: 'assets/icons/ic_comment2.svg',
                                iconColor: context.colors.iconsDisabled!,
                                amount: widget.post.comments.length,
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ...List<Widget>.generate(
                            widget.post.comments.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: UserInfoTile(
                                      showFollowButton: false,
                                      user:
                                          widget.post.comments[index % 2].user,
                                      time:
                                          widget.post.comments[index % 2].time,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 68,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.post.comments[index % 2]
                                                  .comment,
                                              style: context
                                                  .textStyles.subheadline,
                                            ),
                                            const SizedBox(height: 12),
                                            if (index !=
                                                widget.post.comments.length - 1)
                                              Divider(
                                                height: 0.5,
                                                thickness: 0.5,
                                                color: context
                                                    .colors.fieldsDefault,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getEmptySpaceHeight(context),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            AnimatedBuilder(
              animation: posterController!,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      0,
                      (MediaQuery.of(context).padding.top + 3) *
                                  (1 - posterController!.value / imageHeight!) <
                              0
                          ? 0
                          : (MediaQuery.of(context).padding.top + 3) *
                              (1 - posterController!.value / imageHeight!)),
                  child: Transform.scale(
                    alignment: Alignment.topCenter,
                    scale: (posterController!.value / imageHeight! -
                        (3 *
                                ((imageHeight! - posterController!.value) /
                                    imageHeight!)) /
                            imageHeight!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          (imageHeight! - posterController!.value) * 0.1),
                      child: SizedBox(
                        height:
                            imageHeight! + MediaQuery.of(context).padding.top,
                        width: double.infinity,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Image.network(
                            widget.post.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SafeArea(
              child: SizedBox(
                height: 42,
                child: AnimatedBuilder(
                    animation: posterController!,
                    builder: (context, child) {
                      return Row(
                        children: [
                          CustomBackButton(
                            color: Color.lerp(
                              context.colors.iconsDefault,
                              context.colors.iconsBackground,
                              posterController!.value / imageHeight!,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SvgPicture.asset(
                              'assets/icons/ic_dots.svg',
                              colorFilter: ColorFilter.mode(
                                Color.lerp(
                                  context.colors.iconsDefault,
                                  context.colors.iconsBackground,
                                  posterController!.value / imageHeight!,
                                )!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            AnimatedBuilder(
              animation: iconsController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: posterController!,
                  builder: (context, child) {
                    double iconAddition =
                        ((imageHeight! - scrollController.offset) < 18
                                ? 18
                                : (imageHeight! - scrollController.offset)) -
                            iconsController.value;
                    return Positioned(
                      right: 16 + iconsController.value * 1.2,
                      top: 25 +
                          MediaQuery.of(context).padding.top +
                          iconAddition,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(1);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/ic_bookmarks.svg',
                              colorFilter: ColorFilter.mode(
                                context.colors.iconsDefault!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              print(1);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/ic_collection.svg',
                              colorFilter: ColorFilter.mode(
                                context.colors.iconsDefault!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                color: context.colors.backgroundsPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }

  double getEmptySpaceHeight(BuildContext context) {
    double result =
        widget.post.comments.length * 83 + MediaQuery.of(context).padding.top;
    result += 42 + 8 + 28;
    result += TextInfoService.textSize(
      widget.post.name,
      context.textStyles.title3!,
      MediaQuery.of(context).size.width - 112,
    ).height;
    result += 6;
    result += TextInfoService.textSize(
      widget.post.year.toString(),
      context.textStyles.subheadline!,
      MediaQuery.of(context).size.width,
    ).height;
    result += 24;
    result += TextInfoService.textSize(
      (widget.post.description ?? '').length > 280
          ? widget.post.description!.substring(0, 280)
          : (widget.post.description ?? ''),
      context.textStyles.subheadline!,
      MediaQuery.of(context).size.width - 32,
    ).height;
    result += 24;
    for (var comment in widget.post.comments) {
      result += TextInfoService.textSize(
        comment.comment,
        context.textStyles.subheadline!,
        MediaQuery.of(context).size.width - 84,
      ).height;
    }
    print(result);
    return MediaQuery.of(context).size.height - result < 0
        ? 0
        : MediaQuery.of(context).size.height - result;
  }
}

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

class PosterInfo extends StatelessWidget {
  const PosterInfo({
    super.key,
    required this.post,
  });

  final PostMovieModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 112,
              child: Text(
                post.name,
                style: context.textStyles.title3,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          post.year.toString(),
          style: context.textStyles.subheadline!.copyWith(
            color: context.colors.textsSecondary,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          (post.description ?? '').length > 280
              ? post.description!.substring(0, 280)
              : (post.description ?? ''),
          style: context.textStyles.callout!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
      ],
    );
  }
}
