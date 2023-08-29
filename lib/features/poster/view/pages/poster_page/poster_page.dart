import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_likes_state_holder.dart';
import 'package:poster_stock/features/home/view/helpers/custom_bounce_physic.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/poster/controller/comments_controller.dart';
import 'package:poster_stock/features/poster/model/comment.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../../common/helpers/hero_dialog_route.dart';
import '../../../../../common/widgets/app_text_button.dart';
import '../../../../home/view/widgets/movie_card.dart';

@RoutePage()
class PosterPage extends ConsumerStatefulWidget {
  const PosterPage({
    @PathParam('id') this.postId = 0,
    @PathParam('username') this.username = 'profile',
    Key? key,
    this.likes = 0,
    this.liked = false,
    this.comments = 0,
  }) : super(key: key);

  final int postId;
  final int likes;
  final int comments;
  final bool liked;
  final String username;

  @override
  ConsumerState<PosterPage> createState() => _PosterPageState();
}

class _PosterPageState extends ConsumerState<PosterPage>
    with TickerProviderStateMixin {
  AnimationController? posterController;
  late final AnimationController iconsController = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 34,
    duration: Duration.zero,
  );
  final ScrollController scrollController = ScrollController();
  PostMovieModel? post;
  double? imageHeight;
  double velocity = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      ref.read(commentsControllerProvider).clear();
    });
  }

  @override
  void didChangeDependencies() {
    print('upd');
    super.didChangeDependencies();
  }

  void jumpToEnd({bool? up}) {
    if (scrollController.offset == 0 ||
        scrollController.offset == imageHeight! - 18) return;
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        int durationValue = (200 *
            (1 -
                (posterController!.value - imageHeight! / 2).abs() /
                    (imageHeight! / 2)))
            .round();
        if (durationValue < 150) durationValue = 150;
        if (up == false ||
            posterController!.value > imageHeight! * 0.5 && up != true) {
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
    if (up == false ||
        posterController!.value > imageHeight! * 0.5 && up != true) {
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

  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(posterStateHolderProvider);
    final comments = ref.watch(commentsStateHolderProvider);
    if (post == null) {
      Future(() async {
        RouteData? el;
        try {
          el = AutoRouter
              .of(context)
              .stackData
              .lastWhere((element) => element.route.path == '/:username/:id');
        } catch (e) {
          el = null;
        }
        if (el == null) return;
        ref
            .read(commentsControllerProvider)
            .getPost(el!.pathParams.getInt('id'));
        ref.read(commentsControllerProvider).updateComments(
            el!.pathParams.getInt('id'));
      });
    }
    if (posterController == null) {
      imageHeight = MediaQuery
          .of(context)
          .size
          .height * 0.66;
      posterController = AnimationController(
          vsync: this,
          duration: Duration.zero,
          lowerBound: 36,
          upperBound: 2000);
      posterController!.animateTo(imageHeight!);
    }
    return WillPopScope(
      onWillPop: () async {
        ref.read(commentsControllerProvider).clear();
        return true;
      },
      child: Listener(
        onPointerUp: (details) {
          if (scrollController.offset > imageHeight!) return;
          if (scrollController.offset < 0) return;
          if (velocity > 15) {
            jumpToEnd(up: false);
          } else if (velocity < -13) {
            jumpToEnd(up: true);
          } else {
            jumpToEnd();
          }
        },
        child: Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              FocusScope.of(context).unfocus();
              if (notification is ScrollUpdateNotification) {
                velocity = notification.dragDetails?.delta.dy ?? 0;
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
                jumpToEnd();
              }
              return true;
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
                                      likes: widget.likes,
                                      comments: widget.comments,
                                      liked: widget.liked,
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
                                comments?.length ?? 0,
                                    (index) =>
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: UserInfoTile(
                                              showFollowButton: false,
                                              user: comments![index].model,
                                              controller: scrollController,
                                              time: comments[index].time,
                                              behavior: HitTestBehavior
                                                  .translucent,
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
                                                      comments[index].text ??
                                                          '',
                                                      style: context
                                                          .textStyles
                                                          .subheadline,
                                                    ),
                                                    const SizedBox(height: 12),
                                                    if (index !=
                                                        comments.length - 1)
                                                      Divider(
                                                        height: 0.5,
                                                        thickness: 0.5,
                                                        color: context
                                                            .colors
                                                            .fieldsDefault,
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
                                height: getEmptySpaceHeightForSingleMovie(
                                    context, comments) <
                                    56 +
                                        MediaQuery
                                            .of(context)
                                            .padding
                                            .bottom
                                    ? 56 + MediaQuery
                                    .of(context)
                                    .padding
                                    .bottom
                                    : getEmptySpaceHeightForSingleMovie(
                                    context, comments),
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
                          (MediaQuery
                              .of(context)
                              .padding
                              .top + 3) *
                              (1 -
                                  posterController!.value /
                                      imageHeight!) <
                              0
                              ? 0
                              : (MediaQuery
                              .of(context)
                              .padding
                              .top + 3) *
                              (1 - posterController!.value / imageHeight!)),
                      child: Stack(
                        children: [
                          Transform.scale(
                            alignment: Alignment.topCenter,
                            scale: (posterController!.value / imageHeight! -
                                (3 *
                                    ((imageHeight! -
                                        posterController!.value) /
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
                                        MediaQuery
                                            .of(context)
                                            .padding
                                            .top,
                                    width: double.infinity,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (FocusScope
                                            .of(context)
                                            .focusedChild
                                            ?.hasPrimaryFocus ??
                                            false) {
                                          FocusScope.of(context).unfocus();
                                        } else {
                                          if (post == null) return;
                                          Navigator.push(
                                            context,
                                            HeroDialogRoute(builder: (context) {
                                              if (post == null) {
                                                return SizedBox(
                                                  width: 300,
                                                  height: 400,
                                                  child: shimmer,
                                                );
                                              }
                                              return ImageDialog(
                                                image: Image.network(
                                                  post!.imagePath,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (context, obj, trace) {
                                                    return SizedBox(
                                                      height: 300,
                                                      width: 200,
                                                      child: shimmer,
                                                    );
                                                  },
                                                  loadingBuilder:
                                                      (context, child, event) {
                                                    if (event
                                                        ?.cumulativeBytesLoaded !=
                                                        event
                                                            ?.expectedTotalBytes) {
                                                      return SizedBox(
                                                        height: 300,
                                                        width: 200,
                                                        child: shimmer,
                                                      );
                                                    }
                                                    return child;
                                                  },
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
                                            post?.imagePath ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, obj, trace) {
                                              return shimmer;
                                            },
                                            loadingBuilder:
                                                (context, child, event) {
                                              if (event
                                                  ?.cumulativeBytesLoaded !=
                                                  event?.expectedTotalBytes) {
                                                return shimmer;
                                              }
                                              return child;
                                            },
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
                                    opacity: (posterController!.value /
                                        imageHeight!) >
                                        1
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
                                  scale: (posterController!.value /
                                      imageHeight! -
                                      (3 *
                                          ((imageHeight! -
                                              posterController!
                                                  .value) /
                                              imageHeight!)) /
                                          imageHeight!) >
                                      1
                                      ? 1
                                      : (posterController!.value /
                                      imageHeight! -
                                      (3 *
                                          ((imageHeight! -
                                              posterController!
                                                  .value) /
                                              imageHeight!)) /
                                          imageHeight!),
                                  child: Opacity(
                                    opacity: (posterController!.value /
                                        imageHeight!) >
                                        1
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
                  child: post == null
                      ? const SizedBox()
                      : UserInfoTile(
                    user: post!.author,
                    time: post!.time,
                    controller: scrollController,
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
                              addOnTap: () async {
                                await ref
                                    .read(commentsControllerProvider)
                                    .clear();
                              },
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: PosterActionsDialog(),
                                        ),
                                      ),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                            ),
                          ],
                        );
                      },
                    ),
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
                                : (imageHeight! -
                                scrollController.offset)) -
                                iconsController.value;
                        return Positioned(
                          right: (16 + iconsController.value * 1.2)
                              .toInt()
                              .toDouble(),
                          top: (25 +
                              MediaQuery
                                  .of(context)
                                  .padding
                                  .top +
                              iconAddition).toInt().toDouble(),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(1);
                                },
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset(
                                      'assets/images/ic_bookmarks.png',
                                      color:
                                      context.colors.iconsDefault!,
                                      colorBlendMode: BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //TODO dialog
                                },
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset(
                                    'assets/images/ic_collection.png',
                                    color:
                                    context.colors.iconsDefault!,
                                    colorBlendMode: BlendMode.srcIn,
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
                if (post != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CommentTextField(id: post!.id),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getEmptySpaceHeightForSingleMovie(BuildContext context,
      List<Comment>? comments) {
    double result =
        (comments?.length ?? 0) * 80 + MediaQuery
            .of(context)
            .padding
            .top;
    result += 28 + 8 + 44;
    result += TextInfoService
        .textSizeConstWidth(
      post?.name ?? '',
      context.textStyles.title3!,
      MediaQuery
          .of(context)
          .size
          .width - 112,
    )
        .height;
    result += 6;
    result += TextInfoService
        .textSizeConstWidth(
      post?.year.toString() ?? '',
      context.textStyles.subheadline!,
      MediaQuery
          .of(context)
          .size
          .width,
    )
        .height;
    result += 24;
    if (post != null) {
      result += TextInfoService
          .textSizeConstWidth(
        (post!.description ?? '').length > 280
            ? post!.description!.substring(0, 280)
            : (post!.description ?? ''),
        context.textStyles.subheadline!,
        MediaQuery
            .of(context)
            .size
            .width - 32,
      )
          .height;
    }
    result += 24;
    for (var comment in comments ?? <Comment>[]) {
      result += TextInfoService
          .textSizeConstWidth(
        comment.text,
        context.textStyles.subheadline!,
        MediaQuery
            .of(context)
            .size
            .width - 84,
      )
          .height;
    }
    return MediaQuery
        .of(context)
        .size
        .height - result < 0
        ? 0
        : MediaQuery
        .of(context)
        .size
        .height - result;
  }
}

class CommentTextField extends ConsumerStatefulWidget {
  const CommentTextField({
    super.key,
    required this.id,
    this.isList = false,
  });

  final int id;
  final bool isList;

  @override
  ConsumerState<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends ConsumerState<CommentTextField> {
  final FocusNode focus = FocusNode();
  final GlobalKey key = GlobalKey();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    focus.addListener(() {
      setState(() {});
    });
    return NotificationListener(
      onNotification: (not) {
        return true;
      },
      child: Column(
        children: [
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
          Container(
            height:
            focus.hasFocus && MediaQuery
                .of(context)
                .viewInsets
                .bottom != 0
                ? null
                : 56 + MediaQuery
                .of(context)
                .padding
                .bottom,
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
            KeyboardVisibilityBuilder(builder: (context, visible) {
              if (!visible) return SizedBox();
              return Container(
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
                      disabled: controller.text.isEmpty ||
                          controller.text.length > 140,
                      onTap: () {
                        if (!widget.isList) {
                          ref
                              .read(commentsControllerProvider)
                              .postComment(widget.id, controller.text);
                          ref
                              .read(homePagePostsControllerProvider)
                              .addComment(widget.id);
                        } else {
                          ref
                              .read(commentsControllerProvider)
                              .postCommentList(widget.id, controller.text);
                          ref
                              .read(homePagePostsControllerProvider)
                              .addCommentList(widget.id);
                        }
                        controller.clear();
                        focus.unfocus();
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              );
            })
        ],
      ),
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
              (MediaQuery
                  .of(context)
                  .size
                  .height * 0.3)) {
            Navigator.pop(context);
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              animController.animateTo(
                1 -
                    (notification.metrics.pixels).abs() /
                        (MediaQuery
                            .of(context)
                            .size
                            .height * 0.3),
              );
            }
            return true;
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
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
            Theme
                .of(context)
                .brightness == Brightness.light
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: posterController!.value < imageHeight! * 0.5 &&
            Theme
                .of(context)
                .brightness == Brightness.light
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
            MediaQuery
                .of(context)
                .viewPadding
                .top,
        maxExtent: (posterController!.value < imageHeight!
            ? imageHeight!
            : posterController!.value) +
            MediaQuery
                .of(context)
                .viewPadding
                .top,
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
    final post = ref.watch(posterStateHolderProvider);
    final comments = ref.watch(commentsStateHolderProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
              post == null ? null : MediaQuery
                  .of(context)
                  .size
                  .width - 112,
              child: ShimmerLoader(
                loaded: post != null,
                child: TextOrContainer(
                  emptyWidth: 160,
                  emptyHeight: 20,
                  text: post?.name,
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
        const SizedBox(
          height: 16,
        ),
        Text(
          (post?.description ?? '').length > 280
              ? post!.description!.substring(0, 280)
              : (post?.description ?? ''),
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
            const SizedBox(width: 12),
            ReactionButton(
              iconPath: 'assets/icons/ic_comment2.svg',
              iconColor: context.colors.iconsDisabled!,
              amount: (comments?.length ?? this.comments),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class PosterActionsDialog extends ConsumerWidget {
  const PosterActionsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 490,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 384,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'Movie',
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              //TODO REMOVE THIS IF THIS MOVIE NOT IN COLLECTION
                              child: Text(
                                'Add to list',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Open Wikipedia',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Where to watch',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'Poster',
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Follow',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Share',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print(1);
                            },
                            child: Center(
                              child: Text(
                                'Report',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: context.textStyles.bodyRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
