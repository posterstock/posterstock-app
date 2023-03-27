import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../themes/app_themes.dart';

final themeStateHolderProvider =
    StateNotifierProvider<ThemeStateHolder, ThemeData>(
  (ref) => ThemeStateHolder(
    SchedulerBinding.instance.window.platformBrightness == Brightness.light ? AppThemes.lightThemeData : AppThemes.darkThemeData,
  ),
);

class ThemeStateHolder extends StateNotifier<ThemeData> {
  ThemeStateHolder(super.state);

  void updateState(ThemeData data) {
    state = data;
  }
}
