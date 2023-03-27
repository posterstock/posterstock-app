import 'package:flutter/material.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    Key? key,
    required this.child,
    this.loaded = false,
  }) : super(key: key);

  final bool loaded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loaded) return SizedBox(child: child);
    return Shimmer.fromColors(
      baseColor: context.colors.fieldsHover!,
      highlightColor: context.colors.backgroundsPrimary!,
      child: child,
    );
  }
}
