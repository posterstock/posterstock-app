import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/common/helpers/string_extension.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_tab_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/features/profile/view/widgets/count_indicator.dart';
import 'package:poster_stock/features/poster/view/widgets/poster_tile.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_avatar.dart';
import 'package:poster_stock/features/profile/view/widgets/simple_empty_collection.dart';
import 'package:poster_stock/features/profile/view/widgets/wait_screen.dart';
import 'package:poster_stock/features/user/notifiers/user_lists_notifier.dart';
import 'package:poster_stock/features/user/notifiers/user_notifier.dart';
import 'package:poster_stock/features/user/notifiers/user_posters_notifier.dart';
import 'package:poster_stock/features/user/user_controller.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:share_plus/share_plus.dart';

//TODO: replace all read(router)/watch(router) by context.router

@RoutePage()
class UserPage extends ConsumerWidget {
  final UserArgs args;

  const UserPage({
    required this.args,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userControllerProvider(args.id));
    final user = ref.watch(userNotifier(args.id));
    return user == null ? WaitProfile(args.username) : UserPage2(args: args);
  }
}

class UserPage2 extends ConsumerStatefulWidget {
  final UserArgs args;

  const UserPage2({
    required this.args,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<UserPage2> with TickerProviderStateMixin {
  final focusNode = FocusNode();
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(color: Colors.grey),
  );
  late final animationController = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 1,
    duration: const Duration(milliseconds: 300),
  );
  late final tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(userNotifier(widget.args.id).notifier);
    final user = ref.watch(userNotifier(widget.args.id));
    return CustomScaffold(
        child: NotificationListener<ScrollUpdateNotification>(
      onNotification: (details) {
        if (((details.scrollDelta ?? 1) < 0 || animationController.value > 0) &&
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
              expandedHeight: toolbarHeight(user),
              toolbarHeight: toolbarHeight(user),
              collapsedHeight: toolbarHeight(user),
              backgroundColor: context.colors.backgroundsPrimary,
              leading: const SizedBox(),
              centerTitle: true,
              title: const SizedBox(),
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  ProfileAppbar(
                    user.username,
                    onBack: context.back,
                    onMenuClick: openContextMenu,
                    bg: Colors.amber,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            ProfileAvatar(user),
                            const SizedBox(width: 38),
                            GestureDetector(
                              onTap: () {
                                context.pushRoute(
                                  UsersListRoute(id: user.id),
                                );
                              },
                              child: CountIndicator(
                                context.txt.profile_followers,
                                user.followers,
                              ),
                            ),
                            const SizedBox(width: 36),
                            GestureDetector(
                              onTap: () {
                                context.pushRoute(UsersListRoute(
                                  following: true,
                                  id: user.id,
                                ));
                              },
                              child: CountIndicator(
                                context.txt.profile_following,
                                user.following,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextOrContainer(
                                  text: user.name,
                                  style: context.textStyles.headline,
                                  emptyWidth: 150,
                                  emptyHeight: 20,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        tabController.animateTo(0);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
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
                                                user.posters.toString(),
                                                style: context
                                                    .textStyles.caption1!
                                                    .copyWith(
                                                        color: context.colors
                                                            .textsPrimary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        tabController.animateTo(
                                            tabController.length - 1);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 12),
                                              SvgPicture.asset(
                                                'assets/icons/lists.svg',
                                                colorFilter: ColorFilter.mode(
                                                  context.colors.iconsDefault!,
                                                  BlendMode.srcIn,
                                                ),
                                                width: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                user.lists.toString(),
                                                style: context
                                                    .textStyles.caption1!
                                                    .copyWith(
                                                        color: context.colors
                                                            .textsPrimary),
                                              ),
                                              const SizedBox(width: 8.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            AppTextButton(
                              onTap: () {
                                controller.toggleFollow();
                              },
                              text: user.followed
                                  ? context.txt.profile_following.capitalize()
                                  : context.txt.follow,
                              backgroundColor: user.followed
                                  ? context.colors.fieldsDefault
                                  : null,
                              textColor: user.followed
                                  ? context.colors.textsPrimary
                                  : null,
                            ),
                            // AppTextButton(
                            //   onTap: () {
                            //     ref.watch(router)!.push(EditProfileRoute());
                            //   },
                            //   text: context.txt.edit.capitalize(),
                            //   backgroundColor: context.colors.fieldsDefault,
                            //   textColor: context.colors.textsPrimary,
                            // ),
                          ],
                        ),
                        if (user.description != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12,
                              bottom: 16,
                            ),
                            child: Text(
                              user.description!,
                              style: context.textStyles.footNote,
                            ),
                          ),
                      ],
                    ),
                  )
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
                flexibleSpace: AppTabBar(tabController, [
                  context.txt.profile_watched,
                  context.txt.lists,
                ])),
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
                              child: SearchField(
                                animationController: animationController,
                                focusNode: focusNode,
                                searchController: searchController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Text(
                                context.txt.cancel,
                                style: context.textStyles.bodyRegular!.copyWith(
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
                },
              ),
            ),
          ];
        },
        body: ProfileTabs(
          animationController: animationController,
          searchTextController: searchController,
          shimmer: shimmer,
          controller: tabController,
          name: user!.name,
          id: user!.id,
          callback: (poster, index) =>
              ref.read(router)!.push(PosterRoute(postId: poster.id)),
          /*
                        /*
          ref.watch(router)!.push(
                  PosterRoute(
                    postId: post!.id,
                  ),
                );
          */
              */
          /*
                  if (post?.id == null) return;
        ref.watch(router)!.push(
              ListRoute(
                id: post!.id,
                type: index,
              ),
            );
          */
        ),
      ),
    ));
  }

  double toolbarHeight(UserDetailsModel user) {
    return 225 +
        ((user.description != null)
            ? TextInfoService.textSizeConstWidth(
                    user.description ?? '',
                    context.textStyles.footNote!,
                    MediaQuery.of(context).size.width - 32)
                .height
            : 0);
  }

  Future<dynamic> openContextMenu() async {
    final user = ref.read(userNotifier(widget.args.id))!;
    await MenuDialog.showBottom(
      context,
      MenuState(user.name, [
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.share,
          () async {
            await Share.share('https://posterstock.com/${user.username}');
          },
        ),
        MenuItem(
          'assets/icons/search.svg',
          context.txt.search,
          () {
            animationController.animateTo(1);
            scrollController.animateTo(
              245,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
            focusNode.requestFocus();
          },
        ),
        MenuItem.danger(
          'assets/icons/ic_hand.svg',
          context.txt.profile_menu_block,
          () {} /* TODO: implement */,
        ),
      ]),
    );
  }
}

