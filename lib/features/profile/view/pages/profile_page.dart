import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/services/text_info_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();

  final UserDetailsModel? user;
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    var profile = ref.watch(profileInfoStateHolderProvider);
    if (widget.user != null) {
      profile = widget.user;
    } else if (profile == null) {
      ref.read(profileControllerProvider).getUserInfo();
    }
    if (profile?.mySelf != null) {
      tabController ??= TabController(
          length: (profile?.mySelf ?? false) ? 3 : 2, vsync: this);
    }
    return CustomScaffold(
      child: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              pinned: false,
              floating: true,
              elevation: 0,
              expandedHeight: 210 +
                  TextInfoService.textSize(
                          profile?.description ?? '',
                          context.textStyles.footNote!,
                          MediaQuery.of(context).size.width - 32)
                      .height,
              toolbarHeight: 210 +
                  TextInfoService.textSize(
                          profile?.description ?? '',
                          context.textStyles.footNote!,
                          MediaQuery.of(context).size.width - 32)
                      .height,
              collapsedHeight: 210 +
                  TextInfoService.textSize(
                          profile?.description ?? '',
                          context.textStyles.footNote!,
                          MediaQuery.of(context).size.width - 32)
                      .height,
              backgroundColor: context.colors.backgroundsPrimary,
              centerTitle: true,
              title: const SizedBox(),
              leadingWidth: 65,
              leading: (profile?.mySelf ?? false)
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).pop();
                        },
                        child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(left: 7.0, right: 40.0),
                            child:
                                SvgPicture.asset('assets/icons/back_icon.svg', width: 18,),),
                      ),
                    ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        profile?.username ?? 'Profile',
                        style: context.textStyles.bodyBold,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: context.colors.backgroundsSecondary,
                          backgroundImage: profile?.imagePath == null
                              ? null
                              : Image.network(
                                  profile!.imagePath!,
                                  fit: BoxFit.cover,
                                ).image,
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.followers.toString() ?? '0',
                              style: context.textStyles.headline,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppLocalizations.of(context)!.followers,
                              style: context.textStyles.caption1!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.following.toString() ?? '0',
                              style: context.textStyles.headline,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppLocalizations.of(context)!.following,
                              style: context.textStyles.caption1!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.name ?? '',
                              style: context.textStyles.headline,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_collection.svg',
                                  colorFilter: ColorFilter.mode(
                                    context.colors.iconsDefault!,
                                    BlendMode.srcIn,
                                  ),
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  profile?.posters.toString() ?? '0',
                                  style: context.textStyles.caption1!.copyWith(
                                      color: context.colors.textsPrimary),
                                ),
                                const SizedBox(width: 12),
                                SvgPicture.asset(
                                  'assets/icons/ic_lists.svg',
                                  colorFilter: ColorFilter.mode(
                                    context.colors.iconsDefault!,
                                    BlendMode.srcIn,
                                  ),
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  profile?.lists.toString() ?? '0',
                                  style: context.textStyles.caption1!.copyWith(
                                      color: context.colors.textsPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        AppTextButton(
                          text: (profile?.mySelf ?? false)
                              ? 'Edit'
                              : ((profile?.followed ?? false)
                                  ? AppLocalizations.of(context)!
                                      .following
                                      .capitalize()
                                  : AppLocalizations.of(context)!.follow),
                          backgroundColor: ((profile?.mySelf ?? false) ||
                                  (profile?.followed ?? false))
                              ? context.colors.fieldsDefault
                              : null,
                          textColor: ((profile?.mySelf ?? false) ||
                                  (profile?.followed ?? false))
                              ? context.colors.textsPrimary
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      profile?.description ?? '',
                      style: context.textStyles.footNote,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: context.colors.backgroundsPrimary,
              elevation: 0,
              expandedHeight: 48,
              collapsedHeight: 48,
              toolbarHeight: 48,
              pinned: true,
              leading: const SizedBox(),
              flexibleSpace: tabController == null
                  ? SizedBox()
                  : TabBar(
                      dividerColor: Colors.transparent,
                      controller: tabController,
                      indicatorColor: context.colors.iconsActive,
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            "Collection",
                            style: context.textStyles.subheadline,
                          ),
                        ),
                        if (profile?.mySelf ?? false)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              "Bookmarks",
                              style: context.textStyles.subheadline,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Text(
                            "Lists",
                            style: context.textStyles.subheadline,
                          ),
                        ),
                      ],
                    ),
            ),
          ];
        },
        body: tabController == null
            ? SizedBox()
            : ProfileTabs(
                controller: tabController!,
              ),
      ),
    );
  }
}

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({Key? key, required this.controller}) : super(key: key);
  final TabController controller;

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: [
        CollectionView(),
        if (widget.controller.length == 3) const SizedBox(),
        const SizedBox(),
      ],
    );
  }
}

class CollectionView extends ConsumerWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PostMovieModel> movies = [];
    List<List>? helper = ref.watch(homePagePostsStateHolderProvider);
    if (helper != null) {
      for (var i in helper) {
        if (i[0] is PostMovieModel) {
          movies.add(i[0]);
          movies.add(i[0]);
        }
        if (i.length > 1 && i[1] is PostMovieModel) {
          movies.add(i[1]);
        }
      }
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.5,
        mainAxisSpacing: 15,
        mainAxisExtent:
            ((MediaQuery.of(context).size.width - 57) / 3) / 106 * 160 + 32,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return CollectionTile(movie: movies[index]);
      },
    );
  }
}

class CollectionTile extends StatelessWidget {
  const CollectionTile({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final PostMovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                useSafeArea: false,
                builder: (context) {
                  return PosterImageDialog(
                    movie: movie,
                  );
                });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: context.colors.buttonsPrimary,
              height: 160,
              child: Image.network(
                movie.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.year.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}

class PosterImageDialog extends StatefulWidget {
  const PosterImageDialog({
    super.key,
    required this.movie,
  });

  final PostMovieModel movie;

  @override
  State<PosterImageDialog> createState() => _PosterImageDialogState();
}

class _PosterImageDialogState extends State<PosterImageDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

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
      onPointerUp: (d) {
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
              child: Transform.translate(
                offset: const Offset(0, -80),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: context.colors.buttonsPrimary,
                        height: 160,
                        width: 106,
                        child: Image.network(
                          widget.movie.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.all(18.0),
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: context.colors.backgroundsPrimary,
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.name,
                              style: context.textStyles.subheadlineBold,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.movie.year.toString(),
                              style: context.textStyles.caption1!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              (widget.movie.description ?? '').length > 280
                                  ? widget.movie.description!.substring(0, 280)
                                  : (widget.movie.description ?? ''),
                              style: context.textStyles.subheadline,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
