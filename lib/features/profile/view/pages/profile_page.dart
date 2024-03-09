import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/features/edit_profile/api/edit_profile_api.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/list/controller/list_controller.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/peek_pop/peek_and_pop_dialog.dart';
import 'package:poster_stock/features/poster/controller/comments_controller.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PostsCollectionTile extends ConsumerWidget {
  const PostsCollectionTile({
    Key? key,
    this.post,
    this.customOnItemTap,
    required this.index,
    required this.shimmer,
    this.imagePath,
    this.name,
    this.customOnLongTap,
    this.year,
  }) : super(key: key);
  final int index;
  final PostMovieModel? post;
  final String? imagePath;
  final String? name;
  final String? year;
  final void Function(PostMovieModel, int)? customOnItemTap;
  final void Function()? customOnLongTap;
  final Widget shimmer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PeekAndPopDialog(
      customOnLongTap: customOnLongTap,
      onTap: () {
        if (post != null) {
          if (customOnItemTap == null) {
            ref.watch(router)!.push(
                  PosterRoute(
                    postId: post!.id,
                  ),
                );
          } else {
            customOnItemTap!(post!, index);
          }
        }
      },
      dialog: Material(
        color: Colors.transparent,
        child: PosterImageDialog(
          imagePath: imagePath ?? post?.imagePath ?? '',
          name: post == null ? null : post!.name,
          year: post == null ? null : post!.year.toString(),
          description: post == null ? null : post!.description,
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: context.colors.backgroundsSecondary,
              width: double.infinity,
              height:
                  ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) / 3) /
                      2 *
                      3,
              child: CachedNetworkImage(
                imageUrl: (post == null ? imagePath : post?.imagePath) ?? '',
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
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            (post == null ? name : post?.name) ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.caption2!.copyWith(
              color: context.colors.textsPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            year ?? (post == null ? '' : post!.year.toString()),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.caption1!.copyWith(
              color: context.colors.textsDisabled,
            ),
          ),
        ],
      ),
    );
  }
}

class PosterImageDialog extends StatefulWidget {
  const PosterImageDialog({
    super.key,
    this.name,
    this.year,
    required this.imagePath,
    this.description,
  });

  final String? name;
  final String? year;
  final String imagePath;
  final String? description;

  @override
  State<PosterImageDialog> createState() => _PosterImageDialogState();
}

