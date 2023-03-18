import 'package:flutter/material.dart';
import 'package:poster_stock/themes/app_colors.dart';

class AppAllTextStyles extends AppTextStyles {
  AppAllTextStyles(AppColors colors)
      : super(
          title2: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            letterSpacing: 0.35,
            color: colors.textsPrimary,
          ),
          calloutBold: TextStyle(
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 21 / 16,
            letterSpacing: -0.32,
            color: colors.textsPrimary,
          ),
          callout: TextStyle(
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 21 / 16,
            letterSpacing: -0.32,
            color: colors.textsDisabled,
          ),
          caption2: TextStyle(
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w400,
            fontSize: 11,
            height: 13 / 11,
            letterSpacing: 0.07,
            color: colors.textsDisabled,
          ),
          caption: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16 / 12,
            color: colors.textsError,
          ),
          bodyRegular: TextStyle(
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w400,
            fontSize: 17,
            height: 22 / 17,
            letterSpacing: -0.41,
            color: colors.textsPrimary,
          ),
        );
}

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.title2,
    required this.callout,
    required this.calloutBold,
    required this.caption2,
    required this.caption,
    required this.bodyRegular,
  });

  final TextStyle? title2;
  final TextStyle? callout;
  final TextStyle? calloutBold;
  final TextStyle? caption2;
  final TextStyle? caption;
  final TextStyle? bodyRegular;

  @override
  ThemeExtension<AppTextStyles> copyWith({
    final TextStyle? title2,
    final TextStyle? callout,
    final TextStyle? calloutBold,
    final TextStyle? caption2,
    final TextStyle? caption,
    final TextStyle? bodyRegular,
  }) {
    return AppTextStyles(
      title2: title2 ?? this.title2,
      callout: callout ?? this.callout,
      calloutBold: calloutBold ?? this.calloutBold,
      caption2: caption2 ?? this.caption2,
      caption: caption ?? this.caption,
      bodyRegular: bodyRegular ?? this.bodyRegular,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(
      ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      title2: TextStyle.lerp(title2, other.title2, t),
      callout: TextStyle.lerp(callout, other.callout, t),
      calloutBold: TextStyle.lerp(calloutBold, other.calloutBold, t),
      caption2: TextStyle.lerp(caption2, other.caption2, t),
      caption: TextStyle.lerp(caption, other.caption, t),
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t),
    );
  }
}
