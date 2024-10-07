// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/helpers/hero_dialog_route.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/comment_text_field.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/poster/controller/post_controller.dart';
import 'package:poster_stock/features/poster/model/comment.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/page_transition_controller_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/poster/view/widgets/add_to_list_dialog.dart';
import 'package:poster_stock/features/poster/view/widgets/image_dialog.dart';
import 'package:poster_stock/features/poster/view/widgets/poster_actions.dart';
import 'package:poster_stock/features/poster/view/widgets/poster_info.dart';
import 'package:poster_stock/features/poster_dialog/controller/create_poster_controller.dart';
import 'package:poster_stock/features/poster_dialog/view/poster_dialog.dart';
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
      ref.read(postControllerProvider).clear();
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
            ref.read(postControllerProvider).clear();
            return;
          }
          PostMovieModel? post = ref.watch(posterStateHolderProvider);
          if (post?.id == el.pathParams.getInt('id')) return;
          ref.read(postControllerProvider).clear();
          ref.read(postControllerProvider).getPost(el.pathParams.getInt('id'));
          ref
              .read(postControllerProvider)
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
        ref.read(postControllerProvider).getPost(el.pathParams.getInt('id'));
        ref
            .read(postControllerProvider)
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
                                  const SizedBox(height: 5),
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
                                              isArtist: true,
                                              isArtistWb: false,
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
                                                        comments[index].text,
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
                              isArtist: true,
                              isArtistWb: true,
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
                                CustomBackButtonWithWord(
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
                                        .read(postControllerProvider)
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
                              child: const PosterActions(),
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
                    post.author.id,
                    post.author.followed,
                  );
            },
          ),
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.profile_menu_shareMy,
          () {
            Share.share(
                "https://posterstock.com/${post.author.username}/${post.id}");
          },
        ),
        if (myPoster?.id == post.author.id)
          MenuItem(
            'assets/icons/ic_edit.svg',
            context.txt.posterEdit_editPoster,
            () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                context: context,
                // backgroundColor: Colors.transparent,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => PosterDialog(
                  postMovieModel: post,
                ),
              ).whenComplete(() {
                ref.read(createPosterControllerProvider).choosePoster(null);
                ref.read(createPosterControllerProvider).chooseMovie(null);
                ref.read(createPosterControllerProvider).updateSearch('');
              });
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
                AutoRouter.of(context).pop();
              } catch (e) {
                Logger.e('Ошибка при удалении постера $e');
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
                ref
                    .read(profileControllerApiProvider)
                    .getUserInfo(null, context);
              }
            }
          },
        )
      ]),
    );
  }
}
