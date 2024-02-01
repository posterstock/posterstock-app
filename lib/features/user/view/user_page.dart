import 'dart:developer';

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
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/features/profile/view/widgets/count_indicator.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_avatar.dart';
import 'package:poster_stock/features/profile/view/widgets/wait_screen.dart';
import 'package:poster_stock/features/user/state_holder/user_holder.dart';
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
    final user = ref.watch(userNotifier(args.id));
    return user == null ? WaitProfile(args.name) : UserPage2(args: args);
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
                    user.name,
                    onBack: context.back,
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
              flexibleSpace: ProfileTabBar(
                animation: tabController.animation!,
                tabController: tabController,
                profile: user,
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
  final String name;

  UserArgs(this.id, this.name);
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

class ProfileTabBar extends AnimatedWidget {
  const ProfileTabBar({
    super.key,
    required Animation<double> animation,
    this.tabController,
    this.profile,
    // required this.myself,
  }) : super(listenable: animation);

  final TabController? tabController;
  final UserDetailsModel? profile;
  // final bool myself;

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
            context.txt.profile_watched,
            style: animation.value >= 0 && animation.value <= 0.5
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
        // if (myself ?? false)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 14.0),
        //     child: Text(
        //       context.txt.profile_watchlist,
        //       style: animation.value > 0.5 && animation.value <= 1.5
        //           ? context.textStyles.subheadlineBold
        //           : context.textStyles.subheadline,
        //     ),
        //   ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
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

extension NullSafeExt<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}
