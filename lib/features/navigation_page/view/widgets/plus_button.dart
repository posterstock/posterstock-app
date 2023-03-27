import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../controller/menu_controller.dart';
import '../../state_holder/menu_state_holder.dart';

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
      angle = math.pi / 4;
    } else {
      color = context.colors.buttonsSizdebarActive;
      angle = 0;
    }
    color ??= context.colors.buttonsSizdebarActive;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: TweenAnimationBuilder(
        tween:
            ColorTween(begin: context.colors.buttonsSizdebarActive, end: color),
        duration: const Duration(milliseconds: 300),
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
              duration: const Duration(milliseconds: 300),
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
                width: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
