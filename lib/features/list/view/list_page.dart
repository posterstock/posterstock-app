// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/comment_text_field.dart';
import 'package:poster_stock/features/account/notifiers/lists_notifier.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/movie_card.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/ton_view.dart';
import 'package:poster_stock/features/list/controller/list_controller.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class ListPage extends ConsumerStatefulWidget {
  final int id;
  final ListType? type;

  ListPage({
    @PathParam('id') required this.id,
    @PathParam('type') int type = -1,
    Key? key,
  })  : type = ListType.findByIndex(type),
        super(key: key);

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

enum ListType {
  favorited,
  recomends;

  static ListType? findByIndex(int index) {
    try {
      return ListType.values[index];
    } catch (_) {
      return null;
    }
  }
}

class _ListPageState extends ConsumerState<ListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  final ScrollController scrollController = ScrollController();
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

  Future init() async {
    Future(() async {
      ref.read(listsControllerProvider).clear();
      if (widget.type != null) {
        ref.read(listsControllerProvider).getSpecialList(widget.type!);
      } else {
        ref.read(listsControllerProvider).getPost(widget.id);
      }
      animationController
          .animateTo(MediaQuery.of(context).size.width / 540 * 300);
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 36,
      upperBound: 1000,
      duration: Duration.zero,
    );
    init();
  }

  double velocity = 0;

  void jumpToEnd({bool? up}) {
    var newHeight = MediaQuery.of(context).size.width / 540 * 300;
    if (scrollController.offset == 0 || scrollController.offset == newHeight) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        int durationValue = (200 *
                (1 -
                    (animationController.value - newHeight / 2).abs() /
                        (newHeight / 2)))
            .round();
        if (durationValue < 50) durationValue = 50;
        if (up == false ||
            animationController.value > newHeight * 0.5 && up != true) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        } else {
          scrollController.animateTo(
            newHeight,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        }
      },
    );
    if (up == false ||
        animationController.value > newHeight * 0.5 && up != true) {
      animationController.animateTo(
        newHeight,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      animationController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var newHeight = MediaQuery.of(context).size.width / 540 * 300;
    final posts = ref.watch(listsStateHolderProvider);
    if (posts == null) {
      Future(() async {
        try {
          var el = ref
              .watch(router)!
              .stackData
              .lastWhere((element) => element.route.path == '/list/:id');
          ref.read(listsControllerProvider).getPost(el.pathParams.getInt('id'));
        } catch (e) {
          Logger.e('Ошибка при получении списка $e');
        }
      });
    }
    final commentsBegin = ref.watch(commentsStateHolderProvider);
    if (commentsBegin == null) {
      ref.read(listsControllerProvider).updateComments(widget.id);
    }
    final comments = commentsBegin ?? [];
    return Listener(
      onPointerUp: (details) {
        if (scrollController.offset > newHeight) return;
        if (scrollController.offset < 0) return;
        if (velocity > 15) {
          jumpToEnd(up: false);
        } else if (velocity < -13) {
          jumpToEnd(up: true);
        } else {
          jumpToEnd();
        }
      },
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          body: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    velocity = notification.dragDetails?.delta.dy ?? 0;
                    if (notification.metrics.pixels < 0) {
                      animationController
                          .animateTo(newHeight - notification.metrics.pixels);
                    } else {
                      animationController
                          .animateTo(newHeight - notification.metrics.pixels);
                    }
                  }
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels > newHeight) return false;
                    if (notification.metrics.pixels < 0) return false;
                    jumpToEnd();
                  }
                  return true;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: context.colors.backgroundsPrimary,
                      elevation: 0,
                      leadingWidth: 130,
                      toolbarHeight: 42,
                      expandedHeight: 292,
                      collapsedHeight: 42,
                      pinned: true,
                      leading: const CustomBackButtonWithWord(),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            if (posts == null) return;
                            await showMenuList();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SvgPicture.asset(
                              'assets/icons/ic_dots.svg',
                              colorFilter: ColorFilter.mode(
                                context.colors.iconsDefault!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 0) {
                              return CollectionInfoWidget(
                                shimmer: shimmer,
                                post: posts,
                              );
                            }
                            if (index == (comments.length) + 1) {
                              return SizedBox(
                                height: getEmptySpaceHeightForCollection(
                                            context, posts) <
                                        56 +
                                            MediaQuery.of(context)
                                                .padding
                                                .bottom
                                    ? 56 + MediaQuery.of(context).padding.bottom
                                    : getEmptySpaceHeightForCollection(
                                        context, posts),
                              );
                            }
                            return Padding(
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
                                      type: InfoDialogType.listComment,
                                      myEntity: posts?.author.id ==
                                          ref
                                              .watch(
                                                  myProfileInfoStateHolderProvider)
                                              ?.id,
                                      entityId: comments[index - 1].id,
                                      showFollowButton: false,
                                      user: comments[index - 1].model,
                                      time: comments[index - 1].time,
                                      behavior: HitTestBehavior.translucent,
                                      isArtist: ref
                                          .watch(
                                              myProfileInfoStateHolderProvider)!
                                          .isArtist,
                                      isArtistWb: false,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: Text(
                                                comments[index - 1].text,
                                                style: context
                                                    .textStyles.subheadline!,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            if (index - 1 !=
                                                comments.length - 1)
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
                            );
                          },
                          childCount: 2 + comments.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: IgnorePointer(
                  ignoring: true,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            0,
                            (animationController.value - 36) /
                                (newHeight - 36) *
                                42),
                        child: Transform.scale(
                          alignment: Alignment.topCenter,
                          scale: animationController.value / newHeight > 1
                              ? ((newHeight +
                                      (animationController.value - newHeight) *
                                          0.8) /
                                  newHeight)
                              : animationController.value / newHeight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular((1 -
                                    (animationController.value - 36) /
                                        (newHeight - 36)) *
                                20),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: ShimmerLoader(
                      loaded: posts != null,
                      child: Container(
                        color: context.colors.backgroundsSecondary,
                        height: MediaQuery.of(context).size.width / 540 * 300,
                        width: double.infinity,
                        child: posts?.image != null
                            ? Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: posts!.image!,
                                    fit: BoxFit.cover,
                                    placeholderFadeInDuration:
                                        CustomDurations.cachedDuration,
                                    fadeInDuration:
                                        CustomDurations.cachedDuration,
                                    fadeOutDuration:
                                        CustomDurations.cachedDuration,
                                    placeholder: (context, child) {
                                      return shimmer;
                                    },
                                    errorWidget: (context, obj, trace) {
                                      return shimmer;
                                    },
                                  ),
                                  if (posts.isNft) const NftIcon(),
                                  if (posts.isSale) const SaleIcon(),
                                ],
                              )
                            : Row(
                                children: List.generate(
                                  posts?.posters.length ?? 0,
                                  (index) => Expanded(
                                    child: Image.network(
                                      posts?.posters[index].image ?? '',
                                      height:
                                          MediaQuery.of(context).size.width /
                                              540 *
                                              300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                child: CommentTextField(
                  id: posts?.id ?? -1,
                  isList: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future showMenuList() async {
    final list = ref.watch(listsStateHolderProvider);
    final myself = ref.watch(myProfileInfoStateHolderProvider);
    MenuDialog.showBottom(
      context,
      MenuState(null, [
        MenuTitle(context.txt.lists),
        if (list!.author.id != myself?.id)
          MenuItem(
            list.author.followed
                ? 'assets/icons/ic_unfollow.svg'
                : 'assets/icons/ic_follow.svg',
            '${list.author.followed ? AppLocalizations.of(context)!.unfollow : AppLocalizations.of(context)!.follow} ${list.author.name}',
            () {
              ref
                  .read(homePagePostsControllerProvider)
                  .setFollowId(list.author.id, !list.author.followed);
              ref.read(listsStateHolderProvider.notifier).updateState(
                    list.copyWith(
                      author:
                          list.author.copyWith(followed: !list.author.followed),
                    ),
                  );
              ref.read(profileControllerApiProvider).follow(
                    list.author.id,
                    list.author.followed,
                  );
            },
          ),
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.list_page_share,
          () {
            final profile = myself!.username;
            String link;
            switch (widget.type) {
              case ListType.favorited:
                link = 'https://posterstock.com/$profile/favorites';
                break;
              case ListType.recomends:
                link = 'https://posterstock.com/$profile/recommends';
                break;
              default:
                link = 'https://posterstock.com/list/${list.id}';
            }
            Share.share(link);
          },
        ),
        if (list.author.id == myself?.id)
          MenuItem(
            'assets/icons/ic_edit.svg',
            context.txt.list_edit,
            () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                useRootNavigator: true,
                isScrollControlled: true,
                enableDrag: false,
                isDismissible: false,
                useSafeArea: true,
                builder: (context) => CreateListDialog(id: list.id),
              );
              await ref.read(listsControllerProvider).getPost(widget.id);
            },
          ),
        MenuItem.danger(
          (list.author.id != myself?.id)
              ? 'assets/icons/ic_danger.svg'
              : 'assets/icons/ic_trash2.svg',
          (list.author.id != myself?.id)
              ? context.txt.report
              : context.txt.delete,
          () async {
            if (list.author.id != myself?.id) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBars.build(
                  context,
                  null,
                  'Not available yet',
                ),
              );
            } else {
              try {
                await ref.read(listsControllerProvider).deleteList(list.id);
                ref
                    .read(profileControllerApiProvider)
                    .getUserInfo(null, context);
                await ref.read(accountListsStateNotifier.notifier).reload();
                ref.watch(router)!.pop();
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBars.build(
                    context,
                    null,
                    "List deleted successfully",
                  ),
                );
              } catch (_) {
                Logger.e('Ошибка при удалении списка $_');
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBars.build(
                    context,
                    null,
                    "Could not delete list",
                  ),
                );
              }
            }
          },
        )
      ]),
    );
  }

  double getEmptySpaceHeightForCollection(
      BuildContext context, MultiplePostModel? posts) {
    final commentsBegin = ref.watch(commentsStateHolderProvider);
    final comments = commentsBegin ?? [];
    double result = (comments.length) * 80 + 200;
    result += TextInfoService.textSizeConstWidth(
      posts?.name ?? '',
      context.textStyles.title3!,
      MediaQuery.of(context).size.width - 32,
    ).height;
    result += TextInfoService.textSizeConstWidth(
      (posts?.description ?? '').length > 280
          ? posts!.description!.substring(0, 280)
          : (posts?.description ?? ''),
      context.textStyles.subheadline!,
      MediaQuery.of(context).size.width - 32,
    ).height;
    result += ((posts?.posters.length ?? 0) % 3 == 0
            ? (posts?.posters.length ?? 0) / 3
            : (posts?.posters.length ?? 0) ~/ 3 + 1) *
        212;
    result += 32;
    for (var comment in comments) {
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
}

class CollectionInfoWidget extends ConsumerWidget {
  const CollectionInfoWidget({
    Key? key,
    this.post,
    required this.shimmer,
  }) : super(key: key);

  final MultiplePostModel? post;
  final Widget shimmer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsBegin = ref.watch(commentsStateHolderProvider);
    final comments = commentsBegin ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoTile(
            type: InfoDialogType.list,
            entityId: post?.id ?? -1,
            user: post?.author,
            loading: post == null,
            showSettings: false,
            showFollowButton: false,
            time: post?.time,
            isArtist: false,
            isArtistWb: false,
          ),
          const SizedBox(height: 16),
          Text(
            post?.name ?? '',
            style: context.textStyles.title3,
          ),
          const SizedBox(height: 20),
          Text(
            (post?.description ?? '').length > 140
                ? post!.description!.substring(0, 140)
                : (post?.description ?? ''),
            style: context.textStyles.subheadline,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              LikeButton(
                amount: post?.likes ?? 0,
                liked: post?.liked ?? false,
                onTap: () {
                  if (post == null) return;
                  ref
                      .read(homePagePostsControllerProvider)
                      .setLikeIdList(post!.id, !(post!.liked));
                  ref.read(listsStateHolderProvider.notifier).updateState(
                        post?.copyWith(
                          liked: !(post!.liked),
                          likes:
                              post!.liked ? post!.likes - 1 : post!.likes + 1,
                        ),
                      );
                },
              ),
              const SizedBox(width: 12),
              ReactionButton(
                iconPath: 'assets/icons/ic_comment2.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: comments.length,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: context.colors.fieldsDefault,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: ((post?.posters.length ?? 0) % 3 == 0
                    ? (post?.posters.length ?? 0) / 3
                    : (post?.posters.length ?? 0) ~/ 3 + 1) *
                225,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.5,
                mainAxisSpacing: 15,
                mainAxisExtent:
                    ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) /
                                3) /
                            2 *
                            3 +
                        41,
              ),
              itemCount: post?.posters.length,
              itemBuilder: (context, index) {
                return PostsCollectionTile(
                  shimmer: shimmer,
                  index: index,
                  post: PostMovieModel(
                    startYear: post!.posters[index].startYear,
                    endYear: post!.posters[index].endYear ?? 0,
                    imagePath: post!.posters[index].image,
                    id: post!.posters[index].id,
                    type: 'list',
                    name: post!.posters[index].title,
                    author: post!.author,
                    creationTime: post!.creationTime,
                    liked: false,
                    description: post!.posters[index].description,
                    hasBookmarked: false,
                    isArtist: post!.isArtist,
                    nft: post!.nft,
                  ),
                  customOnItemTap: (post, index) {
                    AutoRouter.of(context).push(
                      PosterRoute(
                        postId: post.id,
                        username: post.author.username,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