class _PosterImageDialogState extends State<PosterImageDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Listener(
      onPointerUp: (intent) {
        Navigator.pop(context);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.scale(
                scale: controller.value,
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: context.colors.backgroundsSecondary,
                    height: 300,
                    width: 200,
                    child: CachedNetworkImage(
                      imageUrl: widget.imagePath,
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
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.name != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: context.colors.backgroundsPrimary,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name!,
                          style: context.textStyles.subheadlineBold,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.year ?? '',
                          style: context.textStyles.caption1!.copyWith(
                            color: context.colors.textsSecondary,
                          ),
                        ),
                        if (widget.description != null)
                          const SizedBox(height: 12),
                        if (widget.description != null)
                          Text(
                            widget.description!.length > 280
                                ? widget.description!.substring(0, 280)
                                : widget.description!,
                            style: context.textStyles.subheadline,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum InfoDialogType { post, list, postComment, listComment }

class OtherProfileDialog extends ConsumerWidget {
  const OtherProfileDialog({
    Key? key,
    this.user,
    this.user1,
    this.type,
    this.entityId,
    this.myEntity,
    this.block = false,
  })  : assert(user == null || user1 == null),
        super(key: key);

  final UserDetailsModel? user;
  final UserModel? user1;
  final InfoDialogType? type;
  final int? entityId;
  final bool? myEntity;
  final bool block;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myself = ref.watch(myProfileInfoStateHolderProvider);
    final postId = ref.watch(posterStateHolderProvider);
    final listId = ref.watch(listsStateHolderProvider);
    int itemsCount = 0;
    if (user?.id != myself?.id && user1?.id != myself?.id) {
      itemsCount += 2;
      if (block) itemsCount++;
    }
    if (user?.id == myself?.id ||
        user1?.id == myself?.id ||
        myEntity == true && type == InfoDialogType.postComment ||
        myEntity == true && type == InfoDialogType.listComment) itemsCount++;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height:
                (itemsCount * 60) + MediaQuery.of(context).padding.bottom + 80,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
              child: SizedBox(
                height: itemsCount * 60 + 80,
                child: Material(
                  color: context.colors.backgroundsPrimary,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      children: [
                        const SizedBox(height: 14),
                        Container(
                          height: 4,
                          width: 36,
                          color: context.colors.fieldsDefault,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          (user?.name ?? user1?.name) ?? '',
                          style: context.textStyles.bodyBold,
                        ),
                        const SizedBox(height: 10.5),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              if (user != null) {
                                ref
                                    .read(commentsStateHolderProvider.notifier)
                                    .setFollowed(
                                      user!.id,
                                      !user!.followed,
                                    );
                                await ref
                                    .read(profileControllerApiProvider)
                                    .follow(
                                      user!.id,
                                      user!.followed,
                                    );
                              } else {
                                ref
                                    .read(commentsStateHolderProvider.notifier)
                                    .setFollowed(
                                      user1!.id,
                                      !user1!.followed,
                                    );
                                print("GG");
                                print(user1!.id);
                                await ref
                                    .read(profileControllerApiProvider)
                                    .follow(
                                      user1!.id,
                                      user1!.followed,
                                    );
                              }
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    (user?.followed ?? user1!.followed)
                                        ? '${context.txt.unfollow} ${user?.name ?? user1!.name}'
                                        : '${context.txt.follow} ${user?.name ?? user1!.name}',
                                    style: context.textStyles.bodyRegular,
                                  ),
                                  const Spacer(),
                                  Text(
                                    (user?.followed ?? user1!.followed)
                                        ? '􀜗'
                                        : '􀜕',
                                    style: context.textStyles.bodyRegular,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          InkWell(
                            onTap: () {
                              scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBars.build(
                                  context,
                                  null,
                                  //TODO: localize
                                  "Not available yet",
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    context.txt.report,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '􀉻',
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id != myself?.id &&
                            user1?.id != myself?.id &&
                            block)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id &&
                            user1?.id != myself?.id &&
                            block)
                          InkWell(
                            onTap: () {
                              if ((user?.id ?? user1?.id) == null) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBars.build(
                                    context,
                                    null,
                                    //TODO: localize
                                    "An error occured",
                                  ),
                                );
                                return;
                              }
                              if (user?.blocked == true) {
                                EditProfileApi().unblockAccount(
                                    id: (user?.id ?? user1?.id)!);
                              } else {
                                EditProfileApi()
                                    .blockAccount(id: (user?.id ?? user1?.id)!);
                              }
                              ref
                                  .read(profileInfoStateHolderProvider.notifier)
                                  .updateState(ref
                                      .watch(profileInfoStateHolderProvider)!
                                      .copyWith(
                                          blocked: !(ref
                                                  .watch(
                                                      profileInfoStateHolderProvider)
                                                  ?.blocked ??
                                              false)));
                              Navigator.pop(context);
                              //ref.watch(router)?.popUntil((route) => route.data?.path == '/');
                              //ref.read(homePagePostsControllerProvider).blockUser((user?.id ?? user1?.id)!);
                              //ref.read(pageTransitionControllerStateHolder)?.animateTo(ref.read(pageTransitionControllerStateHolder)?.upperBound ?? 0, duration: Duration.zero);
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    user?.blocked == true
                                        ? context.txt.profile_menu_unblock
                                        : context.txt.profile_menu_block,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id == myself?.id ||
                            user1?.id == myself?.id ||
                            myEntity == true &&
                                type == InfoDialogType.postComment ||
                            myEntity == true &&
                                type == InfoDialogType.listComment)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id == myself?.id ||
                            user1?.id == myself?.id ||
                            postId?.author.id == myself?.id &&
                                type == InfoDialogType.postComment ||
                            listId?.author.id == myself?.id &&
                                type == InfoDialogType.listComment)
                          InkWell(
                            onTap: () async {
                              if (type != null) {
                                switch (type!) {
                                  case InfoDialogType.post:
                                    {
                                      try {
                                        await ref
                                            .read(commentsControllerProvider)
                                            .deletePost(entityId!);
                                        ref
                                            .read(searchPostsStateHolderProvider
                                                .notifier)
                                            .deleteId(entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        ref
                                            .read(profileControllerApiProvider)
                                            .getUserInfo(null);
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete poster",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.list:
                                    {
                                      try {
                                        //Seems like this is not needed yet
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete list",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.postComment:
                                    {
                                      try {
                                        await ref
                                            .read(commentsControllerProvider)
                                            .deleteComment(
                                                postId!.id, entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete comment",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.listComment:
                                    {
                                      try {
                                        await ref
                                            .read(listsControllerProvider)
                                            .deleteComment(
                                                listId!.id, entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete comment",
                                          ),
                                        );
                                      }
                                    }
                                }
                              }
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    context.txt.delete,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (user?.id == myself?.id ||
                                      user1?.id == myself?.id)
                                    SvgPicture.asset(
                                      'assets/icons/ic_trash.svg',
                                      colorFilter: ColorFilter.mode(
                                        context.colors.textsError!,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}