class UserArgs {
  final int id;
  final String username;

  UserArgs(this.id, this.username);
}

class UserHeader extends ConsumerWidget {
  final int id;
  final TabController? tabController;

  const UserHeader(this.id, this.tabController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shimmer = ShimmerLoader(
      loaded: false,
      child: Container(color: Colors.grey),
    );
    final controller = ref.read(userNotifier(id).notifier);
    final user = controller.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.imagePath != null
                    ? Image.network(
                        user.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, obj, trace) {
                          return shimmer;
                        },
                        loadingBuilder: (context, child, event) {
                          if (event?.cumulativeBytesLoaded !=
                              event?.expectedTotalBytes) {
                            return shimmer;
                          }
                          return child;
                        },
                      ).image
                    : null,
                backgroundColor: user.color,
                child: user.imagePath == null
                    ? Text(
                        getAvatarName(user.name).toUpperCase().isEmpty
                            ? getAvatarName(user.username).toUpperCase()
                            : getAvatarName(user.name).toUpperCase(),
                        style: context.textStyles.title3!.copyWith(
                          color: context.colors.textsBackground,
                        ),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(width: 38),
              GestureDetector(
                onTap: () {
                  ref.read(router)!.push(UsersListRoute(id: id));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextOrContainer(
                        text: user.followers.toString(),
                        style: context.textStyles.headline,
                        emptyWidth: 35,
                        emptyHeight: 20,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.txt.profile_followers,
                        style: context.textStyles.caption1!.copyWith(
                          color: context.colors.textsSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 36),
              GestureDetector(
                onTap: () {
                  // if (profile != null) {
                  //   ref.watch(router)!.push(
                  //         UsersListRoute(
                  //           following: true,
                  //           id: profile.id,
                  //         ),
                  //       );
                  // }
                  ref
                      .read(router)!
                      .push(UsersListRoute(id: id, following: true));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoader(
                        loaded: user != null,
                        child: TextOrContainer(
                          text: user.following.toString(),
                          style: context.textStyles.headline,
                          emptyWidth: 35,
                          emptyHeight: 20,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.txt.profile_following,
                        style: context.textStyles.caption1!.copyWith(
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
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextOrContainer(
                    text: user.name,
                    style: context.textStyles.headline,
                    emptyWidth: 150,
                    emptyHeight: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          tabController?.animateTo(0);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
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
                                  user.posters.toString(),
                                  style: context.textStyles.caption1!.copyWith(
                                      color: context.colors.textsPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          tabController?.animateTo(tabController!.length - 1);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                // SvgPicture.asset(
                                //   'assets/icons/lists.svg',
                                //   colorFilter: ColorFilter.mode(
                                //     context.colors.iconsDefault!,
                                //     BlendMode.srcIn,
                                //   ),
                                //   width: 16,
                                // ),
                                AppSvg.icon(
                                  'lists.svg',
                                  color: context.colors.iconsDefault!,
                                  width: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user.lists.toString(),
                                  style: context.textStyles.caption1!.copyWith(
                                      color: context.colors.textsPrimary),
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              AppTextButton(
                onTap: () {
                  controller.toggleFollow();
                },
                text: user.followed
                    ? context.txt.profile_following.capitalize()
                    : context.txt.follow,
                backgroundColor:
                    user.followed ? context.colors.fieldsDefault : null,
                textColor: user.followed ? context.colors.textsPrimary : null,
              ),
            ],
          ),
          if (user.description != null) const SizedBox(height: 12),
          if (user.description != null)
            Text(
              user.description!,
              style: context.textStyles.footNote,
            ),
          if (user.description != null) const SizedBox(height: 16),
        ],
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

class SearchField extends ConsumerWidget {
  final TextEditingController searchController;
  final AnimationController animationController;
  final FocusNode focusNode;

  const SearchField({
    required this.searchController,
    required this.animationController,
    required this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      controller: searchController,
      searchField: true,
      hint: context.txt.search,
      removableWhenNotEmpty: true,
      crossPadding: const EdgeInsets.all(8),
      crossButton: SvgPicture.asset(
        'assets/icons/search_cross.svg',
      ),
      style: context.textStyles.callout!.copyWith(
        fontSize: context.textStyles.callout!.fontSize! *
                    animationController.value <
                1
            ? 1
            : context.textStyles.callout!.fontSize! * animationController.value,
      ),
      focus: focusNode,
      onRemoved: () {
        ref.read(pickCoverControllerProvider).updateSearch('');
        ref.watch(listSearchValueStateHolderProvider.notifier).updateState('');
        searchController.clear();
      },
      onChanged: (value) {
        ref.read(pickCoverControllerProvider).updateSearch(value);
        ref
            .watch(listSearchValueStateHolderProvider.notifier)
            .updateState(value);
      },
    );
  }
}

class AppSvg extends StatelessWidget {
  final String path;
  final String name;
  final Color? color;
  final double? width;

  const AppSvg(
    this.name, {
    this.color,
    this.width,
    super.key,
  }) : path = 'assets/';

  const AppSvg.icon(
    this.name, {
    this.color,
    this.width,
    super.key,
  }) : path = 'assets/icons/';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      '$path$name',
      colorFilter: color?.let((it) => ColorFilter.mode(it, BlendMode.srcIn)),
      width: width,
    );
  }
}

class ProfileTabs extends ConsumerStatefulWidget {
  const ProfileTabs({
    Key? key,
    required this.controller,
    this.name,
    required this.shimmer,
    required this.id,
    required this.animationController,
    required this.searchTextController,
    this.callback,
  }) : super(key: key);
  final int id;
  final TabController controller;
  final String? name;
  final Widget shimmer;
  final AnimationController animationController;
  final TextEditingController searchTextController;
  final void Function(PostMovieModel, int index)? callback;

  @override
  ConsumerState<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends ConsumerState<ProfileTabs> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final lists = ref.watch(userListsStateNotifier(id));
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final posters = ref.watch(userPostersNotifier(id));
    // final postersSearch = ref.watch(listSearchPostsStateHolderProvider);
    // final bookmarks = ref.watch(accountBookmarksStateNotifier);
    final profile = ref.watch(userNotifier(id));
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        if (widget.animationController.value <= 0.5 &&
            widget.searchTextController.text.isNotEmpty) {
          Future(() {
            ref.read(listSearchValueStateHolderProvider.notifier).clearState();
            // ref.read(listSearchPostsStateHolderProvider.notifier).clearState();
            widget.searchTextController.clear();
          });
        }
        return child!;
      },
      child: TabBarView(
        controller: widget.controller,
        children: [
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (info) {
              if (info.metrics.pixels >=
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height &&
                  searchValue.isNotEmpty) {
                ref.read(pickCoverControllerProvider).updateSearch(searchValue);
              }
              if (widget.controller.index == 0 &&
                  info.metrics.pixels >
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height) {
                // ref.read(profileControllerApiProvider).updatePosts(profile!.id);
              }
              if (widget.controller.index == 1 &&
                  widget.controller.length == 3 &&
                  info.metrics.pixels >
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height) {
                // ref.read(profileControllerApiProvider).updateBookmarks();
              }
              return true;
            },
            child: PostsCollectionView(
              posters,
              name: widget.name,
              callback: widget.callback,
            ),
          ),
          // PostsCollectionView(bookmarks),
          GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 13.0,
              mainAxisSpacing: 16.0,
              mainAxisExtent:
                  ((MediaQuery.of(context).size.width - 16.0 * 3) / 2) /
                          540 *
                          300 +
                      23,
            ),
            itemCount: lists?.length ?? 30,
            itemBuilder: (context, index) {
              return ListGridWidget(
                post: lists?[index],
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }
}

class PostsCollectionView extends ConsumerWidget {
  final List<PostMovieModel?> movies;
  final String? name;
  final void Function(PostMovieModel, int)? callback;

  const PostsCollectionView(
    this.movies, {
    this.name,
    this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (movies.isEmpty == true) {
      return Column(
        children: [
          SizedBox(height: (MediaQuery.of(context).size.height - 480 - 56) / 2),
          SizedBox(
            width: name == null ? 170 : 250,
            child: SimpleEmptyCollectionWidget(
              name != null
                  ? "$name ${context.txt.profile_noWatched} "
                  : context.txt.profile_lists_add_hint,
            ),
          ),
        ],
      );
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
              ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) / 3) /
                      2 *
                      3 +
                  41,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: movies.length,
        itemBuilder: (_, index) => GestureDetector(
              onTap: () => callback?.call(movies[index]!, index),
              child: PostGridItemWidget(movies[index]),
            ));
  }
}

extension NullSafeExt<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}
