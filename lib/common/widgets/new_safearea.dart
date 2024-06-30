import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ColoredSafeArea extends StatelessWidget {
  final Widget child;

  const ColoredSafeArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundsPrimary,
      child: SafeArea(
        child: Container(
          color: context.colors.backgroundsPrimary,
          child: child,
        ),
      ),
    );
  }
}
