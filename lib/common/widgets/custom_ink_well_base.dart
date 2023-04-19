import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CustomInkWellBase extends StatefulWidget {
  const CustomInkWellBase(
      {Key? key, this.width, this.height, this.child, required this.onTap})
      : super(key: key);
  final double? width;
  final double? height;
  final Widget? child;
  final void Function() onTap;

  @override
  State<CustomInkWellBase> createState() => _CustomInkWellBaseState();
}

class _CustomInkWellBaseState extends State<CustomInkWellBase> {
  Color? color;

  @override
  Widget build(BuildContext context) {
    color ??= context.colors.backgroundsPrimary!;
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          color = context.colors.backgroundsSecondary!;
        });
      },
      onTapUp: (details) async {
        await Future.delayed(
          const Duration(milliseconds: 120),
        );
        setState(() {
          color = context.colors.backgroundsPrimary!;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          color = context.colors.backgroundsPrimary!;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: color!,
        width: widget.width,
        height: widget.height,
        child: widget.child,
      ),
    );
  }
}
