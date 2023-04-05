import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/state_holders/home_page_scroll_controller_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/plus_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../home/controller/home_page_scroll_controller.dart';
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
    int activeIndex = AutoTabsRouter.of(context).activeIndex;
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
                      if (homeScrollPosition.offset != 0.0 ||
                          AutoTabsRouter.of(context).activeIndex == 0) {
                        ref
                            .read(homePageScrollControllerProvider)
                            .animateScrollToZero();
                      }
                      AutoTabsRouter.of(context).setActiveIndex(0);
                      setState(() {});
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
                      AutoTabsRouter.of(context).setActiveIndex(1);
                      setState(() {});
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
                      AutoTabsRouter.of(context).setActiveIndex(2);
                      setState(() {});
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
                      AutoTabsRouter.of(context).setActiveIndex(3);
                      setState(() {});
                    },
                    icon: const CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFFD78A8A),
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
