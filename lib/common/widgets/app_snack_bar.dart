import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/constants/durations.dart';
import 'package:poster_stock/features/home/view/widgets/shimmer_loader.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SnackBars {
  static SnackBar build(BuildContext context, String? image, String text,
      {Duration? duration}) {
    final shimmer = ShimmerLoader(
      child: Container(
        color: context.colors.backgroundsSecondary,
      ),
    );
    return SnackBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      behavior: SnackBarBehavior.floating,
      duration: duration ?? Duration(seconds: 4),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      content: Row(
        children: [
          if (image == null)
            SvgPicture.asset(
              'assets/images/dark_logo.svg',
              width: 36,
            ),
          if (image != null)
            SizedBox(
              width: 36,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholderFadeInDuration: Durations.cachedDuration,
                fadeInDuration: Durations.cachedDuration,
                fadeOutDuration: Durations.cachedDuration,
                placeholder: (context, child) {
                  return shimmer;
                },
                errorWidget: (context, obj, trace) {
                  return shimmer;
                },
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: context.textStyles.bodyRegular!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
