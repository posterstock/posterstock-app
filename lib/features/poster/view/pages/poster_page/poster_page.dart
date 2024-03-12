import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/helpers/hero_dialog_route.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/create_poster/controller/create_poster_controller.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';
import 'package:poster_stock/features/create_poster/view/create_poster_dialog.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/helpers/custom_bounce_physic.dart';
import 'package:poster_stock/features/home/view/widgets/movie_card.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/poster/controller/comments_controller.dart';
import 'package:poster_stock/features/poster/model/comment.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/page_transition_controller_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/poster/view/widgets/add_to_list_dialog.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  int disabled = 1;
  bool popped = false;

  @override
  void initState() {
    super.initState();
    Future(() async {
      ref.read(commentsControllerProvider).clear();
      if (ref.read(pageTransitionControllerStateHolder)?.value == 1) {
        ref.read(pageTransitionControllerStateHolder)!.animateTo(
              0,
              duration: const Duration(milliseconds: 200),
            );
      }
      final rtr = ref.watch(router);
      rtr!.addListener(() {
        if (!mounted) return;
        if (rtr.topRoute.name == 'PosterRoute') {
          disabled = 1;
          if (ref.read(pageTransitionControllerStateHolder)?.value == 1) {
            ref.read(pageTransitionControllerStateHolder)!.animateTo(
                  0,
                  duration: Duration.zero,
                );
          }
        } else if (rtr.topRoute.name != 'PosterRoute' &&
            rtr.stack.length - 2 >= 0 &&
            rtr.stack[rtr.stack.length - 2].name == 'PosterRoute') {
          Future.delayed(const Duration(milliseconds: 400), () {
            disabled = 0;
            if (!mounted) return;
            setState(() {});
          });
        } else {
          Future.delayed(const Duration(milliseconds: 400), () {
            disabled = 1;
            if (!mounted) return;
            setState(() {});
          });
        }
        Future(() async {
          RouteData? el;
          if (rtr.topRoute.path == '/:username/:id') {
            el = rtr.topRoute;
          }
          if (el == null) {
            ref.read(commentsControllerProvider).clear();
            return;
          }
          final post = ref.watch(posterStateHolderProvider);
          if (post?.id == el.pathParams.getInt('id')) return;
          ref.read(commentsControllerProvider).clear();
          ref
              .read(commentsControllerProvider)
              .getPost(el.pathParams.getInt('id'));
          ref
              .read(commentsControllerProvider)
              .updateComments(el.pathParams.getInt('id'));
        });
      });
    });
  }

  void jumpToEnd({bool? up}) {
    if (scrollController.offset == 0 ||
        scrollController.offset == imageHeight! - 18) return;
  }

  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final pageTransitionController =
        ref.watch(pageTransitionControllerStateHolder);
    final post = ref.watch(posterStateHolderProvider);
    final comments = ref.watch(commentsStateHolderProvider);
    if (post == null) {
      Future(() async {
        RouteData? el;
        try {
          el = AutoRouter.of(context)
              .stackData
              .lastWhere((element) => element.route.path == '/:username/:id');
        } catch (e) {
          el = null;
        }
        if (el == null) return;
        ref
            .read(commentsControllerProvider)
            .getPost(el.pathParams.getInt('id'));
        ref
            .read(commentsControllerProvider)
            .updateComments(el.pathParams.getInt('id'));
      });
    }
    if (posterController == null) {
      imageHeight = MediaQuery.of(context).size.height * 0.66;
      posterController = AnimationController(
        vsync: this,
        duration: Duration.zero,
        lowerBound: 36,
        upperBound: 2000,
      );
      posterController!.animateTo(imageHeight!);
    }
    return WillPopScope(
      onWillPop: () async {
        if (popped) {
          popped = false;
          return true;
        }
        await ref.read(pageTransitionControllerStateHolder)!.animateTo(
              1,
              duration: const Duration(milliseconds: 200),
            );
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
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            pageTransitionController.animateTo(pageTransitionController.value +
                details.delta.dx / MediaQuery.of(context).size.width);
          },
          onHorizontalDragEnd: (details) async {
            int durationValue = ((pageTransitionController.value < 0.3
                        ? pageTransitionController.value
                        : 1 - pageTransitionController.value) *
                    300)
                .toInt();
            await ref.read(pageTransitionControllerStateHolder)!.animateTo(
                pageTransitionController.value < 0.3 ? 0 : 1,
                duration: Duration(milliseconds: durationValue));
            if (pageTransitionController.value >= 0.3) {
              popped = true;
              AutoRouter.of(context).pop();
            }
          },
          onHorizontalDragCancel: () async {
            int durationValue = ((pageTransitionController.value < 0.3
                        ? pageTransitionController.value
                        : 1 - pageTransitionController.value) *
                    300)
                .toInt();
            await ref.read(pageTransitionControllerStateHolder)!.animateTo(
                pageTransitionController.value < 0.3 ? 0 : 1,
                duration: Duration(milliseconds: durationValue));
            if (pageTransitionController.value >= 0.3) {
              popped = true;
              AutoRouter.of(context).pop();
            }
          },
          child: AnimatedBuilder(
            animation: pageTransitionController!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  disabled *
                      pageTransitionController.value *
                      MediaQuery.of(context).size.width,
                  0,
                ),
                child: child,
              );
            },
            child: Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  FocusScope.of(context).unfocus();
                  if (notification is ScrollUpdateNotification) {
                    velocity = notification.dragDetails?.delta.dy ?? 0;
                    iconsController.animateTo(
                        notification.metrics.pixels - imageHeight! + 18);
                    if (notification.metrics.pixels < 0) {
                      posterController!.animateTo(
                          imageHeight! - notification.metrics.pixels);
                    } else {
                      posterController!.animateTo(
                          imageHeight! - notification.metrics.pixels);
                    }
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    CustomScrollView(
                      controller: scrollController,
                      primary: false,
                      physics: const BouncingScrollPhysics(),
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
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: UserInfoTile(
                                              type: InfoDialogType.postComment,
                                              myEntity: post?.author.id ==
                                                  ref
                                                      .watch(
                                                          myProfileInfoStateHolderProvider)
                                                      ?.id,
                                              entityId: comments![index].id,
                                              showFollowButton: false,
                                              user: comments[index].model,
                                              controller: scrollController,
                                              time: comments[index].time,
                                              behavior:
                                                  HitTestBehavior.translucent,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const SizedBox(width: 68),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      child: Text(
                                                        comments[index].text ??
                                                            '',
                                                        style: context
                                                            .textStyles
                                                            .subheadline,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    if (index !=
                                                        comments.length - 1)
                                                      Divider(
                                                        height: 0.5,
                                                        thickness: 0.5,
                                                        color: context.colors
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
                                                MediaQuery.of(context)
                                                    .padding
                                                    .bottom
                                        ? 56 +
                                            MediaQuery.of(context)
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
                              (MediaQuery.of(context).padding.top + 3) *
                                          (1 -
                                              posterController!.value /
                                                  imageHeight!) <
                                      0
                                  ? 0
                                  : (MediaQuery.of(context).padding.top + 3) *
                                      (1 -
                                          posterController!.value /
                                              imageHeight!)),
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
                                          (imageHeight! -
                                                  posterController!.value) *
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
                                              if (post == null) return;
                                              Navigator.push(
                                                context,
                                                HeroDialogRoute(
                                                    builder: (context) {
                                                  return ImageDialog(
                                                    image: CachedNetworkImage(
                                                      imageUrl: post.imagePath,
                                                      fit: BoxFit.cover,
                                                      placeholderFadeInDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      fadeInDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      fadeOutDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      placeholder:
                                                          (context, child) {
                                                        return SizedBox(
                                                          width: 300,
                                                          height: 200,
                                                          child: shimmer,
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                          obj, trace) {
                                                        return SizedBox(
                                                          width: 300,
                                                          height: 200,
                                                          child: shimmer,
                                                        );
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
                                            child: post?.imagePath == null
                                                ? shimmer
                                                : Hero(
                                                    tag: 'image',
                                                    child: CachedNetworkImage(
                                                      imageUrl: post!.imagePath,
                                                      fit: BoxFit.cover,
                                                      placeholderFadeInDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      fadeInDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      fadeOutDuration:
                                                          CustomDurations
                                                              .cachedDuration,
                                                      placeholder:
                                                          (context, child) {
                                                        return shimmer;
                                                      },
                                                      errorWidget: (context,
                                                          obj, trace) {
                                                        return shimmer;
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
                                                    Colors.black
                                                        .withOpacity(0.5),
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      (imageHeight! -
                                                              posterController!
                                                                  .value) *
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
                                child: Transform.translate(
                                  offset: Offset(0,
                                      -imageHeight! + posterController!.value),
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
                            ],
                          ),
                        );
                      },
                      child: post == null
                          ? const SizedBox()
                          : UserInfoTile(
                              type: InfoDialogType.post,
                              entityId: post.id,
                              user: post.author,
                              time: post.time,
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
                                        .read(
                                            pageTransitionControllerStateHolder)!
                                        .animateTo(1,
                                            duration: const Duration(
                                                milliseconds: 200));
                                    await ref
                                        .read(commentsControllerProvider)
                                        .clear();
                                  },
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if (post == null) return;
                                    _showMenu(context);
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
                                          posterController!.value /
                                              imageHeight!,
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
                                      MediaQuery.of(context).padding.top +
                                      iconAddition)
                                  .toInt()
                                  .toDouble(),
                              child: _PosterActions(),
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
                        child: CommentTextField(id: post.id),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getEmptySpaceHeightForSingleMovie(
      BuildContext context, List<Comment>? comments) {
    double result =
        (comments?.length ?? 0) * 80 + MediaQuery.of(context).padding.top;
    result += 28 + 8 + 44;
    result += TextInfoService.textSizeConstWidth(
      post?.name ?? '',
      context.textStyles.title3!,
      MediaQuery.of(context).size.width - 112,
    ).height;
    result += 6;
    result += TextInfoService.textSizeConstWidth(
      post?.year.toString() ?? '',
      context.textStyles.subheadline!,
      MediaQuery.of(context).size.width,
    ).height;
    result += 24;
    if (post != null) {
      result += TextInfoService.textSizeConstWidth(
        (post!.description ?? '').length > 280
            ? post!.description!.substring(0, 280)
            : (post!.description ?? ''),
        context.textStyles.subheadline!,
        MediaQuery.of(context).size.width - 32,
      ).height;
    }
    result += 24;
    for (var comment in comments ?? <Comment>[]) {
      result += TextInfoService.textSizeConstWidth(
        comment.text,
        context.textStyles.subheadline!,
        MediaQuery.of(context).size.width - 84,
      ).height;
    }
    return MediaQuery.of(context).size.height - result < 0
        ? 0
        : MediaQuery.of(context).size.height - result;
  }

  void _showMenu(
    BuildContext context,
  ) {
    final myPoster = ref.watch(myProfileInfoStateHolderProvider);
    final post = ref.watch(posterStateHolderProvider)!;

    MenuDialog.showBottom(
      context,
      MenuState(null, [
        MenuTitle(post.year.contains('-') ? "TV Show" : "Movie"),
        if (post.hasInCollection == true)
          MenuItem(
            'assets/icons/ic_collections_add.svg',
            context.txt.poster_menu_listAdd,
            () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddToListDialog(),
              );
            },
          ),
        MenuItem(
          'assets/icons/ic_arrow_out.svg',
          context.txt.poster_menu_openTMDB,
          () {
            if (post.tmdbLink != null) {
              launchUrlString(post.tmdbLink!);
            }
          },
        ),
        MenuItem(
          'assets/icons/ic_play_circle.svg',
          context.txt.watchlist_menu_whereToWatch,
          () {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBars.build(
                context,
                null,
                //TODO: localize
                "Not available yet",
              ),
            );
          },
        ),
        MenuTitle(context.txt.poster),
        if (myPoster?.id != post.author.id)
          MenuItem(
            'assets/icons/ic_follow.svg',
            context.txt.follow,
            () {
              ref
                  .read(homePagePostsControllerProvider)
                  .setFollowId(post.id, !post.author.followed);
              ref.read(posterStateHolderProvider.notifier).updateState(
                  post.copyWith(
                      author: post.author
                          .copyWith(followed: !post.author.followed)));
              ref.read(profileControllerApiProvider).follow(
                    post!.author.id,
                    post!.author.followed,
                  );
            },
          ),
        MenuItem(
          (myPoster?.id != post.author.id)
              ? 'assets/icons/ic_share.svg'
              : 'assets/icons/ic_edit.svg',
          (myPoster?.id != post.author.id)
              ? context.txt.share
              : context.txt.posterEdit_editPoster,
          () {
            if (myPoster?.id != post.author.id) {
              Share.share(
                  "https://posterstock.com/${post.author.username}/${post.id}");
            } else {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => CreatePosterDialog(
                  postMovieModel: post,
                ),
              );
            }
          },
        ),
        MenuItem.danger(
          (myPoster?.id != post.author.id)
              ? 'assets/icons/ic_danger.svg'
              : 'assets/icons/ic_trash2.svg',
          (myPoster?.id != post.author.id)
              ? context.txt.report
              : context.txt.delete,
          () async {
            if (myPoster?.id != post.author.id) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBars.build(
                  context,
                  null,
                  //TODO: loclize
                  "Not available yet",
                ),
              );
            } else {
              try {
                // await ref
                //     .read(commentsControllerProvider)
                //     .deletePost(post.id);
                await ref
                    .read(accountPostersStateNotifier.notifier)
                    .deletePost(post.id);
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBars.build(
                    context,
                    null,
                    //TODO: localize
                    "Deleted successfully",
                  ),
                );
                Navigator.pop(context);
                AutoRouter.of(context).pop();
              } catch (e) {
                print("FEF");
                print(e);
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBars.build(
                    context,
                    null,
                    //TODO: localize
                    'Could not delete post',
                  ),
                );
              }
              final myself = ref.watch(profileInfoStateHolderProvider)?.mySelf;
              if (myself != false) {
                ref.read(profileControllerApiProvider).getUserInfo(null);
              }
            }
          },
        )
      ]),
    );
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
  bool loading = false;

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
                focus.hasFocus && MediaQuery.of(context).viewInsets.bottom != 0
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
                  hintText:
                      AppLocalizations.of(context)!.poster_reply_field_hint,
                  hintStyle: context.textStyles.callout!.copyWith(
                    color: context.colors.textsDisabled,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          if (focus.hasFocus)
            KeyboardVisibilityBuilder(builder: (context, visible) {
              if (!visible) return const SizedBox();
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
                    SizedBox(
                      height: 32,
                      width: TextInfoService.textSize(
                                  AppLocalizations.of(context)!.poster_reply,
                                  context.textStyles.calloutBold!)
                              .width +
                          32,
                      child: AppTextButton(
                        text: AppLocalizations.of(context)!.poster_reply,
                        disabled: controller.text.isEmpty ||
                            controller.text.length > 140,
                        child: loading
                            ? Center(
                                child: defaultTargetPlatform !=
                                        TargetPlatform.android
                                    ? CupertinoActivityIndicator(
                                        radius: 10.0,
                                        color: context.colors.textsBackground!,
                                      )
                                    : SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color:
                                              context.colors.textsBackground!,
                                          strokeWidth: 2,
                                        ),
                                      ),
                              )
                            : null,
                        onTap: () async {
                          loading = true;
                          setState(() {});
                          if (!widget.isList) {
                            await ref
                                .read(commentsControllerProvider)
                                .postComment(widget.id, controller.text);
                            await ref
                                .read(homePagePostsControllerProvider)
                                .addComment(widget.id);
                          } else {
                            await ref
                                .read(commentsControllerProvider)
                                .postCommentList(widget.id, controller.text);
                            await ref
                                .read(homePagePostsControllerProvider)
                                .addCommentList(widget.id);
                          }
                          loading = false;
                          setState(() {});
                          controller.clear();
                          focus.unfocus();
                        },
                      ),
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
                  post == null ? null : MediaQuery.of(context).size.width - 112,
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

// class PosterActionsDialog extends ConsumerWidget {
//   const PosterActionsDialog({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final myPoster = ref.watch(myProfileInfoStateHolderProvider);
//     final post = ref.watch(posterStateHolderProvider)!;
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: SizedBox(
//         height: 490 -
//             ((myPoster?.id != post.author.id) ? 0 : 40) -
//             ((post.hasInCollection == true) ? 0 : 40),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16.0),
//                   child: SizedBox(
//                     height: 384 -
//                         ((myPoster?.id != post.author.id) ? 0 : 40) -
//                         ((post.hasInCollection == true) ? 0 : 40),
//                     child: Material(
//                       color: context.colors.backgroundsPrimary,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 36,
//                             child: Center(
//                               child: Text(
//                                 post.year.contains('-') ? "TV Show" : "Movie",
//                                 style: context.textStyles.footNote!.copyWith(
//                                   color: context.colors.textsSecondary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (post.hasInCollection == true)
//                             Divider(
//                               height: 0.5,
//                               thickness: 0.5,
//                               color: context.colors.fieldsDefault,
//                             ),
//                           if (post.hasInCollection == true)
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   showModalBottomSheet(
//                                     context: context,
//                                     isScrollControlled: true,
//                                     backgroundColor: Colors.transparent,
//                                     builder: (context) => AddToListDialog(),
//                                   );
//                                 },
//                                 child: Center(
//                                   //TODO REMOVE THIS IF THIS MOVIE NOT IN COLLECTION
//                                   child: Text(
//                                     AppLocalizations.of(context)!
//                                         .poster_menu_listAdd,
//                                     style: context.textStyles.bodyRegular!
//                                         .copyWith(
//                                       color: context.colors.textsPrimary,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           Divider(
//                             height: 0.5,
//                             thickness: 0.5,
//                             color: context.colors.fieldsDefault,
//                           ),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 if (post.tmdbLink != null) {
//                                   launchUrlString(post.tmdbLink!);
//                                 }
//                               },
//                               child: Center(
//                                 child: Text(
//                                   AppLocalizations.of(context)!
//                                       .poster_menu_openTMDB,
//                                   style:
//                                       context.textStyles.bodyRegular!.copyWith(
//                                     color: context.colors.textsPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Divider(
//                             height: 0.5,
//                             thickness: 0.5,
//                             color: context.colors.fieldsDefault,
//                           ),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 scaffoldMessengerKey.currentState?.showSnackBar(
//                                   SnackBars.build(
//                                     context,
//                                     null,
//                                     //TODO: localize
//                                     "Not available yet",
//                                   ),
//                                 );
//                               },
//                               child: Center(
//                                 child: Text(
//                                   context.txt.watchlist_menu_whereToWatch,
//                                   style:
//                                       context.textStyles.bodyRegular!.copyWith(
//                                     color: context.colors.textsPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 36,
//                             child: Center(
//                               child: Text(
//                                 context.txt.poster,
//                                 style: context.textStyles.footNote!.copyWith(
//                                   color: context.colors.textsSecondary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (myPoster?.id != post.author.id)
//                             Divider(
//                               height: 0.5,
//                               thickness: 0.5,
//                               color: context.colors.fieldsDefault,
//                             ),
//                           if (myPoster?.id != post.author.id)
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
//                                   ref
//                                       .read(homePagePostsControllerProvider)
//                                       .setFollowId(
//                                           post.id, !post.author.followed);
//                                   ref
//                                       .read(posterStateHolderProvider.notifier)
//                                       .updateState(post.copyWith(
//                                           author: post.author.copyWith(
//                                               followed:
//                                                   !post.author.followed)));
//                                   ref.read(profileControllerApiProvider).follow(
//                                         post!.author.id,
//                                         post!.author.followed,
//                                       );
//                                 },
//                                 child: Center(
//                                   child: Text(
//                                     //TODO: symplify
//                                     "${post.author.followed ? context.txt.unfollow : context.txt.follow} ${post.author.name}",
//                                     style: context.textStyles.bodyRegular!
//                                         .copyWith(
//                                       color: context.colors.textsPrimary,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           Divider(
//                             height: 0.5,
//                             thickness: 0.5,
//                             color: context.colors.fieldsDefault,
//                           ),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 Share.share(
//                                     "https://posterstock.com/${post.author.username}/${post.id}");
//                               },
//                               child: Center(
//                                 child: Text(
//                                   context.txt.share,
//                                   style:
//                                       context.textStyles.bodyRegular!.copyWith(
//                                     color: context.colors.textsPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Divider(
//                             height: 0.5,
//                             thickness: 0.5,
//                             color: context.colors.fieldsDefault,
//                           ),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () async {
//                                 if (myPoster?.id != post.author.id) {
//                                   scaffoldMessengerKey.currentState
//                                       ?.showSnackBar(
//                                     SnackBars.build(
//                                       context,
//                                       null,
//                                       //TODO: loclize
//                                       "Not available yet",
//                                     ),
//                                   );
//                                 } else {
//                                   try {
//                                     // await ref
//                                     //     .read(commentsControllerProvider)
//                                     //     .deletePost(post.id);
//                                     await ref
//                                         .read(accountPostersStateNotifier
//                                             .notifier)
//                                         .deletePost(post.id);
//                                     scaffoldMessengerKey.currentState
//                                         ?.showSnackBar(
//                                       SnackBars.build(
//                                         context,
//                                         null,
//                                         //TODO: localize
//                                         "Deleted successfully",
//                                       ),
//                                     );
//                                     Navigator.pop(context);
//                                     AutoRouter.of(context).pop();
//                                   } catch (e) {
//                                     print("FEF");
//                                     print(e);
//                                     scaffoldMessengerKey.currentState
//                                         ?.showSnackBar(
//                                       SnackBars.build(
//                                         context,
//                                         null,
//                                         //TODO: localize
//                                         'Could not delete post',
//                                       ),
//                                     );
//                                   }
//                                   final myself = ref
//                                       .watch(profileInfoStateHolderProvider)
//                                       ?.mySelf;
//                                   if (myself != false) {
//                                     ref
//                                         .read(profileControllerApiProvider)
//                                         .getUserInfo(null);
//                                   }
//                                 }
//                               },
//                               child: Center(
//                                 child: Text(
//                                   (myPoster?.id != post.author.id)
//                                       ? context.txt.report
//                                       : context.txt.delete,
//                                   style:
//                                       context.textStyles.bodyRegular!.copyWith(
//                                     color: context.colors.textsError,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16.0),
//                   child: SizedBox(
//                     height: 52,
//                     child: Material(
//                       color: context.colors.backgroundsPrimary,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Center(
//                           child: Text(
//                             context.txt.cancel,
//                             style: context.textStyles.bodyRegular,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _PosterActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    final profile = ref.watch(myProfileInfoStateHolderProvider)!;
    if (post == null) {
      return const SizedBox.shrink();
    }
    if (post?.hasInCollection == true) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddToListDialog(),
          );
        },
        child: SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset('assets/icons/ic_collections_add.svg'),
        ),
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (post != null) {
                await ref.read(commentsControllerProvider).setBookmarked(
                      post.id,
                      !(post.hasBookmarked ?? true),
                    );
                final myself =
                    ref.watch(profileInfoStateHolderProvider)?.mySelf;
                if (myself != false) {
                  ref.read(profileControllerApiProvider).getUserInfo(null);
                }
              }
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                post?.hasBookmarked == true
                    ? 'assets/images/ic_bookmarks_filled.png'
                    : 'assets/images/ic_bookmarks.png',
                color: context.colors.iconsDefault!,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              ref.read(createPosterControllerProvider).chooseMovie(
                    MediaModel(
                      id: post!.mediaId!,
                      title: post.name,
                      type: post.mediaType == 'movie'
                          ? MediaType.movie
                          : MediaType.tv,
                      startYear: int.parse(post.year.split(" - ")[0]),
                      endYear: post.year.split(" - ").length == 1 ||
                              post.year.split(" - ")[1].isEmpty
                          ? null
                          : int.parse(
                              post.year.split(" - ")[1],
                            ),
                    ),
                  );
              if (post.hasInCollection == false) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const CreatePosterDialog(),
                );
              }
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                post?.hasInCollection == true
                    ? 'assets/images/ic_collection_filled.png'
                    : 'assets/images/ic_collection.png',
                color: context.colors.iconsDefault!,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget myPoster(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    return post?.hasInCollection == true
        ? const SizedBox.shrink()
        : SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset('assets/icons/ic_collections_add.svg'),
          );
  }

  Widget userPoster(BuildContext context, WidgetRef ref) {
    final post = ref.watch(posterStateHolderProvider);
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        post?.hasInCollection == true
            ? 'assets/images/ic_collection_filled.png'
            : 'assets/images/ic_collection.png',
        color: context.colors.iconsDefault!,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
