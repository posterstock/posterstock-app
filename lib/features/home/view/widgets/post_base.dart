import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
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
            ref.watch(router)!.push(
              ListRoute(
                id: multPost.id,
              ),
            );
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
                          AppLocalizations.of(context)!.sugPost,
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
                        type: post == null ? InfoDialogType.list : InfoDialogType.post,
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
              if (post == null && multPost == null && poster == null || post != null && poster == null)
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
          ref.watch(router)!.pushNamed(
              '/${user!.username}'
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IgnorePointer(
              ignoring: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: user?.imagePath != null
                      ? NetworkImage(user!.imagePath!)
                      : null,
                  backgroundColor: user?.color,
                  child: user?.imagePath == null && !loading
                      ? Text(
                          getAvatarName(user?.name ?? 'AA', user?.username ?? '').toUpperCase(),
                          style: context.textStyles.subheadlineBold!.copyWith(
                            color: context.colors.textsBackground,
                          ),
                        )
                      : const SizedBox(),
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
                  SizedBox(
                    height: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: (showFollowButton) &&
                                  (!(user?.followed ?? true))
                              ? MediaQuery.of(context).size.width -
                                  70 -
                                  179 +
                                  42
                              : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExpandChecker(
                                expand: (showFollowButton) &&
                                    (!(user?.followed ?? true)),
                                child: TextOrContainer(
                                  text: user?.name,
                                  style: context.textStyles.calloutBold!
                                      .copyWith(
                                          color: darkBackground
                                              ? context
                                                  .colors.textsBackground!
                                              : context.colors.textsPrimary),
                                  emptyWidth: 146,
                                  emptyHeight: 17,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              if (!((showFollowButton) &&
                                  (!(user?.followed ?? true))))
                                Text(
                                  time ?? '',
                                  style:
                                      context.textStyles.footNote!.copyWith(
                                    color: darkBackground
                                        ? context.colors.textsBackground!
                                            .withOpacity(0.8)
                                        : context.colors.textsDisabled,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (loading)
                          SizedBox(
                            height: 3,
                          ),
                        if (!loading) Spacer(),
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
                ],
              ),
            ),
            if (!(user?.followed ?? true) && (!loading) && showFollowButton)
              SizedBox(
                width: TextInfoService.textSize(
                            AppLocalizations.of(context)!.follow,
                            context.textStyles.calloutBold!)
                        .width +
                    32,
                child: AppTextButton(
                  text: AppLocalizations.of(context)!.follow,
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
