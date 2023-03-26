import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
                      print(1);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_home_mobile.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_home_mobile_active.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    active: true,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      print(1);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_research.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic_research.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    active: false,
                  ),
                  BottomNavBarItem(
                    icon: PlusButton(),
                    active: false,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      print(1);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_notification-2.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/ic-notification.svg',
                      colorFilter: ColorFilter.mode(
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    active: false,
                  ),
                  BottomNavBarItem(
                    onTap: () {
                      print(5);
                    },
                    icon: CircleAvatar(
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

class PlusButton extends ConsumerStatefulWidget {
  const PlusButton({
    super.key,
  });

  @override
  ConsumerState<PlusButton> createState() => _PlusButtonState();
}

class _PlusButtonState extends ConsumerState<PlusButton> {
  double angle = 0;
  Color? color;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuStateHolderProvider);
    if (state) {
      color = context.colors.buttonsSecondary;
    } else {
      color = context.colors.buttonsSizdebarActive;
    }
    color ??= context.colors.buttonsSizdebarActive;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: TweenAnimationBuilder(
        tween: ColorTween(begin: context.colors.buttonsSizdebarActive, end: color),
        duration: Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Material(
            color: value,
            child: child,
          );
        },
        child: InkWell(
          highlightColor: context.colors.textsPrimary!.withOpacity(0.2),
          onTap: () {
            ref.read(menuControllerProvider).switchMenu();
            setState(() {
              angle = math.pi / 4 - angle;
              if (color == context.colors.buttonsSizdebarActive) {
                color = context.colors.buttonsSecondary;
              } else {
                color = context.colors.buttonsSizdebarActive;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              duration: Duration(milliseconds: 300),
              builder: ((context, value, child) {
                return Transform.rotate(
                  angle: value,
                  child: child,
                );
              }),
              child: SvgPicture.asset(
                'assets/icons/ic_plus.svg',
                colorFilter: ColorFilter.mode(
                  context.colors.iconsFAB!,
                  BlendMode.srcIn,
                ),
                width: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem(
      {Key? key,
      this.onTap,
      required this.icon,
      this.activeIcon,
      required this.active})
      : super(key: key);
  final void Function()? onTap;
  final Widget icon;
  final Widget? activeIcon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: active && activeIcon != null ? activeIcon : icon,
          ),
        ),
      ),
    );
  }
}
