import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/state_holders/home_page_scroll_controller_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_route_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/plus_button.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../controller/menu_controller.dart';
import 'bottom_nav_bar_item.dart';

class AppNavigationBar extends ConsumerStatefulWidget {
  const AppNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends ConsumerState<AppNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(navigationRouterStateHolderProvider);
    final myProfile = ref.watch(myProfileInfoStateHolderProvider);
    if (router == null || router != AutoTabsRouter.of(context)) {
      Future(() {
        ref.read(menuControllerProvider).setRouter(
              AutoTabsRouter.of(context),
            );
        ref.read(menuControllerProvider).jumpToPage(0, context, ref);
      });
    }
    int activeIndex = ref.watch(navigationPageStateHolderProvider);
    final homeScrollPosition =
        ref.watch(homePageScrollControllerStateHolderProvider);
    return SafeArea(
      child: SizedBox(
        height: 60.0,
        width: double.infinity,
        child: Column(
          children: [
            Divider(
              color: context.colors.fieldsDefault,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Expanded(
              child: Row(
                children: [
                  BottomNavBarItem(
                    onTap: () {
                      ref
                          .read(menuControllerProvider)
                          .jumpToPage(0, context, ref);
                      if (activeIndex == 0 && homeScrollPosition.offset > 10) {
                        homeScrollPosition.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      } else if (activeIndex == 0) {
                        homeScrollPosition.animateTo(
                          -180,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_home_mobile.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 30.0,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_home_mobile_active.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 30.0,
                    ),
                    active: activeIndex == 0,
                  ),
                  BottomNavBarItem(
                    icon: const PlusButton(),
                    onTap: () {
                      ref.read(menuControllerProvider).switchMenu();
                    },
                    active: false,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      ref
                          .read(menuControllerProvider)
                          .jumpToPage(1, context, ref);
                    },
                    icon: myProfile?.imagePath == null
                        ? SvgPicture.asset(
                            'assets/icons/ic_profile.svg',
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!,
                              BlendMode.srcIn,
                            ),
                            width: 28.0,
                          )
                        : CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                              myProfile!.imagePath!,
                            ),
                          ),
                    activeIcon: myProfile?.imagePath == null
                        ? SvgPicture.asset(
                            'assets/icons/ic_profile_active.svg',
                            colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!,
                              BlendMode.srcIn,
                            ),
                            width: 28.0,
                          )
                        : Stack(
                            children: [
                              Container(
                                width: 34.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colors.textsPrimary!,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundImage: CachedNetworkImageProvider(
                                      myProfile!.imagePath!,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                top: 0,
                                child: Center(
                                  child: Container(
                                    width: 28.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            context.colors.backgroundsPrimary!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    active: activeIndex == 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
