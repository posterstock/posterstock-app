import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/home/controller/home_page_posts_controller.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/helpers/page_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/features/user/notifiers/user_notifier.dart';
import 'package:poster_stock/features/user/user_page.dart';

import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/widgets/app_text_button.dart';
import 'movie_card.dart';
import 'multiple_movie_card.dart';

class PostBase extends ConsumerWidget {
  PostBase({
    Key? key,
    this.index,
    this.showSuggestion = true,
    this.poster,
  }) : super(key: key);

  final int? index;
  final PageHolder pageHolder = PageHolder();
  final bool showSuggestion;
  final PostMovieModel? poster;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anyPost = index == null
        ? null
        : ref.watch(homePagePostsStateHolderProvider)?[index!];
    List<PostMovieModel>? post = anyPost?[0] is PostMovieModel
        ? anyPost?.map((e) => e as PostMovieModel).toList()
        : null;
    MultiplePostModel? multPost = anyPost?[0] is MultiplePostModel
        ? (anyPost?[0]) as MultiplePostModel
        : null;
    UserModel? user;
    if (post == null && poster != null) {
      post = [poster!];
    }
    if (post != null) {
      user = post[0].author;
    } else if (multPost != null) {
      user = multPost.author;
    }

    if (user != null) {
      final userSearch = ref.watch(userNotifier(user.id));
      if (userSearch != null) {
        user = user.copyWith(isArtist: userSearch.isArtist);
      }
    }

    return Material(
      color: context.colors.backgroundsPrimary,
      child: CustomInkWell(
        onTap: () {
          if (post != null) {
            ref.watch(router)!.push(
                  PosterRoute(
                    postId: post[pageHolder.page].id,
                    likes: post[pageHolder.page].likes,
                    liked: post[pageHolder.page].liked,
                    comments: post[pageHolder.page].comments,
                  ),
                );
          }
          if (multPost != null) {
            ref.watch(router)!.push(ListRoute(id: multPost.id));
          }
        },
        child: ShimmerLoader(
          loaded: post != null || multPost != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((post != null || multPost != null) &&
                        !user!.followed &&
                        showSuggestion)
                      Padding(
                        padding: const EdgeInsets.only(left: 68.0),
                        child: Text(
                          context.txt.home_feed_suggestions,
                          style: context.textStyles.caption1!.copyWith(
                            color: context.colors.textsDisabled,
                          ),
                        ),
                      ),
                    if ((post != null || multPost != null) && !user!.followed)
                      const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: UserInfoTile(
                        loading: post == null && multPost == null,
                        time: post?[0].time ?? multPost?.time,
                        user: user,
                        showFollowButton: poster == null,
                        type: post == null
                            ? InfoDialogType.list
                            : InfoDialogType.post,
                        entityId: post?[0].id ?? multPost?.id ?? -1,
                      ),
                    )
                  ],
                ),
              ),
              if (poster != null)
                MovieCard(
                  key: key,
                  poster: poster,
                  pageHolder: pageHolder,
                ),
              if (post == null && multPost == null && poster == null ||
                  post != null && poster == null)
                MovieCard(
                  key: key,
                  index: index!,
                  pageHolder: pageHolder,
                ),
              if (multPost != null)
                MultipleMovieCard(
                  post: multPost,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoTile extends ConsumerWidget {
  const UserInfoTile({
    Key? key,
    this.loading = false,
    this.user,
    this.time,
    this.showFollowButton = true,
    this.darkBackground = false,
    this.showSettings = true,
    this.behavior,
    this.controller,
    this.onInfoTap,
    required this.type,
    required this.entityId,
    this.myEntity,
  }) : super(key: key);

  final bool loading;
  final UserModel? user;
  final String? time;
  final bool showFollowButton;
  final bool darkBackground;
  final bool showSettings;
  final HitTestBehavior? behavior;
  final ScrollController? controller;
  final void Function()? onInfoTap;
  final InfoDialogType type;
  final int entityId;
  final bool? myEntity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShimmerLoader(
      loaded: !loading,
      child: InkWell(
        onTap: () {
          if (user == null) return;
          // ref.watch(router)!.pushNamed('/${user!.username}');
          context
              .pushRoute(UserRoute(args: UserArgs(user!.id, user!.username)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IgnorePointer(
              ignoring: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  width: 40.0,
                  child: user?.imagePath == null
                      ? CircleAvatar(
                          radius: 20.0,
                          backgroundColor: user?.color,
                          child: Text(
                            getAvatarName(
                                    user?.name ?? 'AA', user?.username ?? '')
                                .toUpperCase(),
                            style: context.textStyles.subheadlineBold!.copyWith(
                              color: context.colors.textsBackground,
                            ),
                          ))
                      : ClipOval(
                          child: CachedNetworkImage(
                            width: 40.0,
                            height: 40.0,
                            imageUrl: user!.imagePath!,
                            errorWidget: (c, o, t) => shimmer,
                            placeholderFadeInDuration:
                                CustomDurations.cachedDuration,
                            fadeInDuration: CustomDurations.cachedDuration,
                            fadeOutDuration: CustomDurations.cachedDuration,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 41,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExpandChecker(
                                expand: (showFollowButton) &&
                                    (!(user?.followed ?? true)),
                                child: NameWithArtistPoster(
                                  name: user?.name ?? '',
                                  isArtist: user?.isArtist ?? false,
                                  darkBackground: darkBackground,
                                  emptyWidth: 146,
                                  emptyHeight: 17,
                                  overflow: TextOverflow.ellipsis,
                                  isFlexible: false,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              if (!((showFollowButton) &&
                                  (!(user?.followed ?? true))))
                                Text(
                                  time ?? '',
                                  style: context.textStyles.footNote!.copyWith(
                                    color: darkBackground
                                        ? context.colors.textsBackground!
                                            .withOpacity(0.8)
                                        : context.colors.textsDisabled,
                                  ),
                                ),
                            ],
                          ),
                          if (loading)
                            const SizedBox(
                              height: 3,
                            ),
                          if (!loading) const Spacer(),
                          TextOrContainer(
                            text: user?.username == null
                                ? null
                                : '@${user!.username}',
                            style: context.textStyles.caption1!.copyWith(
                              color: darkBackground
                                  ? context.colors.textsBackground!
                                      .withOpacity(0.8)
                                  : context.colors.textsSecondary,
                            ),
                            emptyWidth: 120,
                            emptyHeight: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!(user?.followed ?? true) && (!loading) && showFollowButton)
              SizedBox(
                width: TextInfoService.textSize(
                            context.txt.follow, context.textStyles.calloutBold!)
                        .width +
                    32,
                child: AppTextButton(
                  text: context.txt.follow,
                  onTap: () async {
                    ref.read(homePagePostsControllerProvider).setFollowId(
                          user!.id,
                          user!.followed,
                        );
                    await ref.read(profileControllerApiProvider).follow(
                          user!.id,
                          user!.followed,
                        );
                  },
                ),
              ),
            if (!loading && showSettings)
              GestureDetector(
                onTap: () {
                  if (onInfoTap != null) {
                    onInfoTap!();
                    return;
                  }
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
                        child: OtherProfileDialog(
                          user1: user!,
                          type: type,
                          entityId: entityId,
                          myEntity: myEntity,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 5.0),
                  child: SvgPicture.asset(
                    'assets/icons/ic_dots.svg',
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      context.colors.iconsLayer!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String getAvatarName(String name, String username) {
    if (name.isEmpty) return username[0];
    String result = name[0];
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ' && i != name.length - 1) {
        result += name[i + 1];
        break;
      }
    }
    return result;
  }
}
