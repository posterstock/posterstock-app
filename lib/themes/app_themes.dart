import 'package:flutter/material.dart';
import 'package:poster_stock/themes/app_colors.dart';

import 'app_text_styles.dart';

class AppThemes {
  static const _appLightColors = AppLightColors();
  static final _appLightTextStyles = AppAllTextStyles(_appLightColors);
  static const _appDarkColors = AppDarkColors();
  static final _appDarkTextStyles = AppAllTextStyles(_appDarkColors);

  static final lightThemeData = ThemeData.light().copyWith(
      scaffoldBackgroundColor: _appLightColors.backgroundsPrimary,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: _appLightColors.backgroundsPrimary),
      splashColor: Colors.transparent,
      highlightColor: _appLightColors.backgroundsSecondary,
      extensions: [
        _appLightColors,
        _appLightTextStyles,
      ]);

  static final darkThemeData = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: _appDarkColors.backgroundsPrimary,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: _appDarkColors.backgroundsPrimary),
      splashColor: Colors.transparent,
      highlightColor: _appDarkColors.backgroundsSecondary,
      extensions: [
        _appDarkColors,
        _appDarkTextStyles,
      ]);
}
