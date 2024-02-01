import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/helpers/string_extension.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/account/account_controller.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/account/notifiers/bookmarks_notifier.dart';
import 'package:poster_stock/features/account/notifiers/lists_notifier.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/list_search_posters_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/edit_profile/controller/edit_profile_controller.dart';
import 'package:poster_stock/features/edit_profile/view/pages/edit_profile_page.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/view/widgets/count_indicator.dart';
import 'package:poster_stock/features/profile/view/widgets/poster_tile.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_avatar.dart';
import 'package:poster_stock/features/profile/view/widgets/simple_empty_collection.dart';
import 'package:poster_stock/features/profile/view/widgets/wait_screen.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(accountControllerProvider);
    final account = ref.watch(accountNotifier);
    return account == null ? const WaitProfile.empty() : _AccountScreen();
  }
}

class _AccountScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AccountState();
  }
}

class _AccountState extends ConsumerState<_AccountScreen>
    with TickerProviderStateMixin {
  final focusNode = FocusNode();
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  late final animationController = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 1,
    duration: const Duration(milliseconds: 300),
  );
  late final tabController = TabController(
    vsync: this,
    length: 3,
  );
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountNotifier)!;
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
                toolbarHeight: toolbarHeight(account),
                expandedHeight: toolbarHeight(account),
                collapsedHeight: toolbarHeight(account),
                backgroundColor: context.colors.backgroundsPrimary,
                leading: const SizedBox.shrink(),
                centerTitle: true,
                title: const SizedBox.shrink(),
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ProfileAppbar(
                      account.name,
                      onMenuClick: () => openContextMenu(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    builder: (context) => GestureDetector(
                                      onTap: context.back,
                                      child: Container(
                                        height: double.infinity,
                                        color: Colors.transparent,
                                        child: const ProfilePhotoDialog(),
                                      ),
                                    ),
                                  ).then((value) async {
                                    await ref
                                        .read(editProfileControllerProvider)
                                        .save(
                                          name: account.name,
                                          username: account.username,
                                          description: account.description,
                                        );
                                    await ref
                                        .read(profileControllerApiProvider)
                                        .getUserInfo(null);
                                  });
                                },
                                child: ProfileAvatar(account),
                              ),
                              const SizedBox(width: 38),
                              GestureDetector(
                                onTap: () {
                                  context.pushRoute(
                                    UsersListRoute(id: account.id),
                                  );
                                },
                                child: CountIndicator(
                                  context.txt.profile_followers,
                                  account.followers,
                                ),
                              ),
                              const SizedBox(width: 36),
                              GestureDetector(
                                onTap: () {
                                  context.pushRoute(UsersListRoute(
                                    following: true,
                                    id: account.id,
                                  ));
                                },
                                child: CountIndicator(
                                  context.txt.profile_following,
                                  account.following,
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
                                    text: account.name,
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
                                                    context
                                                        .colors.iconsDefault!,
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  account.posters.toString(),
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
                                                    context
                                                        .colors.iconsDefault!,
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  account.lists.toString(),
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
                                  ref.watch(router)!.push(EditProfileRoute());
                                },
                                text: context.txt.edit.capitalize(),
                                backgroundColor: context.colors.fieldsDefault,
                                textColor: context.colors.textsPrimary,
                              ),
                            ],
                          ),
                          if (account.description != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 16,
                              ),
                              child: Text(
                                account.description!,
                                style: context.textStyles.footNote,
                              ),
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
                flexibleSpace: ProfileTabBar(
                  tabController,
                  tabController.animation!,
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
                                  hint: context.txt.search,
                                  removableWhenNotEmpty: true,
                                  crossPadding: const EdgeInsets.all(8.0),
                                  crossButton: SvgPicture.asset(
                                    'assets/icons/search_cross.svg',
                                  ),
                                  style: context.textStyles.callout!.copyWith(
                                    fontSize:
                                        context.textStyles.callout!.fontSize! *
                                                    animationController.value <
                                                1
                                            ? 1
                                            : context.textStyles.callout!
                                                    .fontSize! *
                                                animationController.value,
                                  ),
                                  focus: focusNode,
                                  onRemoved: () {
                                    ref
                                        .read(pickCoverControllerProvider)
                                        .updateSearch('');
                                    ref
                                        .watch(
                                            listSearchValueStateHolderProvider
                                                .notifier)
                                        .updateState('');
                                    searchController.clear();
                                  },
                                  onChanged: (value) {
                                    ref
                                        .read(pickCoverControllerProvider)
                                        .updateSearch(value);
                                    ref
                                        .watch(
                                            listSearchValueStateHolderProvider
                                                .notifier)
                                        .updateState(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  context.txt.cancel,
                                  style:
                                      context.textStyles.bodyRegular!.copyWith(
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
            name: null,
          ),
        ),
      ),
    );
  }

  double toolbarHeight(UserDetailsModel account) {
    return 225 +
        ((account.description != null)
            ? TextInfoService.textSizeConstWidth(
                    account.description ?? '',
                    context.textStyles.footNote!,
                    MediaQuery.of(context).size.width - 32)
                .height
            : 0);
  }

  Future<void> openContextMenu(BuildContext context) async {
    final account = ref.watch(accountNotifier)!;
    await MenuDialog.showBottom(
      context,
      MenuState(account.name, [
        MenuItem('assets/icons/ic_gear.svg', context.txt.settings, () {
          ref.read(router)!.push(const SettingsRoute());
        }),
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.profile_menu_share,
          () async {
            await Share.share('https://posterstock.com/${account.username}');
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
      ]),
    );
  }
}

