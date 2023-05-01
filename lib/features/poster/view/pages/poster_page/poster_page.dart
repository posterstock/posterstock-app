import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/helpers/custom_bounce_physic.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../../common/helpers/hero_dialog_route.dart';
import '../../../../../common/widgets/app_text_button.dart';

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
          FocusScope.of(context).unfocus();
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
            if (notification.metrics.pixels > imageHeight!) return false;
            if (notification.metrics.pixels < 0) return false;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                int durationValue = (200 *
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
                                return PosterInfo(
                                  post: widget.post,
                                );
                              },
                            ),
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
                                      horizontal: 16.0,
                                    ),
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
                            height: getEmptySpaceHeightForSingleMovie(context) <
                                    56 + MediaQuery.of(context).padding.bottom
                                ? 56 + MediaQuery.of(context).padding.bottom
                                : getEmptySpaceHeightForSingleMovie(context),
                          ),
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
                  child: Stack(
                    children: [
                      Transform.scale(
                        alignment: Alignment.topCenter,
                        scale: (posterController!.value / imageHeight! -
                            (3 *
                                    ((imageHeight! - posterController!.value) /
                                        imageHeight!)) /
                                imageHeight!),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  (imageHeight! - posterController!.value) *
                                      0.1),
                              child: SizedBox(
                                height: imageHeight! +
                                    MediaQuery.of(context).padding.top,
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    if (FocusScope.of(context)
                                            .focusedChild
                                            ?.hasPrimaryFocus ??
                                        false) {
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      Navigator.push(
                                        context,
                                        HeroDialogRoute(builder: (context) {
                                          return ImageDialog(
                                            image: Image.network(
                                              widget.post.imagePath,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }),
                                      );
                                    }
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Hero(
                                      tag: 'image',
                                      child: Image.network(
                                        widget.post.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Opacity(
                                opacity:
                                    (posterController!.value / imageHeight!) > 1
                                        ? 1
                                        : posterController!.value /
                                            imageHeight!,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.5),
                                          ]),
                                      borderRadius: BorderRadius.circular(
                                          (imageHeight! -
                                                  posterController!.value) *
                                              0.1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 16,
                        right: 16,
                        child: SizedBox(
                          //ignoring: true,
                          child: Transform.translate(
                            offset: Offset(
                                0, -imageHeight! + posterController!.value),
                            child: Transform.scale(
                              alignment: Alignment.topCenter,
                              scale: (posterController!.value / imageHeight! -
                                          (3 *
                                                  ((imageHeight! -
                                                          posterController!
                                                              .value) /
                                                      imageHeight!)) /
                                              imageHeight!) >
                                      1
                                  ? 1
                                  : (posterController!.value / imageHeight! -
                                      (3 *
                                              ((imageHeight! -
                                                      posterController!.value) /
                                                  imageHeight!)) /
                                          imageHeight!),
                              child: Opacity(
                                opacity:
                                    (posterController!.value / imageHeight!) > 1
                                        ? 1
                                        : posterController!.value /
                                            imageHeight!,
                                child: child!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: UserInfoTile(
                user: widget.post.author,
                time: widget.post.time,
                darkBackground: true,
                showSettings: false,
                showFollowButton: false,
              ),
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
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CommentTextField(),
            )
          ],
        ),
      ),
    );
  }

  double getEmptySpaceHeightForSingleMovie(BuildContext context) {
    double result =
        widget.post.comments.length * 80 + MediaQuery.of(context).padding.top;
    result += 42 + 8 + 44;
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

class CommentTextField extends StatefulWidget {
  const CommentTextField({
    super.key,
  });

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  final FocusNode focus = FocusNode();
  final GlobalKey key = GlobalKey();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    focus.addListener(() {
      setState(() {});
    });
    return Column(
      children: [
        Divider(
          height: 0.5,
          thickness: 0.5,
          color: context.colors.fieldsDefault,
        ),
        Container(
          height: focus.hasFocus
              ? null
              : 56 + MediaQuery.of(context).padding.bottom,
          color: context.colors.backgroundsPrimary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              key: key,
              maxLines: null,
              focusNode: focus,
              controller: controller,
              cursorWidth: 1,
              cursorColor: context.colors.textsAction,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.textReply,
                hintStyle: context.textStyles.callout!.copyWith(
                  color: context.colors.textsDisabled,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        if (focus.hasFocus)
          Container(
            height: 56,
            color: context.colors.backgroundsPrimary,
            child: Row(
              children: [
                const Spacer(),
                Text(
                  '${controller.text.length}/140',
                  style: context.textStyles.footNote!.copyWith(
                    color: controller.text.length > 140
                        ? context.colors.textsError
                        : context.colors.textsDisabled,
                  ),
                ),
                const SizedBox(width: 12),
                AppTextButton(
                  text: AppLocalizations.of(context)!.reply,
                  disabled:
                      controller.text.isEmpty || controller.text.length > 140,
                ),
                const SizedBox(width: 16),
              ],
            ),
          )
      ],
    );
  }
}

class ImageDialog extends StatefulWidget {
  const ImageDialog({
    super.key,
    required this.image,
  });

  final Widget image;

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog>
    with SingleTickerProviderStateMixin {
  ScrollController? controller;
  late final AnimationController animController;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );
    animController.animateTo(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller ??= ScrollController();
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(animController.value),
          insetPadding: EdgeInsets.zero,
          child: child,
        );
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) {
          if (controller!.offset.abs() >
              (MediaQuery.of(context).size.height * 0.3)) {
            Navigator.pop(context);
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              animController.animateTo(
                1 -
                    (notification.metrics.pixels).abs() /
                        (MediaQuery.of(context).size.height * 0.3),
              );
            }
            return false;
          },
          child: Stack(
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                          0, controller!.hasClients ? -controller!.offset : 0),
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: 'image',
                    child: widget.image,
                  ),
                ),
              ),
              ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: CustomBouncePhysic(),
                ),
                controller: controller,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Spacer(),
            ReactionButton(
              iconPath: 'assets/icons/ic_heart.svg',
              iconColor: context.colors.iconsDisabled!,
              amount: post.likes.length,
            ),
            const SizedBox(width: 12),
            ReactionButton(
              iconPath: 'assets/icons/ic_comment2.svg',
              iconColor: context.colors.iconsDisabled!,
              amount: post.comments.length,
            ),
          ],
        ),
      ],
    );
  }
}
