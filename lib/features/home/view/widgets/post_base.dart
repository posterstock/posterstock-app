import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/helpers/page_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
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
  }) : super(key: key);

  final int? index;
  final PageHolder pageHolder = PageHolder();
  final bool showSuggestion;
  final GlobalKey<MovieCardState> postKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anyPost = index == null ? null : ref.watch(homePagePostsStateHolderProvider)?[index!];
    List<PostMovieModel>? post = anyPost?[0] is PostMovieModel ? anyPost?.map((e) => e as PostMovieModel).toList() : null;
    MultiplePostModel? multPost  = anyPost?[0] is MultiplePostModel ? (anyPost?[0]) as MultiplePostModel : null;
    UserModel? user;
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
            AutoRouter.of(context).push(
              PosterRoute(
                post: post![pageHolder.page],
                index: index ?? 0,
              ),
            );
          }
          if (multPost != null) {
            AutoRouter.of(context).push(
              ListRoute(
                post: multPost!,
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
                      ),
                    )
                  ],
                ),
              ),
              if (post == null && multPost == null || post != null)
                MovieCard(
                  key: postKey,
                  index: index!,
                  pageHolder: pageHolder,
                ),
              if (multPost != null)
                MultipleMovieCard(
                  post: multPost!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
    Key? key,
    this.loading = false,
    this.user,
    this.time,
    this.showFollowButton = true,
    this.darkBackground = false,
    this.showSettings = true,
    this.behavior,
  }) : super(key: key);

  final bool loading;
  final UserModel? user;
  final String? time;
  final bool showFollowButton;
  final bool darkBackground;
  final bool showSettings;
  final HitTestBehavior? behavior;

  @override
  Widget build(BuildContext context) {
    //TODO move avatar generation from view layer
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return ShimmerLoader(
      loaded: !loading,
      child: GestureDetector(
        behavior: behavior,
        onTap: () {
          if (user == null) return;
          AutoRouter.of(context).push(ProfileRoute(
            user: UserModel(
              id: 11,
              username: user!.username,
              name: user!.name,
              followed: user!.followed,
              description: user!.description,
              imagePath: user!.imagePath,
            ),
          ));
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: user?.imagePath != null
                      ? NetworkImage(user!.imagePath!)
                      : null,
                  backgroundColor: avatar[Random().nextInt(3)],
                  child: user?.imagePath == null && !loading
                      ? Text(
                    getAvatarName(user!.name).toUpperCase(),
                    style: context.textStyles.subheadlineBold!.copyWith(
                      color: context.colors.textsBackground,
                    ),
                  )
                      : const SizedBox(),
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
                      height: 42,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 68 - 179 + 42,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ExpandChecker(
                                  expand: !(user?.followed ?? true),
                                  child: TextOrContainer(
                                    text: user?.name,
                                    style: context.textStyles.calloutBold!
                                        .copyWith(
                                        color: darkBackground
                                            ? context.colors.textsBackground!
                                            : context.colors.textsPrimary),
                                    emptyWidth: 146,
                                    emptyHeight: 17,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                if ((user?.followed ?? true) ||
                                    !showFollowButton)
                                  Text(
                                    time ?? '',
                                    style: context.textStyles.footNote!
                                        .copyWith(
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
                          if (!loading)
                            Spacer(),
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
                  width: 81,
                  child: AppTextButton(
                    text: AppLocalizations.of(context)!.follow,
                    onTap: () {},
                  ),
                ),
              if (!loading && showSettings)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: OtherProfileDialog(
                                user1: user!,
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
      ),
    );
  }

  String getAvatarName(String name) {
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
