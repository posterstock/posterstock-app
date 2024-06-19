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
        color: !context.mounted
            ? Colors.black
            : context.colors.backgroundsSecondary,
      ),
    );
    return SnackBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 4),
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
                placeholderFadeInDuration: CustomDurations.cachedDuration,
                fadeInDuration: CustomDurations.cachedDuration,
                fadeOutDuration: CustomDurations.cachedDuration,
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
              style: !context.mounted
                  ? const TextStyle(color: Colors.white)
                  : context.textStyles.bodyRegular!.copyWith(
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SnackFactory {
  static SnackBar image(
    BuildContext context,
    String url,
    String text, {
    Duration? duration,
  }) {
    final shimmer = ShimmerLoader(
      child: Container(
        color: !context.mounted
            ? Colors.black
            : context.colors.backgroundsSecondary,
      ),
    );
    final image = CachedNetworkImage(
      width: 36,
      height: 36,
      imageUrl: url,
      fit: BoxFit.cover,
      fadeInDuration: CustomDurations.cachedDuration,
      fadeOutDuration: CustomDurations.cachedDuration,
      placeholderFadeInDuration: CustomDurations.cachedDuration,
      placeholder: (_, child) => shimmer,
      errorWidget: (_, obj, trace) => shimmer,
    );
    return _snack(context, image, text, duration);
  }

  static SnackBar text(
    BuildContext context,
    String text, {
    Duration? duration,
  }) {
    final icon = SvgPicture.asset('assets/images/dark_logo.svg', width: 36);
    return _snack(context, icon, text, duration);
  }

  static SnackBar _snack(
    BuildContext context,
    Widget image,
    String text, [
    Duration? duration,
  ]) {
    final snackDuration = duration ?? const Duration(seconds: 4);
    return SnackBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      duration: snackDuration,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Row(
        children: [
          image,
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              //TODO: refactor
              style: !context.mounted
                  ? const TextStyle(color: Colors.white)
                  : context.textStyles.bodyRegular!.copyWith(
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
