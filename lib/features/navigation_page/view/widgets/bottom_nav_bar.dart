import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/plus_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../controller/menu_controller.dart';
import 'bottom_nav_bar_item.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    onTap: () {},
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
                    active: true,
                  ),
                  BottomNavBarItem(
                    onTap: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/ic_research.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_research.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: false,
                  ),
                  BottomNavBarItem(
                    icon: PlusButton(),
                    onTap: () {
                      ref.read(menuControllerProvider).switchMenu();
                    },
                    active: false,
                  ),
                  BottomNavBarItem(
                    onTap: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/ic_notification-2.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic-notification.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                    ),
                    active: false,
                  ),
                  BottomNavBarItem(
                    onTap: () {},
                    icon: const CircleAvatar(
                      radius: 11,
                      backgroundColor: Color(0xFFD78A8A),
                    ),
                    active: false,
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
