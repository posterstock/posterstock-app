import 'package:flutter/material.dart';

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    Key? key,
    this.onTap,
    required this.icon,
    this.activeIcon,
    required this.active,
  }) : super(key: key);
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
