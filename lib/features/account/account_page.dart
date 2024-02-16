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
import 'package:poster_stock/common/widgets/app_tab_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/account/notifiers/bookmarks_notifier.dart';
import 'package:poster_stock/features/account/notifiers/lists_notifier.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/list_search_posters_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/edit_profile/view/pages/edit_profile_page.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/view/widgets/count_indicator.dart';
import 'package:poster_stock/features/profile/view/widgets/posters_collections_view.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_avatar.dart';
import 'package:poster_stock/features/profile/view/widgets/wait_screen.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class AccountPage extends ConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(accountControllerProvider);
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
                      account.username,
                      onMenuClick: _openContextMenu,
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
                                onTap: () => _editAvatar(account),
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
                                        onTap: () => tabController.animateTo(0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: IconCountIndicator(
                                            'assets/icons/ic_collection.svg',
                                            account.posters,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => tabController.animateTo(2),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: IconCountIndicator(
                                            'assets/icons/lists.svg',
                                            account.lists,
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
                flexibleSpace: AppTabBar(tabController, [
                  context.txt.profile_watched,
                  context.txt.profile_watchlist,
                  context.txt.lists,
                ]),
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
            callback: (poster, index) =>
                ref.read(router)!.push(PosterRoute(postId: poster.id)),
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

  Future<void> _openContextMenu() async {
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

  void _editAvatar(UserDetailsModel account) {
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
    this.callback,
  }) : super(key: key);
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
    // final accountController = ref.read(accountControllerProvider);
    final lists = ref.watch(accountListsStateNotifier);
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final posters = ref.watch(accountPostersStateNotifier);
    // final posters = accountController.posters;
    final postersSearch = ref.watch(listSearchPostsStateHolderProvider);
    final bookmarks = ref.watch(accountBookmarksStateNotifier);
    // final profile = ref.watch(profileInfoStateHolderProvider);
    if (posters.top) {
      widget.animationController.value = 0;
    }
    if (bookmarks.top) {
      widget.animationController.value = 0;
    }
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
                      MediaQuery.of(context).size.height) {
                ref.read(accountPostersStateNotifier.notifier).loadMore();
              }
              return true;
            },
            child: PostersCollectionView(
              posters.posters,
              name: widget.name,
              callback: widget.callback,
            ),
          ),
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (info) {
              if (info.metrics.pixels >=
                  info.metrics.maxScrollExtent -
                      MediaQuery.of(context).size.height) {
                ref.read(accountBookmarksStateNotifier.notifier).loadMore();
              }
              return true;
            },
            child: PostersCollectionView(
              bookmarks.bookmarks,
              callback: (bookmark, index) {
                int id;
                var list = bookmark.tmdbLink!.split('/');
                list.removeLast();
                id = int.parse(list.last);
                ref.watch(router)!.push(
                      BookmarksRoute(
                        id: id,
                        mediaId: bookmark.mediaId!,
                        tmdbLink: bookmark.tmdbLink!,
                      ),
                    );
              },
            ),
          ),
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
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return ListGridWidget(
                (post) => ref.watch(router)!.push(
                      ListRoute(
                        id: post!.id,
                        // type: index,
                      ),
                    ),
                post: lists[index],
              );
              //   index: index,
              // );
            },
          ),
        ],
      ),
    );
  }
}
