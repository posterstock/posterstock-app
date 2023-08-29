import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/edit_profile/controller/profile_controller.dart';
import 'package:poster_stock/features/home/state_holders/home_page_scroll_controller_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_route_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/plus_button.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
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
    if (router == null || router != AutoTabsRouter.of(context)) {
      Future(
        () {
          ref.read(menuControllerProvider).setRouter(
            AutoTabsRouter.of(context),
          );
          ref.read(menuControllerProvider).jumpToPage(0, context, ref);
        }
      );
    }
    int activeIndex = ref.watch(navigationPageStateHolderProvider);
    final homeScrollPosition =
        ref.watch(homePageScrollControllerStateHolderProvider);
    return SafeArea(
      child: SizedBox(
        height: 57,
        width: double.infinity,
        child: Column(
          children: [
            Divider(
              color: context.colors.fieldsDefault,
              height: 1,
              thickness: 1,
            ),
            Expanded(
              child: Row(
                children: [
                  BottomNavBarItem(
                    onTap: () {
                      ref.read(menuControllerProvider).jumpToPage(0, context, ref);
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
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_home_mobile_active.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: activeIndex == 0,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      ref.read(menuControllerProvider).jumpToPage(1, context, ref);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_research.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_research_active.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: activeIndex == 1,
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
                      ref.read(menuControllerProvider).jumpToPage(2, context, ref);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_notification-2.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_notification.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: activeIndex == 2,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      ref.read(menuControllerProvider).jumpToPage(3, context, ref);
                    },
                    //TODO check if has avatar
                    icon: SvgPicture.asset(
                      'assets/icons/ic_profile.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_profile_active.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: activeIndex == 3,
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
