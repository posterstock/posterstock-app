import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/auth/view/widgets/custom_app_bar.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/movie_card.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/features/home/view/widgets/reaction_button.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/list/controller/list_controller.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../common/services/text_info_service.dart';
import '../../poster/view/pages/poster_page/poster_page.dart';
import '../../profile/view/pages/profile_page.dart';

@RoutePage()
class ListPage extends ConsumerStatefulWidget {
  const ListPage({
    @PathParam('id') required this.id,
    Key? key,
  }) : super(key: key);

  final int id;

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
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

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 36,
      upperBound: 1000,
      duration: Duration.zero,
    );
    animationController.animateTo(250);
    Future(() async {
      ref.read(listsControllerProvider).clear();
      ref.read(listsControllerProvider).getPost(widget.id);
    });
  }

  double velocity = 0;

  void jumpToEnd({bool? up}) {
    if (scrollController.offset == 0 || scrollController.offset == 250) return;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        int durationValue = (200 *
                (1 - (animationController.value - 250 / 2).abs() / (250 / 2)))
            .round();
        if (durationValue < 50) durationValue = 50;
        if (up == false ||
            animationController.value > 250 * 0.5 && up != true) {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        } else {
          scrollController.animateTo(
            250,
            duration: Duration(milliseconds: durationValue),
            curve: Curves.linear,
          );
        }
      },
    );
    if (up == false || animationController.value > 250 * 0.5 && up != true) {
      animationController.animateTo(
        250,
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
    final posts = ref.watch(listsStateHolderProvider);
    if (posts == null) {
      Future(() async {
        var el = ref
            .watch(router)!
            .stackData
            .lastWhere((element) => element.route.path == '/list/:id');
        ref.read(listsControllerProvider).getPost(el.pathParams.getInt('id'));
      });
    }
    final comments = ref.watch(commentsStateHolderProvider);
    if (comments == null) {
      ref.read(listsControllerProvider).updateComments(widget.id);
    }
    return WillPopScope(
      onWillPop: () async {
        await ref.read(listsControllerProvider).clear();
        return true;
      },
      child: Listener(
        onPointerUp: (details) {
          if (scrollController.offset > 250) return;
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
          body: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    velocity = notification.dragDetails?.delta.dy ?? 0;
                    if (notification.metrics.pixels < 0) {
                      animationController
                          .animateTo(250 - notification.metrics.pixels);
                    } else {
                      animationController
                          .animateTo(250 - notification.metrics.pixels);
                    }
                  }
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.pixels > 250) return false;
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
                      leading: const CustomBackButton(),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: const ListActionsDialog(),
                                ),
                              ),
                            );
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
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 0) {
                              return CollectionInfoWidget(
                                shimmer: shimmer,
                                post: posts,
                              );
                            }
                            if (index == (comments?.length ?? 0) + 1) {
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
                                      showFollowButton: false,
                                      user: comments?[index - 1].model,
                                      time: comments?[index - 1].time,
                                      behavior: HitTestBehavior.translucent,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 68,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comments![index - 1].text,
                                              style: context
                                                  .textStyles.subheadline!,
                                            ),
                                            SizedBox(height: 12),
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
                          childCount: 2 + (comments?.length ?? 0),
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
                        offset: Offset(0,
                            (animationController.value - 36) / (250 - 36) * 42),
                        child: Transform.scale(
                          alignment: Alignment.topCenter,
                          scale: animationController.value / 250 > 1
                              ? ((250 +
                                      (animationController.value - 250) * 0.8) /
                                  250)
                              : animationController.value / 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular((1 -
                                    (animationController.value - 36) /
                                        (250 - 36)) *
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
                        height: 250,
                        width: double.infinity,
                        child: posts?.image != null
                            ? Image.network(
                                posts!.image!,
                                fit: BoxFit.cover,
                              )
                            : Row(
                                children: List.generate(
                                  posts?.posters.length ?? 0,
                                  (index) => Expanded(
                                    child: Image.network(
                                      posts?.posters[index].image ?? '',
                                      height: 250,
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

  double getEmptySpaceHeightForCollection(
      BuildContext context, MultiplePostModel? posts) {
    final comments = ref.watch(commentsStateHolderProvider);
    double result = (comments?.length ?? 0) * 80 + 200;
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
    for (var comment in comments ?? []) {
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
    final comments = ref.watch(commentsStateHolderProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoTile(
            user: post?.author,
            loading: post == null,
            showSettings: false,
            showFollowButton: false,
            time: post?.time,
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
              Spacer(),
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
              SizedBox(width: 12),
              ReactionButton(
                iconPath: 'assets/icons/ic_comment2.svg',
                iconColor: context.colors.iconsDisabled!,
                amount: comments?.length ?? post?.comments,
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
                212,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.5,
                mainAxisSpacing: 15,
                mainAxisExtent: 201,
              ),
              itemCount: post?.posters.length,
              itemBuilder: (context, index) {
                return PostsCollectionTile(
                  shimmer: shimmer,
                  index: index,
                  post: PostMovieModel(
                    year: post!.posters[index].years,
                    imagePath: post!.posters[index].image,
                    id: post!.posters[index].id,
                    name: post!.posters[index].title,
                    author: post!.author,
                    time: post!.time,
                    liked: false,
                    timeDate: post!.timeDate,
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

class ListActionsDialog extends ConsumerWidget {
  const ListActionsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 190,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'List',
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
