import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:poster_stock/features/profile/view/widgets/count_indicator.dart';
import 'package:poster_stock/features/profile/view/widgets/posters_collections_view.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_avatar.dart';
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
class UserPageId extends ConsumerWidget {
  final int id;

  const UserPageId({
    @PathParam('id') required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(userControllerProvider(id));
    // final posters = ref.watch(userPostersNotifier(id));
    final user = ref.watch(userNotifier(id));
    return user == null
        // || (posters.firstOrNull == null && posters.isNotEmpty)
        ? const WaitProfile('')
        : _UserPage(args: UserArgs(user.id, user.username, uid: true));
  }
}

@RoutePage()
class UserPageNamed extends ConsumerWidget {
  final String username;

  const UserPageNamed({
    @PathParam('username') required this.username,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifier(username));
    return user == null
        ? WaitProfile(username)
        : _UserPage(args: UserArgs(user.id, username, uid: false));
  }
}

class UserArgs {
  final int id;
  final String username;
  final bool uid;

  UserArgs(this.id, this.username, {this.uid = true});
}

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
    final posters = ref.watch(userPostersNotifier(args.id));
    final user = ref.watch(userNotifier(args.id));
    return user == null || (posters.firstOrNull == null && posters.isNotEmpty)
        ? WaitProfile(args.username)
        : _UserPage(args: args);
  }
}

class _UserPage extends ConsumerStatefulWidget {
  final UserArgs args;

  const _UserPage({
    required this.args,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<_UserPage> with TickerProviderStateMixin {
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
    final user = ref.watch(
        userNotifier(widget.args.uid ? widget.args.id : widget.args.username))!;
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
              expandedHeight: toolbarHeight(user) + 10,
              toolbarHeight: toolbarHeight(user) + 10,
              collapsedHeight: toolbarHeight(user) + 10,
              backgroundColor: context.colors.backgroundsPrimary,
              leading: const SizedBox(),
              centerTitle: true,
              title: const SizedBox(),
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 12.0),
                  ProfileAppbar(
                    user.username,
                    onBack: ref.watch(router)!.pop,
                    onMenuClick: openContextMenu,
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
                                NameWithArtist(
                                  name: user.name,
                                  isArtist: user.isArtist,
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
                                          user.posters,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => tabController.animateTo(1),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: IconCountIndicator(
                                          'assets/icons/lists.svg',
                                          user.lists,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            AppTextButton(
                              onTap: controller.toggleFollow,
                              text: user.followed
                                  ? context.txt.unfollow
                                  : context.txt.follow,
                              backgroundColor: user.followed
                                  ? context.colors.fieldsDefault
                                  : null,
                              textColor: user.followed
                                  ? context.colors.textsPrimary
                                  : null,
                            ),
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
          controller: tabController,
          name: user.name,
          id: user.id,
          callback: (poster, _) =>
              ref.read(router)!.push(PosterRoute(postId: poster.id)),
        ),
      ),
    ));
  }

  double toolbarHeight(UserDetailsModel user) {
    int st = 0;
    switch (st) {
      case 0:
        st++;
        break;
      case 1:
        st--;
        break;
    }

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
          context.txt.profile_menu_share,
          () async {
            await Share.share('https://posterstock.com/${user.username}');
          },
        ),
        MenuItem(
          'assets/icons/search.svg',
          context.txt.search_page_search_hint,
          () {
            context.router.push(const PageRouteInfo(SearchRoute.name));
            // animationController.animateTo(1);
            // scrollController.animateTo(
            //   245,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.linear,
            // );
            // focusNode.requestFocus();
          },
        ),
        MenuItem.danger(
          'assets/icons/ic_danger.svg',
          context.txt.report,
          () {} /* TODO: implement */,
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
      hint: context.txt.search_page_search_hint,
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

class ProfileTabs extends ConsumerStatefulWidget {
  const ProfileTabs({
    Key? key,
    required this.controller,
    this.name,
    required this.id,
    required this.animationController,
    required this.searchTextController,
    this.callback,
  }) : super(key: key);
  final int id;
  final TabController controller;
  final String? name;
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
    final posters = ref.watch(userPostersNotifier(id));
    Logger.i('posters ${posters.first?.toJson()}');
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final lists = ref.watch(userListsStateNotifier(id));
    final controller = ref.read(userControllerProvider(id));
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        if (widget.animationController.value <= 0.5 &&
            widget.searchTextController.text.isNotEmpty) {
          Future(() {
            ref.read(listSearchValueStateHolderProvider.notifier).clearState();
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
                controller.loadMorePosters();
              }
              return true;
            },
            child: PostersCollectionView(
              posters,
              name: widget.name,
              callback: widget.callback,
            ),
          ),
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (info) {
              if (info.metrics.pixels >=
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height &&
                  searchValue.isNotEmpty) {
                ref.read(pickCoverControllerProvider).updateSearch(searchValue);
              }
              return true;
            },
            child: GridView.builder(
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
              itemBuilder: (_, index) {
                return ListGridWidget(
                  (post) => ref.watch(router)!.push(ListRoute(id: post!.id)),
                  post: lists[index],
                  // index: index,
                );
              },
              /*
                      ref.watch(router)!.push(
              ListRoute(
                id: post!.id,
                // type: index,
              ),
            );
               */
            ),
          ),
        ],
      ),
    );
  }
}

final shimmer = ShimmerLoader(
  loaded: false,
  child: Container(
    color: Colors.grey,
  ),
);
