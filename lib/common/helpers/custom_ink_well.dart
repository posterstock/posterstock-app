import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CustomInkWell extends StatefulWidget {
  const CustomInkWell({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  final Widget? child;
  final void Function() onTap;

  @override
  CustomInkWellState createState() => CustomInkWellState();
}

class CustomInkWellState extends State<CustomInkWell>
    with TickerProviderStateMixin {
  static const duration = Duration(milliseconds: 100);

  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: duration,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        controller.animateTo(1);
      },
      onTapUp: (details) {
        Future.delayed(duration, () {
          widget.onTap();
          controller.animateTo(0);
        });
      },
      onTapCancel: () {
        controller.animateTo(0);
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            color: Color.lerp(
              context.colors.backgroundsSecondary!.withOpacity(0),
              context.colors.backgroundsSecondary!,
              controller.value,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
