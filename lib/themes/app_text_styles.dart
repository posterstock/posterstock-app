import 'package:flutter/material.dart';
import 'package:poster_stock/themes/app_colors.dart';

class AppAllTextStyles extends AppTextStyles {
  AppAllTextStyles(AppColors colors)
      : super(
          title2: TextStyle(
            fontFamily: 'SF-Pro-Display',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            height: 28 / 22,
            letterSpacing: 0.35,
            color: colors.textsPrimary,
          ),
          title3: TextStyle(
            fontFamily: 'SF-Pro-Display',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            height: 25 / 20,
            letterSpacing: 0.38,
            color: colors.textsPrimary,
          ),
          calloutBold: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 21 / 16,
            letterSpacing: -0.32,
            color: colors.textsPrimary,
          ),
          callout: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 21 / 16,
            letterSpacing: -0.32,
            color: colors.textsDisabled,
          ),
          caption2: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w400,
            fontSize: 11,
            height: 13 / 11,
            letterSpacing: 0.07,
            color: colors.textsDisabled,
          ),
          caption1: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16 / 12,
            color: colors.textsError,
          ),
          bodyRegular: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w400,
            fontSize: 17,
            height: 22 / 17,
            letterSpacing: -0.41,
            color: colors.textsPrimary,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w500,
            fontSize: 17,
            height: 22 / 17,
            letterSpacing: -0.41,
            color: colors.textsPrimary,
          ),
          bodyBold: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 22 / 17,
            letterSpacing: -0.41,
            color: colors.textsPrimary,
          ),
          footNote: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            height: 18 / 13,
            letterSpacing: -0.08,
            color: colors.textsPrimary,
          ),
          subheadlineBold: TextStyle(
            fontFamily: 'SF-Pro-Text-IOS',
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: 20 / 15,
            letterSpacing: -0.5,
            color: colors.textsPrimary,
            fontFamilyFallback: ['SF-Pro-Display'],
          ),
          subheadline: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            height: 20 / 15,
            letterSpacing: -0.24,
            color: colors.textsPrimary,
          ),
          headline: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            height: 22 / 15,
            letterSpacing: -0.41,
            color: colors.textsPrimary,
          ),
        );
}

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.title2,
    required this.title3,
    required this.callout,
    required this.calloutBold,
    required this.caption2,
    required this.caption1,
    required this.bodyRegular,
    required this.bodyMedium,
    required this.bodyBold,
    required this.footNote,
    required this.subheadlineBold,
    required this.subheadline,
    required this.headline,
  });

  final TextStyle? title2;
  final TextStyle? title3;
  final TextStyle? callout;
  final TextStyle? calloutBold;
  final TextStyle? caption2;
  final TextStyle? caption1;
  final TextStyle? bodyRegular;
  final TextStyle? bodyMedium;
  final TextStyle? bodyBold;
  final TextStyle? footNote;
  final TextStyle? subheadlineBold;
  final TextStyle? subheadline;
  final TextStyle? headline;

  @override
  ThemeExtension<AppTextStyles> copyWith({
    final TextStyle? title2,
    final TextStyle? title3,
    final TextStyle? callout,
    final TextStyle? calloutBold,
    final TextStyle? caption2,
    final TextStyle? caption1,
    final TextStyle? bodyRegular,
    final TextStyle? bodyBold,
    final TextStyle? footNote,
    final TextStyle? subheadlineBold,
    final TextStyle? subheadline,
    final TextStyle? headline,
  }) {
    return AppTextStyles(
      title2: title2 ?? this.title2,
      title3: title3 ?? this.title3,
      callout: callout ?? this.callout,
      calloutBold: calloutBold ?? this.calloutBold,
      caption2: caption2 ?? this.caption2,
      caption1: caption1 ?? this.caption1,
      bodyRegular: bodyRegular ?? this.bodyRegular,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodyBold: bodyBold ?? this.bodyBold,
      footNote: footNote ?? this.footNote,
      subheadlineBold: subheadlineBold ?? this.subheadlineBold,
      subheadline: subheadline ?? this.subheadline,
      headline: headline ?? this.headline,
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
      title3: TextStyle.lerp(title3, other.title3, t),
      callout: TextStyle.lerp(callout, other.callout, t),
      calloutBold: TextStyle.lerp(calloutBold, other.calloutBold, t),
      caption2: TextStyle.lerp(caption2, other.caption2, t),
      caption1: TextStyle.lerp(caption1, other.caption1, t),
      bodyRegular: TextStyle.lerp(bodyRegular, other.bodyRegular, t),
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t),
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t),
      footNote: TextStyle.lerp(footNote, other.footNote, t),
      subheadlineBold:
          TextStyle.lerp(subheadlineBold, other.subheadlineBold, t),
      subheadline: TextStyle.lerp(subheadline, other.subheadline, t),
      headline: TextStyle.lerp(headline, other.headline, t),
    );
  }
}
