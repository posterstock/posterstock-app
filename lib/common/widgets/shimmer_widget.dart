import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) => ShimmerLoader(
        child: Container(
          color: context.colors.backgroundsSecondary,
        ),
      );
}
