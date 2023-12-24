import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/common/helpers/string_extension.dart';
import 'package:poster_stock/common/menu/menu_dialog.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/common/services/text_info_service.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/common/widgets/list_grid_widget.dart';
import 'package:poster_stock/features/create_list/controllers/pick_cover_controller.dart';
import 'package:poster_stock/features/create_list/state_holders/list_search_posters_state_holder.dart';
import 'package:poster_stock/features/create_list/state_holders/lists_search_value_state_holder.dart';
import 'package:poster_stock/features/edit_profile/api/edit_profile_api.dart';
import 'package:poster_stock/features/edit_profile/controller/edit_profile_controller.dart';
import 'package:poster_stock/features/edit_profile/view/pages/edit_profile_page.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/list/controller/list_controller.dart';
import 'package:poster_stock/features/list/state_holder/list_state_holder.dart';
import 'package:poster_stock/features/list/view/list_page.dart';
import 'package:poster_stock/features/peek_pop/peek_and_pop_dialog.dart';
import 'package:poster_stock/features/poster/controller/comments_controller.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_bookmarks_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_info_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_lists_state_holder.dart';
import 'package:poster_stock/features/profile/state_holders/profile_posts_state_holder.dart';
import 'package:poster_stock/features/profile/view/empty_collection_widget.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    @PathParam('username') this.username = 'profile',
    Key? key,
  }) : super(key: key);

  final String username;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with TickerProviderStateMixin {
  TabController? tabController;
  late final animationController = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: 1,
    duration: const Duration(milliseconds: 300),
  );
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  bool loading = false;
  bool myself = false;
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

  StackRouter? rter;

  @override
  void dispose() {
    rter?.removeListener(listenerContent);
    super.dispose();
  }

  void listenerContent() {
    getProfile();
  }

  @override
  void initState() {
    super.initState();
    Future(() => ref.read(profileControllerApiProvider).clearUser());
    Future(() => ref.read(router)!.addListener(listenerContent));
  }

  Future<void> getProfile() async {
    if (loading) return;
    loading = true;
    final rtr = ref.watch(router);
    var anyProfile = ref.watch(profileInfoStateHolderProvider);
    var myProfile = ref.watch(myProfileInfoStateHolderProvider);
    await Future(() {
      if (rtr!.topRoute.path == '/' && anyProfile?.id != myProfile?.id) {
        Future(() {
          ref.read(profileControllerApiProvider).clearUser();
        });
      }
      RouteData? el;
      try {
        var rttr = ref.watch(router);
        int i1 = -1;
        int i2 = -1;
        int i3 = -1;
        print(rttr!.topRoute.path + "  r3");
        try {
          i1 = rttr?.stack.lastIndexWhere(
                  (element) => element.routeData.path == '/:username') ??
              0;
        } catch (e) {}
        try {
          i2 = rttr?.stack.lastIndexWhere(
                  (element) => element.routeData.path == '/users/:id') ??
              0;
        } catch (e) {}
        try {
          i3 = rttr?.stack
                  .lastIndexWhere((element) => element.routeData.path == '/') ??
              0;
        } catch (e) {}
        try {
          if (rttr.stack.last.routeData.path == '/') {
            i3 = rttr.stack.length + 1;
          }
        } catch (e) {}
        if (i1 > i2 &&
            i1 > i3 &&
            anyProfile?.username !=
                ref.watch(router)!.topRoute.pathParams.getString('username')) {
          el = ref.watch(router)!.topRoute;
          ref
              .read(profileControllerApiProvider)
              .getUserInfo(el.pathParams.getString('username'));
        } else if (i2 > i1 &&
            i2 > i3 &&
            anyProfile?.id !=
                ref.watch(router)!.topRoute.pathParams.getInt('id')) {
          el = ref.watch(router)!.topRoute;
          ref
              .read(profileControllerApiProvider)
              .getUserInfo(el.pathParams.getInt('id'));
        } else if (i3 > i1 &&
            i3 > i2 &&
            (anyProfile?.id == null || anyProfile?.id != myProfile?.id)) {
          ref.read(profileControllerApiProvider).getUserInfo(null);
        } else if (ref.read(profileInfoStateHolderProvider) == null) {
          ref.read(profileControllerApiProvider).getUserInfo(null);
        }
      } catch (e) {
        el = null;
      }
    });
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final rtr = ref.watch(router);
    var anyProfile = ref.watch(profileInfoStateHolderProvider);
    var myProfile = ref.watch(myProfileInfoStateHolderProvider);
    UserDetailsModel? profile;
    if (anyProfile != null) {
      profile = anyProfile;
    } else if (rtr!.topRoute.path == 'profile' &&
        anyProfile?.id != myProfile?.id) {
      profile = myProfile;
    }
    if (anyProfile == null) getProfile();
    myself = (profile?.id == myProfile?.id);
    if (myself == true && tabController?.length != 3) {
      tabController = TabController(
        length: 3,
        vsync: this,
      );
    } else if (myself == false && tabController?.length != 2) {
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
                expandedHeight: profile == null
                    ? 50
                    : 225 +
                        ((profile.description != null)
                            ? TextInfoService.textSizeConstWidth(
                                    profile.description ?? '',
                                    context.textStyles.footNote!,
                                    MediaQuery.of(context).size.width - 32)
                                .height
                            : 0),
                toolbarHeight: profile == null
                    ? 50
                    : 225 +
                        ((profile.description != null)
                            ? TextInfoService.textSizeConstWidth(
                                    profile.description ?? '',
                                    context.textStyles.footNote!,
                                    MediaQuery.of(context).size.width - 32)
                                .height
                            : 0),
                collapsedHeight: profile == null
                    ? 50
                    : 225 +
                        ((profile.description != null)
                            ? TextInfoService.textSizeConstWidth(
                                    profile.description ?? '',
                                    context.textStyles.footNote!,
                                    MediaQuery.of(context).size.width - 32)
                                .height
                            : 0),
                backgroundColor: context.colors.backgroundsPrimary,
                leading: const SizedBox(),
                centerTitle: true,
                title: const SizedBox(),
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 65,
                          child: (rtr?.topRoute.path == 'profile')
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () async {
                                      ref
                                          .read(profileControllerApiProvider)
                                          .clearUser();
                                      ref.watch(router)!.pop();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.only(
                                        left: 7,
                                        right: 31,
                                      ),
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
                          profile?.username ?? widget.username,
                          style: context.textStyles.bodyBold,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            if (myself || widget.username == 'profile') {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) {
                              //     return MyProfileDialog(
                              //       animationController: animationController,
                              //       scrollController: scrollController,
                              //       focusNode: focusNode,
                              //     );
                              //   },
                              //   backgroundColor: Colors.transparent,
                              // );
                              await newModalProfile(context);
                            } else {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) => OtherProfileDialog(
                              //     user: profile,
                              //     block: true,
                              //   ),
                              //   backgroundColor: Colors.transparent,
                              // );
                              await newModalUser();
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
                    if (profile != null)
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
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
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
                                            name: profile!.name,
                                            username: profile.username,
                                            description: profile.description,
                                          );
                                      await ref
                                          .read(profileControllerApiProvider)
                                          .getUserInfo(null);
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: profile.imagePath != null
                                        ? Image.network(
                                            profile.imagePath!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, obj, trace) {
                                              return shimmer;
                                            },
                                            loadingBuilder:
                                                (context, child, event) {
                                              if (event
                                                      ?.cumulativeBytesLoaded !=
                                                  event?.expectedTotalBytes) {
                                                return shimmer;
                                              }
                                              return child;
                                            },
                                          ).image
                                        : null,
                                    backgroundColor: profile.color,
                                    child: profile.imagePath == null
                                        ? Text(
                                            getAvatarName(profile.name)
                                                    .toUpperCase()
                                                    .isEmpty
                                                ? getAvatarName(
                                                        profile.username)
                                                    .toUpperCase()
                                                : getAvatarName(profile.name)
                                                    .toUpperCase(),
                                            style: context.textStyles.title3!
                                                .copyWith(
                                              color: context
                                                  .colors.textsBackground,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ),
                                const SizedBox(width: 38),
                                GestureDetector(
                                  onTap: () {
                                    if (profile != null) {
                                      ref.watch(router)!.push(
                                            UsersListRoute(id: profile.id),
                                          );
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextOrContainer(
                                          text: profile.followers.toString(),
                                          style: context.textStyles.headline,
                                          emptyWidth: 35,
                                          emptyHeight: 20,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          context.txt.profile_followers,
                                          style: context.textStyles.caption1!
                                              .copyWith(
                                            color:
                                                context.colors.textsSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 36),
                                GestureDetector(
                                  onTap: () {
                                    if (profile != null) {
                                      ref.watch(router)!.push(
                                            UsersListRoute(
                                              following: true,
                                              id: profile.id,
                                            ),
                                          );
                                    }
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
                                            text: profile.following?.toString(),
                                            style: context.textStyles.headline,
                                            emptyWidth: 35,
                                            emptyHeight: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          context.txt.profile_following,
                                          style: context.textStyles.caption1!
                                              .copyWith(
                                            color:
                                                context.colors.textsSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            SizedBox(height: profile == null ? 20 : 12),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextOrContainer(
                                      text: profile.name,
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
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/ic_collection.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      context
                                                          .colors.iconsDefault!,
                                                      BlendMode.srcIn,
                                                    ),
                                                    width: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    profile.posters.toString(),
                                                    style: context
                                                        .textStyles.caption1!
                                                        .copyWith(
                                                            color: context
                                                                .colors
                                                                .textsPrimary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            tabController?.animateTo(
                                                tabController!.length - 1);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 12),
                                                  SvgPicture.asset(
                                                    'assets/icons/lists.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      context
                                                          .colors.iconsDefault!,
                                                      BlendMode.srcIn,
                                                    ),
                                                    width: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    profile.lists.toString() ??
                                                        '0',
                                                    style: context
                                                        .textStyles.caption1!
                                                        .copyWith(
                                                            color: context
                                                                .colors
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
                                    if (myself) {
                                      ref.watch(router)!.push(
                                            EditProfileRoute(),
                                          );
                                    } else {
                                      ref
                                          .read(profileControllerApiProvider)
                                          .follow(
                                            profile!.id,
                                            profile.followed,
                                          );
                                    }
                                  },
                                  text: (myself ?? false)
                                      ? context.txt.edit.capitalize()
                                      : ((profile.followed ?? true)
                                          ? context.txt.profile_following
                                              .capitalize()
                                          : context.txt.follow),
                                  backgroundColor: ((myself ?? false) ||
                                          (profile.followed ?? true))
                                      ? context.colors.fieldsDefault
                                      : null,
                                  textColor: ((myself ?? false) ||
                                          (profile.followed ?? true))
                                      ? context.colors.textsPrimary
                                      : null,
                                ),
                              ],
                            ),
                            if (profile.description != null)
                              const SizedBox(
                                height: 12,
                              ),
                            if (profile.description != null)
                              Text(
                                profile.description!,
                                style: context.textStyles.footNote,
                              ),
                            if (profile.description != null)
                              const SizedBox(
                                height: 16,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (profile == null)
                SliverFillRemaining(
                  child: Center(
                    child: defaultTargetPlatform != TargetPlatform.android
                        ? const CupertinoActivityIndicator(radius: 10)
                        : SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: context.colors.iconsDisabled!,
                              strokeWidth: 2,
                            ),
                          ),
                  ),
                ),
              if (profile != null)
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
              if (profile != null)
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
                                      style:
                                          context.textStyles.callout!.copyWith(
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
                                      style: context.textStyles.bodyRegular!
                                          .copyWith(
                                        color: context.colors.textsAction,
                                        fontSize: context
                                                        .textStyles
                                                        .bodyRegular!
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
                  animationController: animationController,
                  searchTextController: searchController,
                  shimmer: shimmer,
                  controller: tabController!,
                  name: profile?.mySelf == true ? null : profile?.name,
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

  Future<void> newModalProfile(BuildContext context) async {
    final profile = ref.read(myProfileInfoStateHolderProvider)!;
    await MenuDialog.showBottom(
      context,
      MenuState(profile.name, [
        MenuItem('assets/icons/ic_gear.svg', context.txt.settings, () {
          ref.read(router)!.push(const SettingsRoute());
        }),
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.profile_menu_share,
          () async {
            await Share.share('https://posterstock.com/${profile.username}');
          },
        ),
        MenuItem(
          'assets/icons/search.svg',
          context.txt.search,
          () {
            //TODO: implement
          },
        ),
      ]),
    );
  }

  Future<void> newModalUser() async {
    final profile = ref.read(profileInfoStateHolderProvider)!;
    await MenuDialog.showBottom(
      context,
      MenuState(profile.name, [
        MenuItem(
          'assets/icons/ic_share.svg',
          context.txt.share,
          () async {
            await Share.share('https://posterstock.com/${profile.username}');
          },
        ),
        MenuItem(
          'assets/icons/search.svg',
          context.txt.search,
          () => ref.read(router)!.push(const SettingsRoute()),
        ),
        MenuItem.danger(
          'assets/icons/ic_hand.svg',
          context.txt.profile_menu_block,
          () {
            //TODO: implement
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

class _ProfileTabsState extends ConsumerState<ProfileTabs>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(profileListsStateHolderProvider);
    final searchValue = ref.watch(listSearchValueStateHolderProvider);
    final posts = ref.watch(profilePostsStateHolderProvider);
    final postersSearch = ref.watch(listSearchPostsStateHolderProvider);
    final bookmarks = ref.watch(profileBookmarksStateHolderProvider);
    final profile = ref.watch(profileInfoStateHolderProvider);
    List<PostMovieModel>? posters;
    if (searchValue.isEmpty) {
      posters = posts;
    } else {
      posters = postersSearch;
    }
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        if (widget.animationController.value <= 0.5 &&
            widget.searchTextController.text.isNotEmpty) {
          posters = posts;
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
              if (widget.controller?.index == 0 &&
                  info.metrics.pixels >
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height) {
                ref.read(profileControllerApiProvider).updatePosts(profile!.id);
              } else {
                print(812);
              }
              if (widget.controller?.index == 1 &&
                  widget.controller?.length == 3 &&
                  info.metrics.pixels >
                      info.metrics.maxScrollExtent -
                          MediaQuery.of(context).size.height) {
                ref.read(profileControllerApiProvider).updateBookmarks();
              }
              return true;
            },
            child: PostsCollectionView(
              movies: posters,
              shimmer: widget.shimmer,
              name: widget.name,
            ),
          ),
          if (widget.controller.length == 3)
            PostsCollectionView(
              movies: bookmarks,
              shimmer: widget.shimmer,
              bookmark: true,
              customOnItemTap: (post, index) {
                int id;
                var list = bookmarks![index].tmdbLink!.split('/');
                list.removeLast();
                print(list);
                id = int.parse(list.last);
                ref.watch(router)!.push(
                      BookmarksRoute(id: id),
                    );
              },
              customOnLongTap: () {},
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
            itemCount: lists?.length ?? 30,
            itemBuilder: (context, index) {
              final ListType? type = index == 0
                  ? ListType.favorited
                  : index == 1
                      ? ListType.recomends
                      : null;
              return ListGridWidget(
                post: lists?[index],
                type: type,
              );
            },
          ),
        ],
      ),
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
    required this.shimmer,
  }) : super(key: key);
  final List<PostMovieModel>? movies;
  final void Function(PostMovieModel, int)? customOnItemTap;
  final void Function()? customOnLongTap;
  final String? name;
  final bool bookmark;
  final Widget shimmer;

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
      itemCount: movies == null ? 30 : movies!.length,
      itemBuilder: (context, index) {
        return PostsCollectionTile(
          post: movies?[index],
          shimmer: shimmer,
          customOnItemTap: customOnItemTap,
          customOnLongTap: customOnLongTap,
          index: index,
        );
      },
    );
  }
}

class PostsCollectionTile extends ConsumerWidget {
  const PostsCollectionTile({
    Key? key,
    this.post,
    this.customOnItemTap,
    required this.index,
    required this.shimmer,
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
  final Widget shimmer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PeekAndPopDialog(
      customOnLongTap: customOnLongTap,
      onTap: () {
        if (post != null) {
          if (customOnItemTap == null) {
            ref.watch(router)!.push(
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
          imagePath: imagePath ?? post?.imagePath ?? '',
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
              width: double.infinity,
              height:
                  ((MediaQuery.of(context).size.width - 15 * 2 - 16 * 2) / 3) /
                      2 *
                      3,
              child: CachedNetworkImage(
                imageUrl: (post == null ? imagePath : post?.imagePath) ?? '',
                fit: BoxFit.cover,
                placeholderFadeInDuration: Durations.cachedDuration,
                fadeInDuration: Durations.cachedDuration,
                fadeOutDuration: Durations.cachedDuration,
                placeholder: (context, child) {
                  return shimmer;
                },
                errorWidget: (context, obj, trace) {
                  return shimmer;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            (post == null ? name : post?.name) ?? '',
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
  final shimmer = ShimmerLoader(
    loaded: false,
    child: Container(
      color: Colors.grey,
    ),
  );

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
                    color: context.colors.backgroundsSecondary,
                    height: 300,
                    width: 200,
                    child: CachedNetworkImage(
                      imageUrl: widget.imagePath,
                      fit: BoxFit.cover,
                      placeholderFadeInDuration: Durations.cachedDuration,
                      fadeInDuration: Durations.cachedDuration,
                      fadeOutDuration: Durations.cachedDuration,
                      placeholder: (context, child) {
                        return shimmer;
                      },
                      errorWidget: (context, obj, trace) {
                        return shimmer;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.name != null)
                  Container(
                    width: double.infinity,
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

enum InfoDialogType { post, list, postComment, listComment }

class OtherProfileDialog extends ConsumerWidget {
  const OtherProfileDialog({
    Key? key,
    this.user,
    this.user1,
    this.type,
    this.entityId,
    this.myEntity,
    this.block = false,
  })  : assert(user == null || user1 == null),
        super(key: key);

  final UserDetailsModel? user;
  final UserModel? user1;
  final InfoDialogType? type;
  final int? entityId;
  final bool? myEntity;
  final bool block;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myself = ref.watch(myProfileInfoStateHolderProvider);
    final postId = ref.watch(posterStateHolderProvider);
    final listId = ref.watch(listsStateHolderProvider);
    int itemsCount = 0;
    if (user?.id != myself?.id && user1?.id != myself?.id) {
      itemsCount += 2;
      if (block) itemsCount++;
    }
    if (user?.id == myself?.id ||
        user1?.id == myself?.id ||
        myEntity == true && type == InfoDialogType.postComment ||
        myEntity == true && type == InfoDialogType.listComment) itemsCount++;
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
            height:
                (itemsCount * 60) + MediaQuery.of(context).padding.bottom + 80,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
              child: SizedBox(
                height: itemsCount * 60 + 80,
                child: Material(
                  color: context.colors.backgroundsPrimary,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
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
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              if (user != null) {
                                ref
                                    .read(commentsStateHolderProvider.notifier)
                                    .setFollowed(
                                      user!.id,
                                      !user!.followed,
                                    );
                                await ref
                                    .read(profileControllerApiProvider)
                                    .follow(
                                      user!.id,
                                      user!.followed,
                                    );
                              } else {
                                ref
                                    .read(commentsStateHolderProvider.notifier)
                                    .setFollowed(
                                      user1!.id,
                                      !user1!.followed,
                                    );
                                print("GG");
                                print(user1!.id);
                                await ref
                                    .read(profileControllerApiProvider)
                                    .follow(
                                      user1!.id,
                                      user1!.followed,
                                    );
                              }
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    (user?.followed ?? user1!.followed)
                                        ? '${context.txt.unfollow} ${user?.name ?? user1!.name}'
                                        : '${context.txt.follow} ${user?.name ?? user1!.name}',
                                    style: context.textStyles.bodyRegular,
                                  ),
                                  const Spacer(),
                                  Text(
                                    (user?.followed ?? user1!.followed)
                                        ? '􀜗'
                                        : '􀜕',
                                    style: context.textStyles.bodyRegular,
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id && user1?.id != myself?.id)
                          InkWell(
                            onTap: () {
                              scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBars.build(
                                  context,
                                  null,
                                  //TODO: localize
                                  "Not available yet",
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    context.txt.report,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '􀉻',
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id != myself?.id &&
                            user1?.id != myself?.id &&
                            block)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id != myself?.id &&
                            user1?.id != myself?.id &&
                            block)
                          InkWell(
                            onTap: () {
                              if ((user?.id ?? user1?.id) == null) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  SnackBars.build(
                                    context,
                                    null,
                                    //TODO: localize
                                    "An error occured",
                                  ),
                                );
                                return;
                              }
                              if (user?.blocked == true) {
                                EditProfileApi().unblockAccount(
                                    id: (user?.id ?? user1?.id)!);
                              } else {
                                EditProfileApi()
                                    .blockAccount(id: (user?.id ?? user1?.id)!);
                              }
                              ref
                                  .read(profileInfoStateHolderProvider.notifier)
                                  .updateState(ref
                                      .watch(profileInfoStateHolderProvider)!
                                      .copyWith(
                                          blocked: !(ref
                                                  .watch(
                                                      profileInfoStateHolderProvider)
                                                  ?.blocked ??
                                              false)));
                              Navigator.pop(context);
                              //ref.watch(router)?.popUntil((route) => route.data?.path == '/');
                              //ref.read(homePagePostsControllerProvider).blockUser((user?.id ?? user1?.id)!);
                              //ref.read(pageTransitionControllerStateHolder)?.animateTo(ref.read(pageTransitionControllerStateHolder)?.upperBound ?? 0, duration: Duration.zero);
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    user?.blocked == true
                                        ? context.txt.profile_menu_unblock
                                        : context.txt.profile_menu_block,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                        if (user?.id == myself?.id ||
                            user1?.id == myself?.id ||
                            myEntity == true &&
                                type == InfoDialogType.postComment ||
                            myEntity == true &&
                                type == InfoDialogType.listComment)
                          Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: context.colors.fieldsDefault,
                          ),
                        if (user?.id == myself?.id ||
                            user1?.id == myself?.id ||
                            postId?.author.id == myself?.id &&
                                type == InfoDialogType.postComment ||
                            listId?.author.id == myself?.id &&
                                type == InfoDialogType.listComment)
                          InkWell(
                            onTap: () async {
                              if (type != null) {
                                switch (type!) {
                                  case InfoDialogType.post:
                                    {
                                      try {
                                        await ref
                                            .read(commentsControllerProvider)
                                            .deletePost(entityId!);
                                        ref
                                            .read(searchPostsStateHolderProvider
                                                .notifier)
                                            .deleteId(entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        ref
                                            .read(profileControllerApiProvider)
                                            .getUserInfo(null);
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete poster",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.list:
                                    {
                                      try {
                                        //Seems like this is not needed yet
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete list",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.postComment:
                                    {
                                      try {
                                        await ref
                                            .read(commentsControllerProvider)
                                            .deleteComment(
                                                postId!.id, entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete comment",
                                          ),
                                        );
                                      }
                                    }
                                  case InfoDialogType.listComment:
                                    {
                                      try {
                                        await ref
                                            .read(listsControllerProvider)
                                            .deleteComment(
                                                listId!.id, entityId!);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Deleted successfully",
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } catch (_) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          SnackBars.build(
                                            context,
                                            null,
                                            //TODO: localize
                                            "Could not delete comment",
                                          ),
                                        );
                                      }
                                    }
                                }
                              }
                            },
                            child: SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    context.txt.delete,
                                    style: context.textStyles.bodyRegular!
                                        .copyWith(
                                      color: context.colors.textsError,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (user?.id == myself?.id ||
                                      user1?.id == myself?.id)
                                    SvgPicture.asset(
                                      'assets/icons/ic_trash.svg',
                                      colorFilter: ColorFilter.mode(
                                        context.colors.textsError!,
                                        BlendMode.srcIn,
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
                                  ref.watch(router)!.push(
                                        const SettingsRoute(),
                                      );
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
                  const SizedBox(height: 12),
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
                              context.txt.cancel,
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
            context.txt.profile_watched,
            style: animation.value >= 0 && animation.value <= 0.5
                ? context.textStyles.subheadlineBold
                : context.textStyles.subheadline,
          ),
        ),
        if (myself ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              context.txt.profile_watchlist,
              style: animation.value > 0.5 && animation.value <= 1.5
                  ? context.textStyles.subheadlineBold
                  : context.textStyles.subheadline,
            ),
          ),
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
