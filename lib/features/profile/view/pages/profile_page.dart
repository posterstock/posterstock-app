import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/edit_profile/state_holder/avatar_state_holder.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/state_holders/home_page_posts_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/peek_pop/peek_and_pop_dialog.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';
import 'package:poster_stock/features/profile/view/empty_collection_widget.dart';
import 'package:poster_stock/features/users_list/view/users_list_page.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/services/text_info_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    Key? key,
    this.user,
  }) : super(key: key);

  final UserModel? user;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with TickerProviderStateMixin {
  TabController? tabController;
  late final AnimationController animationController;
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 300),
    );
    Future(() {
      ref.read(profileControllerApiProvider).clearUser();
    });
  }

  static const List<Color> avatar = [
    Color(0xfff09a90),
    Color(0xfff3d376),
    Color(0xff92bdf4),
  ];

  @override
  Widget build(BuildContext context) {
    var profile = ref.watch(profileInfoStateHolderProvider);
    final photo = ref.watch(avatarStateHolderProvider);
    bool myself = widget.user?.id == null;
    //TODO
    print(profile == null);
    if (profile == null || widget.user?.name != profile.name) {
      ref.read(profileControllerApiProvider).getUserInfo(widget.user?.id);
    }
    if (myself == true && tabController?.length != 3) {
      tabController = TabController(
        length: 3,
        vsync: this,
      );
    } else if (tabController?.length != 2) {
      tabController = TabController(
        length: 2,
        vsync: this,
      );
    }
    return CustomScaffold(
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (details) {
          if (((details.scrollDelta ?? 1) < 0 ||
                  animationController.value > 0) &&
              animationController.value > 0 &&
              details.metrics.pixels <= 245) {
            animationController.animateTo(
              (details.metrics.pixels < 0 ? 0 : details.metrics.pixels) / 245,
              duration: Duration.zero,
            );
          }
          return true;
        },
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          controller: scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                pinned: false,
                floating: true,
                elevation: 0,
                expandedHeight: 225 +
                    ((profile?.description != null)
                        ? TextInfoService.textSize(
                                profile?.description ?? '',
                                context.textStyles.footNote!,
                                MediaQuery.of(context).size.width - 32)
                            .height
                        : 0),
                toolbarHeight: 225 +
                    ((profile?.description != null)
                        ? TextInfoService.textSize(
                                profile?.description ?? '',
                                context.textStyles.footNote!,
                                MediaQuery.of(context).size.width - 32)
                            .height
                        : 0),
                collapsedHeight: 225 +
                    ((profile?.description != null)
                        ? TextInfoService.textSize(
                                profile?.description ?? '',
                                context.textStyles.footNote!,
                                MediaQuery.of(context).size.width - 32)
                            .height
                        : 0),
                backgroundColor: context.colors.backgroundsPrimary,
                centerTitle: true,
                leading: SizedBox(),
                title: const SizedBox(),
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 65,
                          child: (myself)
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      AutoRouter.of(context).pop();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.only(
                                          left: 7.0, right: 31.0),
                                      child: SvgPicture.asset(
                                        'assets/icons/back_icon.svg',
                                        width: 18,
                                        colorFilter: ColorFilter.mode(
                                          context.colors.iconsDefault!,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const Spacer(),
                        Text(
                          profile?.username ?? 'Profile',
                          style: context.textStyles.bodyBold,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (myself == true) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return MyProfileDialog(
                                    animationController: animationController,
                                    scrollController: scrollController,
                                    focusNode: focusNode,
                                  );
                                },
                                backgroundColor: Colors.transparent,
                              );
                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => OtherProfileDialog(
                                  user: profile!,
                                ),
                                backgroundColor: Colors.transparent,
                              );
                            }
                          },
                          child: Container(
                            width: 65,
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SvgPicture.asset(
                                  'assets/icons/ic_dots_vertical.svg',
                                  width: 12,
                                  colorFilter: ColorFilter.mode(
                                      context.colors.iconsDefault!,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            children: [
                              ShimmerLoader(
                                loaded: profile != null,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: profile?.imagePath != null
                                      ? Image.network(profile!.imagePath!,
                                              fit: BoxFit.cover)
                                          .image
                                      : (photo == null || myself != true
                                          ? null
                                          : Image.memory(
                                              photo,
                                              fit: BoxFit.cover,
                                              cacheWidth: 150,
                                            ).image),
                                  backgroundColor: avatar[Random().nextInt(3)],
                                  child: profile?.imagePath == null &&
                                              profile?.name != null ||
                                          photo == null && myself == true
                                      ? Text(
                                          getAvatarName(profile?.name ?? '')
                                              .toUpperCase(),
                                          style: context.textStyles.title3!
                                              .copyWith(
                                            color:
                                                context.colors.textsBackground,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                              const SizedBox(
                                width: 38,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AutoRouter.of(context).push(
                                    UsersListRoute(
                                      user: List.generate(
                                        20,
                                        (index) => UserModel(
                                          id: 1,
                                          name: 'Name $index',
                                          username: 'username$index',
                                          followed: false,
                                          imagePath: index % 2 == 0
                                              ? 'https://sun9-19.userapi.com/impg/JYz26AJyJy7WGCILcB53cuVK7IgG8kz7mW2h7g/YuMDQr8n2Lc.jpg?size=300x245&quality=96&sign=a881f981e785f06c51dff40d3262565f&type=album'
                                              : 'https://sun9-63.userapi.com/impg/eV4ZjNdv2962fzcxP3sivERc4kN64GhCFTRNZw/_5JxseMZ_0g.jpg?size=267x312&quality=95&sign=efb3d7b91e0b102fa9b62d7dc8724050&type=album',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShimmerLoader(
                                        loaded: profile != null,
                                        child: TextOrContainer(
                                          text: profile?.followers == null
                                              ? null
                                              : profile!.followers.toString(),
                                          style: context.textStyles.headline,
                                          emptyWidth: 35,
                                          emptyHeight: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.followers,
                                        style: context.textStyles.caption1!
                                            .copyWith(
                                          color: context.colors.textsSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 36,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AutoRouter.of(context).push(
                                    UsersListRoute(
                                      following: true,
                                      user: List.generate(
                                        20,
                                        (index) => UserModel(
                                          id: 1,
                                          name: 'Name $index',
                                          username: 'username$index',
                                          followed: false,
                                          imagePath: index % 2 == 0
                                              ? 'https://sun9-19.userapi.com/impg/JYz26AJyJy7WGCILcB53cuVK7IgG8kz7mW2h7g/YuMDQr8n2Lc.jpg?size=300x245&quality=96&sign=a881f981e785f06c51dff40d3262565f&type=album'
                                              : 'https://sun9-63.userapi.com/impg/eV4ZjNdv2962fzcxP3sivERc4kN64GhCFTRNZw/_5JxseMZ_0g.jpg?size=267x312&quality=95&sign=efb3d7b91e0b102fa9b62d7dc8724050&type=album',
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShimmerLoader(
                                        loaded: profile != null,
                                        child: TextOrContainer(
                                          text: profile?.following == null
                                              ? null
                                              : profile!.followers.toString(),
                                          style: context.textStyles.headline,
                                          emptyWidth: 35,
                                          emptyHeight: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.following,
                                        style: context.textStyles.caption1!
                                            .copyWith(
                                          color: context.colors.textsSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: profile == null ? 20 : 12,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerLoader(
                                    loaded: profile != null,
                                    child: TextOrContainer(
                                      text: profile?.name,
                                      style: context.textStyles.headline,
                                      emptyWidth: 150,
                                      emptyHeight: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (profile == null)
                                    const ShimmerLoader(
                                        child: TextOrContainer(
                                      text: null,
                                      emptyWidth: 80,
                                      emptyHeight: 20,
                                    )),
                                  if (profile != null)
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
                                        //TODO
                                        /*Text(
                                          profile?.posters.toString() ?? '0',
                                          style: context.textStyles.caption1!
                                              .copyWith(
                                                  color: context
                                                      .colors.textsPrimary),
                                        ),*/
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
                                        /*Text(
                                          profile?.lists.toString() ?? '0',
                                          style: context.textStyles.caption1!
                                              .copyWith(
                                                  color: context
                                                      .colors.textsPrimary),
                                        ),*/
                                      ],
                                    ),
                                ],
                              ),
                              const Spacer(),
                              AppTextButton(
                                onTap: () {
                                  if (myself ?? false) {
                                    AutoRouter.of(context)
                                        .push(EditProfileRoute());
                                  }
                                },
                                text: (myself ?? false)
                                    ? 'Edit'
                                    : ((profile?.followed ?? false)
                                        ? AppLocalizations.of(context)!
                                            .following
                                            .capitalize()
                                        : AppLocalizations.of(context)!.follow),
                                backgroundColor: ((myself ?? false) ||
                                        (profile?.followed ?? false))
                                    ? context.colors.fieldsDefault
                                    : null,
                                textColor: ((myself ?? false) ||
                                        (profile?.followed ?? false))
                                    ? context.colors.textsPrimary
                                    : null,
                              ),
                            ],
                          ),
                          if (profile?.description != null)
                            const SizedBox(
                              height: 12,
                            ),
                          if (profile?.description != null)
                            Text(
                              profile!.description!,
                              style: context.textStyles.footNote,
                            ),
                          if (profile?.description != null)
                            const SizedBox(
                              height: 16,
                            ),
                        ],
                      ),
                    ),
                  ],
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
                flexibleSpace:
                    tabController == null || tabController?.animation == null
                        ? const SizedBox()
                        : ProfileTabBar(
                            animation: tabController!.animation!,
                            tabController: tabController,
                            profile: profile,
                            myself: myself,
                          ),
              ),
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: animationController.value,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.0,
                            16.0 * animationController.value,
                            16.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: animationController.value * 34 + 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: searchController,
                                    searchField: true,
                                    hint: 'Search',
                                    removableWhenNotEmpty: true,
                                    crossPadding: const EdgeInsets.all(8.0),
                                    crossButton: SvgPicture.asset(
                                      'assets/icons/search_cross.svg',
                                    ),
                                    style: context.textStyles.callout!.copyWith(
                                      fontSize: context.textStyles.callout!
                                                      .fontSize! *
                                                  animationController.value <
                                              1
                                          ? 1
                                          : context.textStyles.callout!
                                                  .fontSize! *
                                              animationController.value,
                                    ),
                                    focus: focusNode,
                                    onRemoved: () {
                                      searchController.clear();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    'Cancel',
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsAction,
                                      fontSize: context.textStyles.bodyRegular!
                                                      .fontSize! *
                                                  animationController.value <
                                              1
                                          ? 1
                                          : context.textStyles.bodyRegular!
                                                  .fontSize! *
                                              animationController.value,
                                    ),
                                  ),
                                  onPressed: () {
                                    animationController.animateTo(0);
                                    focusNode.unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ];
          },
          body: tabController == null
              ? const SizedBox()
              : ProfileTabs(
                  controller: tabController!,
                  //TODO
                  name: widget.user?.name,
                ),
        ),
      ),
    );
  }

  String getAvatarName(String name) {
    if (name.isEmpty) return name;
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

class ProfileTabs extends ConsumerStatefulWidget {
  const ProfileTabs({
    Key? key,
    required this.controller,
    this.name,
  }) : super(key: key);
  final TabController controller;
  final String? name;

  @override
  ConsumerState<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends ConsumerState<ProfileTabs>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final posters = ref.watch(profilePostsStateHolderProvider);
    return TabBarView(
      controller: widget.controller,
      children: [
        PostsCollectionView(
          movies: posters,
          name: widget.name,
        ),
        if (widget.controller.length == 3)
          PostsCollectionView(
            movies: [],
            bookmark: true,
            customOnItemTap: (post, index) {
              AutoRouter.of(context).push(
                BookmarksRoute(startIndex: index),
              );
            },
            customOnLongTap: () {},
          ),
        GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 13.0,
            mainAxisSpacing: 16.0,
            mainAxisExtent: 113,
          ),
          itemCount: 0,
          itemBuilder: (context, index) {
            //return ListGridWidget(post: lists[index]);
          },
        ),
      ],
    );
  }
}

class PostsCollectionView extends ConsumerWidget {
  const PostsCollectionView({
    Key? key,
    this.movies,
    this.customOnItemTap,
    this.customOnLongTap,
    this.name,
    this.bookmark = false,
  }) : super(key: key);
  final List<PostMovieModel>? movies;
  final void Function(PostMovieModel, int)? customOnItemTap;
  final void Function()? customOnLongTap;
  final String? name;
  final bool bookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movies?.isEmpty == true) {
      return Column(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height - 480 - 56) / 2,
          ),
          SizedBox(
            width: name == null ? 170 : 250,
            child: EmptyCollectionWidget(
              profileName: name == null || name!.isEmpty ? null : name!,
              bookmark: bookmark,
            ),
          ),
        ],
      );
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.5,
        mainAxisSpacing: 15,
        mainAxisExtent: 201,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemCount: movies == null ? 30 : movies!.length,
      itemBuilder: (context, index) {
        if (movies == null) {
          return ShimmerLoader(
            loaded: false,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: context.colors.backgroundsSecondary,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.caption2!.copyWith(
                    color: context.colors.textsPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '',
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
        return PostsCollectionTile(
          post: movies![index],
          customOnItemTap: customOnItemTap,
          customOnLongTap: customOnLongTap,
          index: index,
        );
      },
    );
  }
}

class PostsCollectionTile extends StatelessWidget {
  const PostsCollectionTile({
    Key? key,
    this.post,
    this.customOnItemTap,
    required this.index,
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

  @override
  Widget build(BuildContext context) {
    return PeekAndPopDialog(
      customOnLongTap: customOnLongTap,
      onTap: () {
        if (post != null) {
          if (customOnItemTap == null) {
            AutoRouter.of(context).push(
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
          imagePath: imagePath ?? post!.imagePath,
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
              height: 160,
              child: Image.network(
                post == null ? imagePath! : post!.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post == null ? name! : post!.name,
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
        print(1);
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
                    color: context.colors.buttonsPrimary,
                    height: 300,
                    width: 200,
                    child: Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.name != null)
                  Container(
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

class OtherProfileDialog extends ConsumerWidget {
  const OtherProfileDialog({
    Key? key,
    this.user,
    this.user1,
  })  : assert(user == null || user1 == null),
        super(key: key);

  final UserDetailsModel? user;
  final UserModel? user1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            height: 214 + MediaQuery.of(context).padding.bottom,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
              child: SizedBox(
                height: 214,
                child: Material(
                  color: context.colors.backgroundsPrimary,
                  child: Column(
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
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.fieldsDefault,
                      ),
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Text(
                                'Unfollow',
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              Text(
                                '􀜗',
                                style: context.textStyles.bodyRegular,
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.fieldsDefault,
                      ),
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Text(
                                'Report',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '􀉻',
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
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
    );
  }
}

class MyProfileDialog extends ConsumerWidget {
  const MyProfileDialog({
    Key? key,
    required this.animationController,
    required this.scrollController,
    required this.focusNode,
  }) : super(key: key);
  final AnimationController animationController;
  final ScrollController scrollController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: SizedBox(
                      height: 104,
                      child: Material(
                        color: context.colors.backgroundsPrimary,
                        child: Column(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  AutoRouter.of(context)
                                      .push(const SettingsRoute());
                                },
                                child: Center(
                                  child: Text(
                                    'Settings',
                                    style: context.textStyles.bodyRegular,
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
                                  animationController.animateTo(1);
                                  scrollController.animateTo(
                                    245,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                  focusNode.requestFocus();
                                  Navigator.pop(context);
                                },
                                child: Center(
                                  child: Text(
                                    'Search 􀊫',
                                    style: context.textStyles.bodyRegular,
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
        ),
      ),
    );
  }
}

class ProfileTabBar extends AnimatedWidget {
  const ProfileTabBar({
    super.key,
    required Animation<double> animation,
    this.tabController,
    this.profile,
    required this.myself,
  }) : super(listenable: animation);

  final TabController? tabController;
  final UserDetailsModel? profile;
  final bool myself;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return TabBar(
      dividerColor: Colors.transparent,
      controller: tabController,
      indicatorColor: context.colors.iconsActive,
      tabs: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            "Collection",
            style: animation.value >= 0 && animation.value <= 0.5
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
        if (myself ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              "Bookmarks",
              style: animation.value > 0.5 && animation.value <= 1.5
                  ? context.textStyles.subheadlineBold
                  : context.textStyles.subheadline,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            "Lists",
            style: animation.value > 1.5 && animation.value <= 2
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
      ],
    );
  }
}