class ProfileTabs extends ConsumerStatefulWidget {
  const ProfileTabs({
    Key? key,
    required this.controller,
    this.name,
    required this.shimmer,
    required this.animationController,
    required this.searchTextController,
  }) : super(key: key);
  final TabController controller;
  final String? name;
  final Widget shimmer;
  final AnimationController animationController;
  final TextEditingController searchTextController;

  @override
  ConsumerState<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends ConsumerState<ProfileTabs> {
  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(accountListsStateNotifier);
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final posters = ref.watch(accountPostersStateNotifier);
    final postersSearch = ref.watch(listSearchPostsStateHolderProvider);
    final bookmarks = ref.watch(accountBookmarksStateNotifier);
    final profile = ref.watch(profileInfoStateHolderProvider);
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        if (widget.animationController.value <= 0.5 &&
            widget.searchTextController.text.isNotEmpty) {
          Future(() {
            ref.read(listSearchValueStateHolderProvider.notifier).clearState();
            ref.read(listSearchPostsStateHolderProvider.notifier).clearState();
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
                ref.read(profileControllerApiProvider).updatePosts(profile!.id);
              }
              if (widget.controller.index == 1 &&
                  widget.controller.length == 3 &&
                  info.metrics.pixels >
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height) {
                ref.read(profileControllerApiProvider).updateBookmarks();
              }
              return true;
            },
            child: PostsCollectionView(
              posters,
              name: widget.name,
            ),
          ),
          PostsCollectionView(bookmarks),
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

  const PostsCollectionView(
    this.movies, {
    this.name,
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
      itemBuilder: (_, index) => PostGridItemWidget(movies[index]),
    );
  }
}

class ProfileTabBar extends AnimatedWidget {
  final TabController tabController;
  final Animation<double> animation;

  const ProfileTabBar(
    this.tabController,
    this.animation, {
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return TabBar(
      dividerColor: Colors.transparent,
      controller: tabController,
      indicatorColor: context.colors.iconsActive,
      tabs: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            context.txt.profile_watched,
            style: animation.value >= 0 && animation.value <= 0.5
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            context.txt.profile_watchlist,
            style: animation.value > 0.5 && animation.value <= 1.5
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            context.txt.lists,
            style: animation.value > 1.5 && animation.value <= 2
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
      ],
    );
  }
}
